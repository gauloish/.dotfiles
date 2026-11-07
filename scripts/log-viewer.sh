#!/usr/bin/env bash
# CLI utility to list, filter, inspect, and navigate dotfiles execution logs across sessions.

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./utils/core.sh
source "${SCRIPT_DIR}/utils/core.sh"

usage() {
    cat <<EOF
Dotfiles Log Viewer

Usage:
  ./scripts/log-viewer.sh [OPTIONS] [SCRIPT_NAME]

Options:
  --list                     List logs in the target session (default action)
  --sessions, --timestamps   List all available execution sessions / timestamps
  -s, --session <timestamp>  Target specific session timestamp (default: 'latest')
                             Accepts 'latest', exact timestamp, or partial string
  --status <filter>          Filter by status: success, ok, failed, fail, skipped, skip, blocked
                             (supports comma-separated values, e.g. --status failed,blocked)
  --failed                   Print full logs of all FAILED scripts (shorthand for --status failed --print)
  --print                    Print full content of filtered logs (instead of listing table)
  --errors                   Filter printed log output to show only [WARN] and [ERROR] entries
  --pager                    Open output in 'less -R'
  -h, --help                 Show this help message

Examples:
  # List all past execution sessions / timestamps
  ./scripts/log-viewer.sh --sessions

  # List logs from the latest session
  ./scripts/log-viewer.sh
  ./scripts/log-viewer.sh --list

  # Filter logs by status in the latest session
  ./scripts/log-viewer.sh --status failed
  ./scripts/log-viewer.sh --status skipped
  ./scripts/log-viewer.sh --status failed,blocked
  ./scripts/log-viewer.sh --status success

  # List logs from a specific past session
  ./scripts/log-viewer.sh --session 2026-11-07_00-12-12
  ./scripts/log-viewer.sh --session 2026-11-07_00-12-12 --status failed

  # View a specific script log from latest or specific session
  ./scripts/log-viewer.sh install-neovim
  ./scripts/log-viewer.sh install/neovim --errors
  ./scripts/log-viewer.sh configure-gnome-tools --session 2026-11-07_00-12-12

  # Print all failed logs from latest or a specific session
  ./scripts/log-viewer.sh --failed
  ./scripts/log-viewer.sh --status failed --print --session 2026-11-07_00-12-12
EOF
}

