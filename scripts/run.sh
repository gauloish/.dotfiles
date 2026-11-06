#!/usr/bin/env bash
# Main Dotfiles Orchestrator.
# Discovers scripts, resolves dependencies, manages state, displays a clean TUI,
# redirects detailed per-script ANSI logs to logs/<timestamp>/, and reports failures.

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_ORCHESTRATED=1
# shellcheck source=./utils/core.sh
source "${SCRIPT_DIR}/utils/core.sh"

# Runtime configuration flags
MODE="all"              # all | phase | resume | only
TARGET_PHASE=""         # install | configure
ONLY_TARGETS=""         # comma-separated script IDs
RESOLVE_DEPS=1          # 1 = check/include dependencies, 0 = ignore dependencies (--no-deps)
REQUIRE_SUDO="auto"     # auto | yes | no
SUDO_KEEPALIVE_PID=""

# Associative maps for discovered scripts
declare -A SCRIPT_PATH_MAP=()
declare -A SCRIPT_NAME_MAP=()
declare -A SCRIPT_PHASE_MAP=()
declare -A SCRIPT_ORDER_MAP=()
declare -A SCRIPT_DEPS_MAP=()
declare -A SESSION_STATUS_MAP=()
declare -A FAILED_LOG_MAP=()
declare -a ALL_DISCOVERED_IDS=()
declare -a EXECUTION_QUEUE=()

usage() {
    cat <<EOF
Usage: ./scripts/run.sh [OPTIONS]

Options:
  --phase <install|configure>  Run only scripts from the specified phase
  --resume, --failed           Run only scripts with status FAILED, BLOCKED, or PENDING
  --only <id[,id...]>          Run specific script(s) (e.g. install/neovim,configure/neovim)
  --no-deps                    Do not check or auto-include dependencies when using --only
  --no-sudo                    Skip upfront sudo authentication prompt
  -h, --help                   Show this help message
EOF
}

cleanup_orchestrator() {
    if [[ -n "${SUDO_KEEPALIVE_PID}" ]]; then
        kill "${SUDO_KEEPALIVE_PID}" 2>/dev/null || true
    fi
}
trap cleanup_orchestrator EXIT

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --phase)
                if [[ $# -lt 2 ]]; then
                    printf "%sError:%s --phase requires 'install' or 'configure'\n" "${C_BOLD_RED}" "${C_RESET}" >&2
                    exit 1
                fi
                if [[ "$2" != "install" && "$2" != "configure" ]]; then
                    printf "%sError:%s Invalid phase '%s' (expected 'install' or 'configure')\n" "${C_BOLD_RED}" "${C_RESET}" "$2" >&2
                    exit 1
                fi
                MODE="phase"
                TARGET_PHASE="$2"
                shift 2
                ;;
            --resume|--failed)
                MODE="resume"
                shift
                ;;
            --only)
                if [[ $# -lt 2 ]]; then
                    printf "%sError:%s --only requires at least one script ID\n" "${C_BOLD_RED}" "${C_RESET}" >&2
                    exit 1
                fi
                MODE="only"
                ONLY_TARGETS="$2"
                shift 2
                ;;
            --no-deps)
                RESOLVE_DEPS=0
                shift
                ;;
            --no-sudo)
                REQUIRE_SUDO="no"
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                printf "%sError:%s Unknown argument '%s'\n\n" "${C_BOLD_RED}" "${C_RESET}" "$1" >&2
                usage >&2
                exit 1
                ;;
        esac
    done
}

