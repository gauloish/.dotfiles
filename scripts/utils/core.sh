#!/usr/bin/env bash
# Single entry point sourced by all dotfiles scripts.
# Loads shared utilities, sets error traps, and initializes standalone logging if needed.

if [[ -n "${_DOTFILES_CORE_LOADED:-}" ]]; then
    return 0
fi
readonly _DOTFILES_CORE_LOADED=1

DOTFILES_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_SCRIPTS_DIR="$(cd "${DOTFILES_UTILS_DIR}/.." && pwd)"
DOTFILES_ROOT="$(cd "${DOTFILES_SCRIPTS_DIR}/.." && pwd)"

export DOTFILES_ROOT
export DOTFILES_SCRIPTS_DIR
export DOTFILES_UTILS_DIR
export DOTFILES_CONFIG_DIR="${DOTFILES_ROOT}/config"
export DOTFILES_LOGS_DIR="${DOTFILES_ROOT}/logs"
export DOTFILES_BACKUP_DIR="${DOTFILES_ROOT}/backups"
export DOTFILES_STATE_DIR="${DOTFILES_ROOT}/state"
export DOTFILES_STATE_FILE="${DOTFILES_STATE_DIR}/status.tsv"

# Determine the caller script and extract its @id metadata if not already set
_dotfiles_caller_script="${BASH_SOURCE[${#BASH_SOURCE[@]}-1]}"
if [[ -z "${DOTFILES_CURRENT_SCRIPT_ID:-}" && -f "${_dotfiles_caller_script}" ]]; then
    _extracted_id="$( sed -n 's/^#[[:space:]]*@id:[[:space:]]*\([^[:space:]]*\).*$/\1/p' "${_dotfiles_caller_script}" | head -n 1 )"
    if [[ -n "${_extracted_id}" ]]; then
        export DOTFILES_CURRENT_SCRIPT_ID="${_extracted_id}"
    fi
fi

# shellcheck source=./logger.sh
source "${DOTFILES_UTILS_DIR}/logger.sh"
# shellcheck source=./errors.sh
source "${DOTFILES_UTILS_DIR}/errors.sh"
# shellcheck source=./fs.sh
source "${DOTFILES_UTILS_DIR}/fs.sh"
# shellcheck source=./pkg.sh
source "${DOTFILES_UTILS_DIR}/pkg.sh"
# shellcheck source=./state.sh
source "${DOTFILES_UTILS_DIR}/state.sh"

# Enable strict error handling for module scripts (install/* and configure/*)
case "${_dotfiles_caller_script}" in
    */scripts/install/*.sh|*/scripts/configure/*.sh)
        errors_enable_trap

        # If invoked directly outside of scripts/run.sh, initialize standalone logging & state
        if [[ "${DOTFILES_ORCHESTRATED:-0}" != "1" ]]; then
            DOTFILES_SESSION_TS="${DOTFILES_SESSION_TS:-$(date +%Y-%m-%d_%H-%M-%S)}"
            export DOTFILES_SESSION_TS
            _session_log_dir="${DOTFILES_LOGS_DIR}/${DOTFILES_SESSION_TS}"
            mkdir -p "${_session_log_dir}"
            ln -sfn "${DOTFILES_SESSION_TS}" "${DOTFILES_LOGS_DIR}/latest"

            _script_slug="${DOTFILES_CURRENT_SCRIPT_ID:-$(basename "${_dotfiles_caller_script}" .sh)}"
            _script_slug="${_script_slug//\//-}"
            DOTFILES_SCRIPT_LOG="${_session_log_dir}/${_script_slug}.log"
            export DOTFILES_SCRIPT_LOG

            _dotfiles_standalone_exit() {
                local rc=$?
                local rel_log="logs/${DOTFILES_SESSION_TS}/${_script_slug}.log"
                local sub="OK"
                if [[ "${DOTFILES_SCRIPT_SKIPPED:-0}" -eq 1 ]]; then
                    sub="SKIP"
                fi
                if [[ -n "${DOTFILES_CURRENT_SCRIPT_ID:-}" ]]; then
                    if [[ ${rc} -eq 0 ]]; then
                        state_set_status "${DOTFILES_CURRENT_SCRIPT_ID}" "SUCCESS" "0" "${rel_log}" "${sub}"
                    else
                        state_set_status "${DOTFILES_CURRENT_SCRIPT_ID}" "FAILED" "${rc}" "${rel_log}" "FAIL"
                    fi
                fi
            }
            trap '_dotfiles_standalone_exit' EXIT
            exec > >(tee -a "${DOTFILES_SCRIPT_LOG}") 2>&1
        fi
        ;;
esac