resolve_session_dir() {
    local target="$1"

    if [[ ! -d "${DOTFILES_LOGS_DIR}" ]]; then
        printf "%sError:%s Logs directory does not exist (%s)\n" \
            "${C_BOLD_RED}" "${C_RESET}" "${DOTFILES_LOGS_DIR}" >&2
        return 1
    fi

    if [[ "${target}" == "latest" ]]; then
        local latest_path="${DOTFILES_LOGS_DIR}/latest"
        if [[ ! -d "${latest_path}" ]]; then
            printf "%sError:%s No latest log session found in %s\n" \
                "${C_BOLD_RED}" "${C_RESET}" "${DOTFILES_LOGS_DIR}" >&2
            return 1
        fi
        printf "%s\n" "${latest_path}"
        return 0
    fi

    # Exact directory check
    if [[ -d "${DOTFILES_LOGS_DIR}/${target}" ]]; then
        printf "%s\n" "${DOTFILES_LOGS_DIR}/${target}"
        return 0
    fi

    if [[ -d "${target}" ]]; then
        printf "%s\n" "${target}"
        return 0
    fi

    # Partial match resolution
    local matches=()
    while IFS= read -r line; do
        [[ -n "${line}" ]] && matches+=("${line}")
    done < <(find "${DOTFILES_LOGS_DIR}" -mindepth 1 -maxdepth 1 -type d -name "*${target}*" ! -name "latest" | sort -r)

    if [[ ${#matches[@]} -eq 1 ]]; then
        printf "%s\n" "${matches[0]}"
        return 0
    elif [[ ${#matches[@]} -gt 1 ]]; then
        printf "%sNote:%s Multiple sessions matched '%s', selecting newest: %s\n" \
            "${C_YELLOW}" "${C_RESET}" "${target}" "$(basename "${matches[0]}")" >&2
        printf "%s\n" "${matches[0]}"
        return 0
    fi

    printf "%sError:%s Session matching '%s' not found in %s.\n" \
        "${C_BOLD_RED}" "${C_RESET}" "${target}" "${DOTFILES_LOGS_DIR}" >&2
    printf "Run '%s./scripts/log-viewer.sh --sessions%s' to view available timestamps.\n\n" \
        "${C_BOLD}" "${C_RESET}" >&2
    return 1
}

matches_status_filter() {
    local actual_status="$1"
    local filter_csv="$2"

    if [[ -z "${filter_csv}" ]]; then
        return 0
    fi

    local normalized_actual
    normalized_actual="$(printf "%s" "${actual_status}" | tr '[:lower:]' '[:upper:]')"

    local token
    IFS=',' read -ra tokens <<< "${filter_csv}"
    for token in "${tokens[@]}"; do
        token="$(printf "%s" "${token}" | tr '[:lower:]' '[:upper:]' | xargs)"
        case "${token}" in
            SUCCESS|OK)
                [[ "${normalized_actual}" == "SUCCESS" ]] && return 0
                ;;
            FAIL|FAILED)
                [[ "${normalized_actual}" == "FAILED" ]] && return 0
                ;;
            SKIP|SKIPPED)
                [[ "${normalized_actual}" == "SKIPPED" ]] && return 0
                ;;
            BLOCK|BLOCKED)
                [[ "${normalized_actual}" == "BLOCKED" ]] && return 0
                ;;
            *)
                [[ "${normalized_actual}" == "${token}" ]] && return 0
                ;;
        esac
    done

    return 1
}

format_session_datetime() {
    local sess="$1"
    if [[ "${sess}" =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})_([0-9]{2})-([0-9]{2})-([0-9]{2})$ ]]; then
        printf "%s-%s-%s %s:%s:%s\n" \
            "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}" \
            "${BASH_REMATCH[4]}" "${BASH_REMATCH[5]}" "${BASH_REMATCH[6]}"
    else
        printf "%s\n" "${sess}"
    fi
}

get_log_status_fallback() {
    local log_file="$1"
    local script_id="$2"
    local session_name="$3"

    # 1. Try checking state/status.tsv
    local state_file
    state_file="$(state_file_path)"
    if [[ -f "${state_file}" ]]; then
        local line
        line="$(awk -F'\t' -v sf="logs/${session_name}/" -v id="${script_id}" '
            $1 == id && index($6, sf) > 0 { print $2, $3, $4; exit }
        ' "${state_file}")"

        if [[ -n "${line}" ]]; then
            local st sub ec
            read -r st sub ec <<< "${line}"
            if [[ "${st}" == "SUCCESS" && "${sub}" == "SKIP" ]]; then
                printf "SKIPPED\t-\n"
                return 0
            elif [[ "${st}" == "SUCCESS" ]]; then
                printf "SUCCESS\t-\n"
                return 0
            elif [[ "${st}" == "FAILED" ]]; then
                printf "FAILED\t-\n"
                return 0
            elif [[ "${st}" == "BLOCKED" ]]; then
                printf "BLOCKED\t-\n"
                return 0
            fi
        fi
    fi

    # 2. Inspect log file contents
    if [[ -f "${log_file}" ]]; then
        if grep -qE '^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\] \[ERROR\]' "${log_file}" 2>/dev/null; then
            printf "FAILED\t-\n"
            return 0
        elif grep -qE '^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\] \[SKIP \]' "${log_file}" 2>/dev/null && \
             ! grep -qE '^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\] \[OK   \]' "${log_file}" 2>/dev/null; then
            printf "SKIPPED\t-\n"
            return 0
        elif grep -qE '^\[[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\] \[OK   \]' "${log_file}" 2>/dev/null; then
            printf "SUCCESS\t-\n"
            return 0
        fi
    fi

    printf "UNKNOWN\t-\n"
}

