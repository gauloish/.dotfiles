#!/usr/bin/env bash
# CLI utility to list, filter, and display ANSI-formatted execution logs.

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./utils/core.sh
source "${SCRIPT_DIR}/utils/core.sh"

usage() {
    cat <<EOF
Usage: ./scripts/log-viewer.sh [OPTIONS] [SCRIPT_NAME]

Options:
  --list          List available logs in logs/latest/ and recorded states (default)
  --failed        Print logs of all scripts currently marked as FAILED
  --errors        Filter output to show only [WARN] and [ERROR] entries
  --pager         Open the log output in 'less -R'
  -h, --help      Show this help message

Examples:
  ./scripts/log-viewer.sh --list
  ./scripts/log-viewer.sh install-neovim
  ./scripts/log-viewer.sh install/neovim --errors
  ./scripts/log-viewer.sh --failed
EOF
}

resolve_log_file() {
    local query="$1"
    local latest_dir="${DOTFILES_LOGS_DIR}/latest"

    # Direct file path check
    if [[ -f "${query}" ]]; then
        printf "%s\n" "${query}"
        return 0
    fi

    if [[ ! -d "${latest_dir}" ]]; then
        return 1
    fi

    local slug="${query%.log}"
    slug="${slug//\//-}"

    if [[ -f "${latest_dir}/${slug}.log" ]]; then
        printf "%s\n" "${latest_dir}/${slug}.log"
        return 0
    fi

    # Match partial name (e.g., 'neovim' matches 'install-neovim.log' or 'configure-neovim.log')
    local match
    match="$(find "${latest_dir}" -maxdepth 1 -type f -name "*${slug}*.log" | sort | head -n 1 || true)"
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
        grep -E '\[(WARN|ERROR)[[:space:]]*\]' "${file}" || printf "%sNo [WARN] or [ERROR] entries found in %s.%s\n" "${C_GRAY}" "$(basename "${file}")" "${C_RESET}"
    else
        cat "${file}"
    fi
}

list_latest_logs() {
    local latest_dir="${DOTFILES_LOGS_DIR}/latest"
    if [[ ! -d "${latest_dir}" ]]; then
        printf "%s[INFO]%s No log sessions found in %s.\n" "${C_BOLD_BLUE}" "${C_RESET}" "${DOTFILES_LOGS_DIR}"
        return 0
    fi

    local resolved_session
    resolved_session="$(readlink "${latest_dir}" 2>/dev/null || basename "${latest_dir}")"
    printf "%sLatest Log Session:%s %s\n\n" "${C_BOLD}" "${C_RESET}" "${resolved_session}"

    local files=()
    while IFS= read -r -d '' f; do
        files+=("${f}")
    done < <(find -L "${latest_dir}" -maxdepth 1 -type f -name "*.log" -print0 2>/dev/null | sort -z)

    if [[ ${#files[@]} -eq 0 ]]; then
        printf "  %sNo log files in latest session.%s\n" "${C_GRAY}" "${C_RESET}"
        return 0
    fi

    printf "  %-28s %-12s %s\n" "LOG NAME" "STATUS" "PATH"
    printf "  %-28s %-12s %s\n" "--------" "------" "----"

    local f base script_id st st_color
    for f in "${files[@]}"; do
        base="$(basename "${f}" .log)"
        script_id="${base/-//}"
        st="$(state_get_status "${script_id}")"
        case "${st}" in
            SUCCESS) st_color="${C_BOLD_GREEN}" ;;
            FAILED)  st_color="${C_BOLD_RED}" ;;
            BLOCKED) st_color="${C_BOLD_YELLOW}" ;;
            *)       st_color="${C_GRAY}" ;;
        esac
        printf "  %-28s %s%-12s%s logs/latest/%s.log\n" \
            "${base}" "${st_color}" "${st}" "${C_RESET}" "${base}"
    done
}

show_failed_logs() {
    local errors_only="$1"
    local state_file
    state_file="$(state_file_path)"

    if [[ ! -f "${state_file}" ]]; then
        printf "%s[INFO]%s No state file found (%s).\n" "${C_BOLD_BLUE}" "${C_RESET}" "${state_file}"
        return 0
    fi

    local found=0
    while IFS=$'\t' read -r s_id s_status _sub _ec _ts s_log; do
        [[ "${s_id}" =~ ^# || -z "${s_id}" ]] && continue
        if [[ "${s_status}" == "FAILED" ]]; then
            found=1
            local abs_log="${DOTFILES_ROOT}/${s_log}"
            printf "\n%s=== [%s] (%s) ===%s\n" "${C_BOLD_RED}" "${s_id}" "${s_log}" "${C_RESET}"
            if [[ -f "${abs_log}" ]]; then
                render_log_stream "${abs_log}" "${errors_only}"
            else
                printf "%sLog file not found: %s%s\n" "${C_RED}" "${abs_log}" "${C_RESET}"
            fi
        fi
    done < "${state_file}"

    if [[ ${found} -eq 0 ]]; then
        printf "%s[OK]%s No failed scripts recorded in state.\n" "${C_BOLD_GREEN}" "${C_RESET}"
    fi
}

main() {
    local action="list"
    local target_query=""
    local errors_only=0
    local use_pager=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --list)
                action="list"
                shift
                ;;
            --failed)
                action="failed"
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

    case "${action}" in
        list)
            list_latest_logs
            ;;
        failed)
            if [[ ${use_pager} -eq 1 ]]; then
                show_failed_logs "${errors_only}" | less -R
            else
                show_failed_logs "${errors_only}"
            fi
            ;;
        view)
            local log_file=""
            if ! log_file="$(resolve_log_file "${target_query}")"; then
                printf "%sError:%s Log file for '%s' not found in logs/latest/\n" \
                    "${C_BOLD_RED}" "${C_RESET}" "${target_query}" >&2
                exit 1
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