start_sudo_keepalive() {
    if [[ "${REQUIRE_SUDO}" == "no" ]]; then
        return 0
    fi

    # Only require sudo upfront if at least one script in the queue uses sudo or is in install/
    local needs_sudo=0
    local id
    for id in "${EXECUTION_QUEUE[@]}"; do
        local s_path="${SCRIPT_PATH_MAP[${id}]}"
        if [[ "${SCRIPT_PHASE_MAP[${id}]}" == "install" ]] || grep -Eq '\b(sudo|dnf_install|dnf_enable_copr|dnf_group_install|flatpak_install)\b' "${s_path}"; then
            needs_sudo=1
            break
        fi
    done

    if [[ ${needs_sudo} -eq 0 ]]; then
        return 0
    fi

    printf "%s==>%s Validating sudo credentials...\n" "${C_BOLD_BLUE}" "${C_RESET}"
    sudo -v

    (
        while true; do
            sudo -n true 2>/dev/null || exit 0
            sleep 50
            kill -0 "$$" 2>/dev/null || exit 0
        done
    ) &
    SUDO_KEEPALIVE_PID=$!
}

discover_scripts() {
    local phase dir file
    for phase in install configure; do
        dir="${DOTFILES_SCRIPTS_DIR}/${phase}"
        [[ -d "${dir}" ]] || continue

        local raw_entries=()
        while IFS= read -r -d '' file; do
            local base_name
            base_name="$(basename "${file}" .sh)"
            local meta_id meta_name meta_order meta_deps

            meta_id="$(sed -n 's/^#[[:space:]]*@id:[[:space:]]*\(.*\)$/\1/p' "${file}" | head -n 1 | xargs || true)"
            meta_name="$(sed -n 's/^#[[:space:]]*@name:[[:space:]]*\(.*\)$/\1/p' "${file}" | head -n 1 | xargs || true)"
            meta_order="$(sed -n 's/^#[[:space:]]*@order:[[:space:]]*\(.*\)$/\1/p' "${file}" | head -n 1 | xargs || true)"
            meta_deps="$(sed -n 's/^#[[:space:]]*@depends:[[:space:]]*\(.*\)$/\1/p' "${file}" | head -n 1 | tr -d '[:space:]' || true)"

            [[ -z "${meta_id}" ]] && meta_id="${phase}/${base_name}"
            [[ -z "${meta_name}" ]] && meta_name="${base_name}"
            if [[ -z "${meta_order}" || ! "${meta_order}" =~ ^[0-9]+$ ]]; then
                meta_order=50
            fi

            SCRIPT_PATH_MAP["${meta_id}"]="${file}"
            SCRIPT_NAME_MAP["${meta_id}"]="${meta_name}"
            SCRIPT_PHASE_MAP["${meta_id}"]="${phase}"
            SCRIPT_ORDER_MAP["${meta_id}"]="${meta_order}"
            SCRIPT_DEPS_MAP["${meta_id}"]="${meta_deps}"

            raw_entries+=("$(printf "%04d\t%s" "$((10#${meta_order}))" "${meta_id}")")
        done < <(find "${dir}" -maxdepth 1 -type f -name "*.sh" -print0 2>/dev/null)

        if [[ ${#raw_entries[@]} -gt 0 ]]; then
            local sorted_phase_ids=()
            while IFS=$'\t' read -r _ord s_id; do
                [[ -n "${s_id}" ]] && sorted_phase_ids+=("${s_id}")
            done < <(printf "%s\n" "${raw_entries[@]}" | sort)

            ALL_DISCOVERED_IDS+=("${sorted_phase_ids[@]}")
        fi
    done

    # Topologically refine order so dependencies always precede dependents
    if [[ ${#ALL_DISCOVERED_IDS[@]} -gt 1 ]]; then
        local -A visited=()
        local -a topo_sorted=()

        _topo_visit() {
            local node="$1"
            if [[ "${visited[${node}]:-0}" -eq 2 ]]; then
                return 0
            fi
            if [[ "${visited[${node}]:-0}" -eq 1 ]]; then
                return 0
            fi
            visited["${node}"]=1

            local deps_csv="${SCRIPT_DEPS_MAP[${node}]:-}"
            if [[ -n "${deps_csv}" ]]; then
                local IFS=','
                local dep
                for dep in ${deps_csv}; do
                    if [[ -n "${SCRIPT_PATH_MAP[${dep}]:-}" ]]; then
                        _topo_visit "${dep}"
                    fi
                done
            fi

            visited["${node}"]=2
            topo_sorted+=("${node}")
        }

        local item
        for item in "${ALL_DISCOVERED_IDS[@]}"; do
            _topo_visit "${item}"
        done

        ALL_DISCOVERED_IDS=("${topo_sorted[@]}")
    fi
}

normalize_script_id() {
    local raw="$1"
    raw="${raw#./}"
    raw="${raw#scripts/}"
    raw="${raw%.sh}"
    printf "%s\n" "${raw}"
}

build_execution_queue() {
    state_init

    case "${MODE}" in
        all)
            EXECUTION_QUEUE=("${ALL_DISCOVERED_IDS[@]}")
            ;;
        phase)
            local id
            for id in "${ALL_DISCOVERED_IDS[@]}"; do
                if [[ "${SCRIPT_PHASE_MAP[${id}]}" == "${TARGET_PHASE}" ]]; then
                    EXECUTION_QUEUE+=("${id}")
                fi
            done
            ;;
        resume)
            local id st
            for id in "${ALL_DISCOVERED_IDS[@]}"; do
                st="$(state_get_status "${id}")"
                if [[ "${st}" != "SUCCESS" ]]; then
                    EXECUTION_QUEUE+=("${id}")
                fi
            done
            ;;
        only)
            local -A requested_set=()
            local IFS=','
            local raw_target norm_id
            for raw_target in ${ONLY_TARGETS}; do
                norm_id="$(normalize_script_id "${raw_target}")"
                if [[ -z "${SCRIPT_PATH_MAP[${norm_id}]:-}" ]]; then
                    printf "%sError:%s Script '%s' not found in scripts/install/ or scripts/configure/\n" \
                        "${C_BOLD_RED}" "${C_RESET}" "${raw_target}" >&2
                    exit 1
                fi

                if [[ ${RESOLVE_DEPS} -eq 1 ]]; then
                    _collect_unmet_deps() {
                        local cur="$1"
                        local d_csv="${SCRIPT_DEPS_MAP[${cur}]:-}"
                        if [[ -n "${d_csv}" ]]; then
                            local d
                            for d in ${d_csv}; do
                                if [[ -n "${SCRIPT_PATH_MAP[${d}]:-}" ]]; then
                                    _collect_unmet_deps "${d}"
                                    if [[ "$(state_get_status "${d}")" != "SUCCESS" ]]; then
                                        requested_set["${d}"]=1
                                    fi
                                fi
                            done
                        fi
                    }
                    _collect_unmet_deps "${norm_id}"
                fi
                requested_set["${norm_id}"]=1
            done

            local id
            for id in "${ALL_DISCOVERED_IDS[@]}"; do
                if [[ -n "${requested_set[${id}]:-}" ]]; then
                    EXECUTION_QUEUE+=("${id}")
                fi
            done
            ;;
    esac
}

# Checks whether all @depends of a script have status SUCCESS.
# Prints the first failing/missing dependency ID if blocked, or returns 0 if ready.
check_dependencies_ready() {
    local script_id="$1"

    if [[ "${MODE}" == "only" && ${RESOLVE_DEPS} -eq 0 ]]; then
        return 0
    fi

    local deps_csv="${SCRIPT_DEPS_MAP[${script_id}]:-}"
    if [[ -z "${deps_csv}" ]]; then
        return 0
    fi

    local IFS=','
    local dep dep_status
    for dep in ${deps_csv}; do
        [[ -z "${dep}" ]] && continue
        if [[ -n "${SESSION_STATUS_MAP[${dep}]:-}" ]]; then
            dep_status="${SESSION_STATUS_MAP[${dep}]}"
        else
            dep_status="$(state_get_status "${dep}")"
        fi

        if [[ "${dep_status}" != "SUCCESS" ]]; then
            printf "%s (%s)\n" "${dep}" "${dep_status}"
            return 1
        fi
    done

    return 0
}

run_single_script() {
    local script_id="$1"
    local script_path="${SCRIPT_PATH_MAP[${script_id}]}"
    local script_name="${SCRIPT_NAME_MAP[${script_id}]}"
    local slug="${script_id//\//-}"
    local log_abs="${SESSION_LOG_DIR}/${slug}.log"
    local log_rel="logs/${DOTFILES_SESSION_TS}/${slug}.log"

    # 1. Verify dependencies
    local failed_dep=""
    if ! failed_dep="$(check_dependencies_ready "${script_id}")"; then
        SESSION_STATUS_MAP["${script_id}"]="BLOCKED"
        state_set_status "${script_id}" "BLOCKED" "-" "-" "BLOCKED"
        printf "  %s[BLOCKED]%s %-24s %s— %s (unmet dependency: %s)%s\n" \
            "${C_BOLD_YELLOW}" "${C_RESET}" \
            "${script_id}" \
            "${C_GRAY}" "${script_name}" "${failed_dep}" "${C_RESET}"
        return 0
    fi

    # 2. Execute script with stdout/stderr redirected to dedicated log file
    local skip_marker
    skip_marker="$(mktemp)"

    if [[ -t 1 ]]; then
        printf "  %s[RUNNING]%s %-24s — %s..." \
            "${C_BOLD_BLUE}" "${C_RESET}" "${script_id}" "${script_name}"
    fi

    local start_ts end_ts elapsed rc=0
    start_ts="$(date +%s)"

    if DOTFILES_CURRENT_SCRIPT_ID="${script_id}" \
       DOTFILES_SKIP_MARKER_FILE="${skip_marker}" \
       bash "${script_path}" >"${log_abs}" 2>&1; then
        rc=0
    else
        rc=$?
    fi

    end_ts="$(date +%s)"
    elapsed=$((end_ts - start_ts))

    if [[ -t 1 ]]; then
        printf "\r\033[K"
    fi

    if [[ ${rc} -eq 0 ]]; then
        SESSION_STATUS_MAP["${script_id}"]="SUCCESS"
        if [[ -s "${skip_marker}" ]]; then
            state_set_status "${script_id}" "SUCCESS" "0" "${log_rel}" "SKIP"
            printf "  %s[SKIP]%s    %-24s — %s %s(%ds)%s\n" \
                "${C_BOLD_CYAN}" "${C_RESET}" \
                "${script_id}" "${script_name}" \
                "${C_GRAY}" "${elapsed}" "${C_RESET}"
        else
            state_set_status "${script_id}" "SUCCESS" "0" "${log_rel}" "OK"
            printf "  %s[OK]%s      %-24s — %s %s(%ds)%s\n" \
                "${C_BOLD_GREEN}" "${C_RESET}" \
                "${script_id}" "${script_name}" \
                "${C_GRAY}" "${elapsed}" "${C_RESET}"
        fi
    else
        SESSION_STATUS_MAP["${script_id}"]="FAILED"
        FAILED_LOG_MAP["${script_id}"]="${log_abs}"
        state_set_status "${script_id}" "FAILED" "${rc}" "${log_rel}" "FAIL"
        printf "  %s[FAIL]%s    %-24s — %s %s(exit %d -> %s)%s\n" \
            "${C_BOLD_RED}" "${C_RESET}" \
            "${script_id}" "${script_name}" \
            "${C_RED}" "${rc}" "${log_rel}" "${C_RESET}"
    fi

    rm -f "${skip_marker}"
}

print_summary() {
    local count_ok=0
    local count_skip=0
    local count_fail=0
    local count_block=0
    local failed_ids=()

    local id st sub
    for id in "${EXECUTION_QUEUE[@]}"; do
        st="${SESSION_STATUS_MAP[${id}]:-PENDING}"
        case "${st}" in
            SUCCESS)
                sub="$(state_get_substatus "${id}")"
                if [[ "${sub}" == "SKIP" ]]; then
                    count_skip=$((count_skip + 1))
                else
                    count_ok=$((count_ok + 1))
                fi
                ;;
            FAILED)
                count_fail=$((count_fail + 1))
                failed_ids+=("${id}")
                ;;
            BLOCKED)
                count_block=$((count_block + 1))
                ;;
        esac
    done

    printf "\n%s============================================================%s\n" "${C_GRAY}" "${C_RESET}"
    printf "%sExecution Summary:%s %d total | %s%d ok%s | %s%d skipped%s | %s%d failed%s | %s%d blocked%s\n" \
        "${C_BOLD}" "${C_RESET}" \
        "${#EXECUTION_QUEUE[@]}" \
        "${C_BOLD_GREEN}" "${count_ok}" "${C_RESET}" \
        "${C_BOLD_CYAN}" "${count_skip}" "${C_RESET}" \
        "${C_BOLD_RED}" "${count_fail}" "${C_RESET}" \
        "${C_BOLD_YELLOW}" "${count_block}" "${C_RESET}"
    printf "%sLogs directory:%s    logs/latest/ (logs/%s/)\n" \
        "${C_BOLD}" "${C_RESET}" "${DOTFILES_SESSION_TS}"
    printf "%s============================================================%s\n" "${C_GRAY}" "${C_RESET}"

    if [[ ${count_fail} -gt 0 ]]; then
        printf "\n%sFailure Logs:%s\n" "${C_BOLD_RED}" "${C_RESET}"
        for id in "${failed_ids[@]}"; do
            local log_f="${FAILED_LOG_MAP[${id}]:-}"
            printf "\n%s--- [%s] (%s) ---%s\n" \
                "${C_BOLD_RED}" "${id}" "${log_f#"${DOTFILES_ROOT}/"}" "${C_RESET}"
            if [[ -f "${log_f}" ]]; then
                cat "${log_f}"
            fi
        done
        return 1
    fi

    return 0
}

main() {
    parse_args "$@"
    discover_scripts

    if [[ ${#ALL_DISCOVERED_IDS[@]} -eq 0 ]]; then
        printf "%s[INFO]%s No scripts found in scripts/install/ or scripts/configure/.\n" \
            "${C_BOLD_BLUE}" "${C_RESET}"
        return 0
    fi

    build_execution_queue

    if [[ ${#EXECUTION_QUEUE[@]} -eq 0 ]]; then
        printf "%s[INFO]%s Nothing to execute (all targeted scripts already have status SUCCESS).\n" \
            "${C_BOLD_GREEN}" "${C_RESET}"
        return 0
    fi

    export DOTFILES_SESSION_TS
    DOTFILES_SESSION_TS="$(date +%Y-%m-%d_%H-%M-%S)"
    SESSION_LOG_DIR="${DOTFILES_LOGS_DIR}/${DOTFILES_SESSION_TS}"
    mkdir -p "${SESSION_LOG_DIR}"
    ln -sfn "${DOTFILES_SESSION_TS}" "${DOTFILES_LOGS_DIR}/latest"

    start_sudo_keepalive

    printf "\n%sDotfiles Orchestrator%s [mode: %s | scripts: %d | session: %s]\n" \
        "${C_BOLD}" "${C_RESET}" "${MODE}" "${#EXECUTION_QUEUE[@]}" "${DOTFILES_SESSION_TS}"

    local current_phase=""
    local id phase
    for id in "${EXECUTION_QUEUE[@]}"; do
        phase="${SCRIPT_PHASE_MAP[${id}]}"
        if [[ "${phase}" != "${current_phase}" ]]; then
            current_phase="${phase}"
            printf "\n%s==> Phase: %s%s\n" "${C_BOLD_BLUE}" "${current_phase}" "${C_RESET}"
        fi
        run_single_script "${id}"
    done

    print_summary
}

main "$@"