list_all_sessions() {
    if [[ ! -d "${DOTFILES_LOGS_DIR}" ]]; then
        printf "%s[INFO]%s No logs directory found in %s.\n" "${C_BOLD_BLUE}" "${C_RESET}" "${DOTFILES_LOGS_DIR}"
        return 0
    fi

    local latest_target=""
    if [[ -L "${DOTFILES_LOGS_DIR}/latest" ]]; then
        latest_target="$(readlink -f "${DOTFILES_LOGS_DIR}/latest" 2>/dev/null || true)"
    fi

    local sessions=()
    while IFS= read -r dir; do
        [[ -n "${dir}" && -d "${dir}" ]] && sessions+=("${dir}")
    done < <(find "${DOTFILES_LOGS_DIR}" -mindepth 1 -maxdepth 1 -type d ! -name "latest" | sort -r)

    if [[ ${#sessions[@]} -eq 0 ]]; then
        printf "%s[INFO]%s No execution sessions recorded.\n" "${C_BOLD_BLUE}" "${C_RESET}"
        return 0
    fi

    printf "%sAvailable Log Sessions (%d total):%s\n\n" "${C_BOLD}" "${#sessions[@]}" "${C_RESET}"
    printf "  %-22s %-20s %-12s %s\n" "SESSION (TIMESTAMP)" "DATE & TIME" "SCRIPTS" "SUMMARY / FLAG"
    printf "  %-22s %-20s %-12s %s\n" "-------------------" "-----------" "-------" "--------------"

    local dir sess_name is_latest dt
    for dir in "${sessions[@]}"; do
        sess_name="$(basename "${dir}")"
        is_latest=""
        if [[ -n "${latest_target}" && "$(readlink -f "${dir}")" == "${latest_target}" ]]; then
            is_latest="${C_BOLD_CYAN}(latest)${C_RESET}"
        fi

        dt="$(format_session_datetime "${sess_name}")"

        # Check session.tsv or count logs
        local ok=0 skip=0 fail=0 block=0 total=0
        if [[ -f "${dir}/session.tsv" ]]; then
            while IFS=$'\t' read -r _id st sub _ec _dur; do
                [[ "${_id}" =~ ^# || -z "${_id}" ]] && continue
                total=$((total + 1))
                case "${st}" in
                    SUCCESS)
                        if [[ "${sub}" == "SKIP" ]]; then
                            skip=$((skip + 1))
                        else
                            ok=$((ok + 1))
                        fi
                        ;;
                    FAILED)  fail=$((fail + 1)) ;;
                    BLOCKED) block=$((block + 1)) ;;
                esac
            done < "${dir}/session.tsv"
        else
            local log_files=()
            while IFS= read -r lf; do
                [[ -n "${lf}" ]] && log_files+=("${lf}")
            done < <(find "${dir}" -maxdepth 1 -type f -name "*.log" 2>/dev/null)
            total=${#log_files[@]}
            local lf
            for lf in "${log_files[@]}"; do
                if grep -q "\[ERROR\]" "${lf}" 2>/dev/null; then
                    fail=$((fail + 1))
                elif grep -q "\[SKIP \]" "${lf}" 2>/dev/null && ! grep -q "\[OK   \]" "${lf}" 2>/dev/null; then
                    skip=$((skip + 1))
                else
                    ok=$((ok + 1))
                fi
            done
        fi

        local summary_parts=()
        [[ ${ok} -gt 0 ]] && summary_parts+=("${C_GREEN}${ok} ok${C_RESET}")
        [[ ${skip} -gt 0 ]] && summary_parts+=("${C_CYAN}${skip} skip${C_RESET}")
        [[ ${fail} -gt 0 ]] && summary_parts+=("${C_RED}${fail} fail${C_RESET}")
        [[ ${block} -gt 0 ]] && summary_parts+=("${C_YELLOW}${block} blocked${C_RESET}")

        local summary_str=""
        if [[ ${#summary_parts[@]} -gt 0 ]]; then
            local IFS=", "
            summary_str="${summary_parts[*]}"
        else
            summary_str="${C_GRAY}empty${C_RESET}"
        fi

        if [[ -n "${is_latest}" ]]; then
            summary_str="${summary_str}  ${is_latest}"
        fi

        printf "  %-22s %-20s %-12s %s\n" \
            "${sess_name}" "${dt}" "${total} scripts" "${summary_str}"
    done

    printf "\n%sTip:%s Use '%s./scripts/log-viewer.sh --session <timestamp>%s' to inspect any session.\n" \
        "${C_GRAY}" "${C_RESET}" "${C_BOLD}" "${C_RESET}"
}

list_session_logs() {
    local session_dir="$1"
    local status_filter="$2"

    local session_name
    session_name="$(basename "${session_dir}")"
    local resolved_target=""
    if [[ -L "${session_dir}" ]]; then
        resolved_target="$(readlink "${session_dir}" 2>/dev/null || true)"
        session_name="${resolved_target} (latest)"
    fi

    printf "%sLog Session:%s %s\n" "${C_BOLD}" "${C_RESET}" "${session_name}"
    if [[ -n "${status_filter}" ]]; then
        printf "%sStatus Filter:%s %s\n" "${C_BOLD}" "${C_RESET}" "${status_filter}"
    fi
    printf "\n"

    # Entries map: script_id -> [status, duration, log_path]
    declare -a item_ids=()
    declare -A item_status=()
    declare -A item_dur=()
    declare -A item_path=()

    if [[ -f "${session_dir}/session.tsv" ]]; then
        while IFS=$'\t' read -r s_id s_st s_sub _ec s_dur; do
            [[ "${s_id}" =~ ^# || -z "${s_id}" ]] && continue
            local disp_status="${s_st}"
            if [[ "${s_st}" == "SUCCESS" && "${s_sub}" == "SKIP" ]]; then
                disp_status="SKIPPED"
            elif [[ "${s_st}" == "SUCCESS" ]]; then
                disp_status="SUCCESS"
            fi

            local slug="${s_id//\//-}"
            local log_p="${session_dir}/${slug}.log"
            local log_disp="logs/${session_name% *}/${slug}.log"
            if [[ "${disp_status}" == "BLOCKED" ]]; then
                log_disp="(no log: blocked)"
            fi

            item_ids+=("${s_id}")
            item_status["${s_id}"]="${disp_status}"
            item_dur["${s_id}"]="${s_dur}s"
            item_path["${s_id}"]="${log_disp}"
        done < "${session_dir}/session.tsv"
    else
        # Collect from *.log files
        local files=()
        while IFS= read -r -d '' f; do
            files+=("${f}")
        done < <(find -L "${session_dir}" -maxdepth 1 -type f -name "*.log" -print0 2>/dev/null | sort -z)

        local f base s_id
        for f in "${files[@]}"; do
            base="$(basename "${f}" .log)"
            s_id="${base/-//}"
            local st_info
            st_info="$(get_log_status_fallback "${f}" "${s_id}" "${session_name% *}")"
            local st dur
            read -r st dur <<< "${st_info}"

            item_ids+=("${s_id}")
            item_status["${s_id}"]="${st}"
            item_dur["${s_id}"]="${dur}"
            item_path["${s_id}"]="logs/${session_name% *}/${base}.log"
        done
    fi

    local matched_count=0
    local count_ok=0 count_skip=0 count_fail=0 count_block=0

    # Table Header
    printf "  %-30s %-12s %-10s %s\n" "SCRIPT ID" "STATUS" "DURATION" "LOG PATH"
    printf "  %-30s %-12s %-10s %s\n" "---------" "------" "--------" "--------"

    local id st dur path st_color
    for id in "${item_ids[@]}"; do
        st="${item_status[${id}]}"
        dur="${item_dur[${id}]}"
        path="${item_path[${id}]}"

        if ! matches_status_filter "${st}" "${status_filter}"; then
            continue
        fi

        matched_count=$((matched_count + 1))
        case "${st}" in
            SUCCESS)
                st_color="${C_BOLD_GREEN}"
                count_ok=$((count_ok + 1))
                ;;
            SKIPPED)
                st_color="${C_BOLD_CYAN}"
                count_skip=$((count_skip + 1))
                ;;
            FAILED)
                st_color="${C_BOLD_RED}"
                count_fail=$((count_fail + 1))
                ;;
            BLOCKED)
                st_color="${C_BOLD_YELLOW}"
                count_block=$((count_block + 1))
                ;;
            *)
                st_color="${C_GRAY}"
                ;;
        esac

        printf "  %-30s %s%-12s%s %-10s %s\n" \
            "${id}" "${st_color}" "${st}" "${C_RESET}" "${dur}" "${path}"
    done

    if [[ ${matched_count} -eq 0 ]]; then
        if [[ -n "${status_filter}" ]]; then
            printf "  %sNo scripts found matching status '%s' in this session.%s\n" \
                "${C_GRAY}" "${status_filter}" "${C_RESET}"
        else
            printf "  %sNo log files found in this session.%s\n" "${C_GRAY}" "${C_RESET}"
        fi
        return 0
    fi

    printf "\n%sSummary:%s %d matched (%s%d ok%s, %s%d skipped%s, %s%d failed%s, %s%d blocked%s)\n" \
        "${C_BOLD}" "${C_RESET}" "${matched_count}" \
        "${C_GREEN}" "${count_ok}" "${C_RESET}" \
        "${C_CYAN}" "${count_skip}" "${C_RESET}" \
        "${C_RED}" "${count_fail}" "${C_RESET}" \
        "${C_YELLOW}" "${count_block}" "${C_RESET}"
}

resolve_log_file() {
    local query="$1"
    local session_dir="$2"

    # Direct file check
    if [[ -f "${query}" ]]; then
        printf "%s\n" "${query}"
        return 0
    fi

    if [[ ! -d "${session_dir}" ]]; then
        return 1
    fi

    local slug="${query%.log}"
    slug="${slug//\//-}"

    # Check if recorded as BLOCKED
    if [[ -f "${session_dir}/session.tsv" ]]; then
        local blocked_check
        blocked_check="$(awk -F'\t' -v id="${query}" -v slug="${slug}" '
            ($1 == id || $1 == slug) && $2 == "BLOCKED" { print "BLOCKED"; exit }
        ' "${session_dir}/session.tsv")"
        if [[ "${blocked_check}" == "BLOCKED" ]]; then
            printf "__BLOCKED__\n"
            return 0
        fi
    fi

    if [[ -f "${session_dir}/${slug}.log" ]]; then
        printf "%s\n" "${session_dir}/${slug}.log"
        return 0
    fi

    # Partial match
    local match
    match="$(find -L "${session_dir}" -maxdepth 1 -type f -name "*${slug}*.log" | sort | head -n 1 || true)"
    if [[ -n "${match}" && -f "${match}" ]]; then
        printf "%s\n" "${match}"
        return 0
    fi

    return 1
}

render_log_stream() {
    local file="$1"
    local errors_only="$2"

    if [[ "${errors_only}" -eq 1 ]]; then
        grep -E '\[(WARN|ERROR)[[:space:]]*\]' "${file}" || \
            printf "%sNo [WARN] or [ERROR] entries found in %s.%s\n" "${C_GRAY}" "$(basename "${file}")" "${C_RESET}"
    else
        cat "${file}"
    fi
}

show_filtered_logs() {
    local session_dir="$1"
    local status_filter="$2"
    local errors_only="$3"

    local session_name
    session_name="$(basename "${session_dir}")"

    # Gather matching scripts and logs
    local found=0

    if [[ -f "${session_dir}/session.tsv" ]]; then
        while IFS=$'\t' read -r s_id s_st s_sub _ec _dur; do
            [[ "${s_id}" =~ ^# || -z "${s_id}" ]] && continue
            local disp_status="${s_st}"
            if [[ "${s_st}" == "SUCCESS" && "${s_sub}" == "SKIP" ]]; then
                disp_status="SKIPPED"
            elif [[ "${s_st}" == "SUCCESS" ]]; then
                disp_status="SUCCESS"
            fi

            if ! matches_status_filter "${disp_status}" "${status_filter}"; then
                continue
            fi

            found=1
            local slug="${s_id//\//-}"
            local log_f="${session_dir}/${slug}.log"
            printf "\n%s=== [%s] (%s) ===%s\n" "${C_BOLD}" "${s_id}" "${disp_status}" "${C_RESET}"
            if [[ -f "${log_f}" ]]; then
                render_log_stream "${log_f}" "${errors_only}"
            else
                printf "%sNo log file available on disk for %s (status: %s)%s\n" \
                    "${C_YELLOW}" "${s_id}" "${disp_status}" "${C_RESET}"
            fi
        done < "${session_dir}/session.tsv"
    else
        # Collect from *.log files
        local files=()
        while IFS= read -r -d '' f; do
            files+=("${f}")
        done < <(find -L "${session_dir}" -maxdepth 1 -type f -name "*.log" -print0 2>/dev/null | sort -z)

        local f base s_id st_info st dur
        for f in "${files[@]}"; do
            base="$(basename "${f}" .log)"
            s_id="${base/-//}"
            st_info="$(get_log_status_fallback "${f}" "${s_id}" "${session_name}")"
            read -r st dur <<< "${st_info}"

            if ! matches_status_filter "${st}" "${status_filter}"; then
                continue
            fi

            found=1
            printf "\n%s=== [%s] (%s) ===%s\n" "${C_BOLD}" "${s_id}" "${st}" "${C_RESET}"
            render_log_stream "${f}" "${errors_only}"
        done
    fi

    if [[ ${found} -eq 0 ]]; then
        printf "%s[OK]%s No scripts matching status '%s' found in session %s.\n" \
            "${C_BOLD_GREEN}" "${C_RESET}" "${status_filter}" "${session_name}"
    fi
}

main() {
    local action="list"
    local session_target="latest"
    local status_filter=""
    local target_query=""
    local errors_only=0
    local use_pager=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --list)
                action="list"
                shift
                ;;
            --sessions|--timestamps)
                action="sessions"
                shift
                ;;
            -s|--session|--timestamp)
                if [[ $# -lt 2 ]]; then
                    printf "%sError:%s %s requires a timestamp argument\n" "${C_BOLD_RED}" "${C_RESET}" "$1" >&2
                    exit 1
                fi
                session_target="$2"
                shift 2
                ;;
            --status)
                if [[ $# -lt 2 ]]; then
                    printf "%sError:%s --status requires a status value (e.g. failed, skipped, success, blocked)\n" \
                        "${C_BOLD_RED}" "${C_RESET}" >&2
                    exit 1
                fi
                status_filter="$2"
                shift 2
                ;;
            --failed)
                action="print"
                status_filter="failed"
                shift
                ;;
            --print)
                action="print"
                shift
                ;;
            --errors)
                errors_only=1
                shift
                ;;
            --pager)
                use_pager=1
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                printf "%sError:%s Unknown option '%s'\n\n" "${C_BOLD_RED}" "${C_RESET}" "$1" >&2
                usage >&2
                exit 1
                ;;
            *)
                action="view"
                target_query="$1"
                shift
                ;;
        esac
    done

    # If action is sessions, list sessions directly
    if [[ "${action}" == "sessions" ]]; then
        if [[ ${use_pager} -eq 1 ]]; then
            list_all_sessions | less -R
        else
            list_all_sessions
        fi
        return 0
    fi

    # Resolve target session directory
    local session_dir
    session_dir="$(resolve_session_dir "${session_target}")"

    case "${action}" in
        list)
            if [[ ${use_pager} -eq 1 ]]; then
                list_session_logs "${session_dir}" "${status_filter}" | less -R
            else
                list_session_logs "${session_dir}" "${status_filter}"
            fi
            ;;
        print)
            local filter="${status_filter:-failed}"
            if [[ ${use_pager} -eq 1 ]]; then
                show_filtered_logs "${session_dir}" "${filter}" "${errors_only}" | less -R
            else
                show_filtered_logs "${session_dir}" "${filter}" "${errors_only}"
            fi
            ;;
        view)
            local log_file=""
            if ! log_file="$(resolve_log_file "${target_query}" "${session_dir}")"; then
                printf "%sError:%s Log file for '%s' not found in session %s\n" \
                    "${C_BOLD_RED}" "${C_RESET}" "${target_query}" "$(basename "${session_dir}")" >&2
                exit 1
            fi

            if [[ "${log_file}" == "__BLOCKED__" ]]; then
                printf "%s[BLOCKED]%s '%s' was blocked by an unmet dependency in session %s (no log file generated).\n" \
                    "${C_BOLD_YELLOW}" "${C_RESET}" "${target_query}" "$(basename "${session_dir}")"
                exit 0
            fi

            if [[ ${use_pager} -eq 1 ]]; then
                render_log_stream "${log_file}" "${errors_only}" | less -R
            else
                render_log_stream "${log_file}" "${errors_only}"
            fi
            ;;
    esac
}

main "$@"
