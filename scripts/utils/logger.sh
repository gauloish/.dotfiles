#!/usr/bin/env bash
# Shared ANSI logger and command runner for dotfiles scripts.

if [[ -n "${_DOTFILES_LOGGER_LOADED:-}" ]]; then
    return 0
fi
readonly _DOTFILES_LOGGER_LOADED=1

# ANSI escape sequences (always emitted so log files preserve formatting)
readonly C_RESET=$'\033[0m'
readonly C_BOLD=$'\033[1m'
readonly C_DIM=$'\033[2m'
readonly C_RED=$'\033[0;31m'
readonly C_BOLD_RED=$'\033[1;31m'
readonly C_GREEN=$'\033[0;32m'
readonly C_BOLD_GREEN=$'\033[1;32m'
readonly C_YELLOW=$'\033[0;33m'
readonly C_BOLD_YELLOW=$'\033[1;33m'
readonly C_BLUE=$'\033[0;34m'
readonly C_BOLD_BLUE=$'\033[1;34m'
readonly C_MAGENTA=$'\033[0;35m'
readonly C_CYAN=$'\033[0;36m'
readonly C_BOLD_CYAN=$'\033[1;36m'
readonly C_GRAY=$'\033[0;90m'

# Tracks whether the current script logged a skip condition
export DOTFILES_SCRIPT_SKIPPED=0

_log_timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

_log_write() {
    local level_color="$1"
    local level_tag="$2"
    local message="$3"
    local ts
    ts="$(_log_timestamp)"
    local script_ctx="${DOTFILES_CURRENT_SCRIPT_ID:-core}"

    printf "%s[%s]%s %s[%-5s]%s %s[%s]%s %s\n" \
        "${C_GRAY}" "${ts}" "${C_RESET}" \
        "${level_color}" "${level_tag}" "${C_RESET}" \
        "${C_CYAN}" "${script_ctx}" "${C_RESET}" \
        "${message}"
}

log_info() {
    _log_write "${C_BOLD_BLUE}" "INFO" "$*"
}

log_step() {
    _log_write "${C_BOLD_CYAN}" "STEP" "$*"
}

log_ok() {
    if [[ -n "${DOTFILES_SKIP_MARKER_FILE:-}" ]]; then
        rm -f "${DOTFILES_SKIP_MARKER_FILE}" 2>/dev/null || true
    fi
    _log_write "${C_BOLD_GREEN}" "OK" "$*"
}

log_skip() {
    export DOTFILES_SCRIPT_SKIPPED=1
    if [[ -n "${DOTFILES_SKIP_MARKER_FILE:-}" ]]; then
        printf "SKIP\n" > "${DOTFILES_SKIP_MARKER_FILE}" 2>/dev/null || true
    fi
    _log_write "${C_BOLD_YELLOW}" "SKIP" "$*"
}

log_warn() {
    _log_write "${C_BOLD_YELLOW}" "WARN" "$*" >&2
}

log_error() {
    _log_write "${C_BOLD_RED}" "ERROR" "$*" >&2
}

# Executes a command, logs its invocation and indented output, and preserves its exit code.
run_cmd() {
    if [[ $# -lt 2 ]]; then
        log_error "run_cmd requires a description and a command"
        return 1
    fi

    local description="$1"
    shift

    if [[ -n "${DOTFILES_SKIP_MARKER_FILE:-}" ]]; then
        rm -f "${DOTFILES_SKIP_MARKER_FILE}" 2>/dev/null || true
    fi

    log_step "${description}"
    _log_write "${C_MAGENTA}" "CMD" "\$ $*"

    local tmp_out
    tmp_out="$(mktemp)"
    local exit_code=0

    if "$@" >"${tmp_out}" 2>&1; then
        exit_code=0
    else
        exit_code=$?
    fi

    if [[ -s "${tmp_out}" ]]; then
        while IFS= read -r line || [[ -n "${line}" ]]; do
            printf "  %s|%s %s\n" "${C_GRAY}" "${C_RESET}" "${line}"
        done < "${tmp_out}"
    fi

    rm -f "${tmp_out}"

    if [[ ${exit_code} -ne 0 ]]; then
        local caller_file="${BASH_SOURCE[1]:-unknown}"
        local caller_line="${BASH_LINENO[0]:-0}"
        log_error "Command failed at ${caller_file}:${caller_line} (exit code ${exit_code}): $*"
        _DOTFILES_ERROR_HANDLED=1
        return "${exit_code}"
    fi

    return 0
}
