#!/usr/bin/env bash
# @id: install/uv-tools
# @name: Python Toolchain via uv (Ruff, Pre-commit, Mypy, Ty)
# @order: 41
# @depends: install/uv

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a UV_TOOLS=(
    "ruff"
    "pre-commit"
    "mypy"
    "ty"
)

is_uv_tool_installed() {
    local tool="$1"
    cmd_exists "${tool}" || [[ -x "${HOME}/.local/bin/${tool}" ]]
}

are_all_uv_tools_installed() {
    local tool
    for tool in "${UV_TOOLS[@]}"; do
        if ! is_uv_tool_installed "${tool}"; then
            return 1
        fi
    done
    return 0
}

install_uv_tools() {
    local tool
    for tool in "${UV_TOOLS[@]}"; do
        if is_uv_tool_installed "${tool}"; then
            log_info "uv tool '${tool}' is already installed."
            continue
        fi

        log_step "Installing '${tool}' via uv tool install..."
        run_cmd "Install ${tool} via uv" uv tool install "${tool}"
    done
}

main() {
    log_info "Checking uv tools installation (ruff, pre-commit, mypy, ty)"

    if are_all_uv_tools_installed; then
        log_skip "All uv tools are already installed."
        return 0
    fi

    install_uv_tools
    log_ok "All uv tools installed successfully."
}

main "$@"
