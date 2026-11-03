#!/usr/bin/env bash
# Shared error handling and trap management for dotfiles scripts.

if [[ -n "${_DOTFILES_ERRORS_LOADED:-}" ]]; then
    return 0
fi
readonly _DOTFILES_ERRORS_LOADED=1

_DOTFILES_ERROR_HANDLED=0

dotfiles_on_error() {
    local exit_code="$1"
    local line_no="$2"
    local failed_cmd="$3"
    local source_file="${4:-${BASH_SOURCE[1]:-unknown}}"

    if [[ "${_DOTFILES_ERROR_HANDLED}" -eq 1 ]]; then
        return "${exit_code}"
    fi
    _DOTFILES_ERROR_HANDLED=1

    log_error "Execution failed in ${source_file}:${line_no} (exit code: ${exit_code})"
    log_error "Failing command: ${failed_cmd}"

    return "${exit_code}"
}

errors_enable_trap() {
    set -Eeuo pipefail
    trap 'dotfiles_on_error "$?" "${LINENO}" "${BASH_COMMAND}" "${BASH_SOURCE[0]}"' ERR
}
