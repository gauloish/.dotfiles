#!/usr/bin/env bash
# @id: install/data-tools
# @name: Data and Database CLI Tools
# @order: 46
# @depends: install/cli-utils, install/postgresql

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a DATA_RPM_PACKAGES=(
    "pgcli"
)

readonly DUCKDB_INSTALLER_URL="https://install.duckdb.org"

is_pgcli_installed() {
    local pkg
    for pkg in "${DATA_RPM_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

is_duckdb_installed() {
    cmd_exists "duckdb" || [[ -x "${HOME}/.local/bin/duckdb" ]]
}

are_all_data_tools_installed() {
    is_pgcli_installed && is_duckdb_installed
}

install_rpm_packages() {
    if is_pgcli_installed; then
        log_info "RPM packages are already installed: ${DATA_RPM_PACKAGES[*]}"
        return 0
    fi

    log_step "Installing data CLI RPM packages via dnf..."
    dnf_install "${DATA_RPM_PACKAGES[@]}"
}

install_duckdb() {
    if is_duckdb_installed; then
        log_info "DuckDB CLI is already installed."
        return 0
    fi

    log_step "Installing DuckDB CLI via official installer..."
    install_from_script "Install DuckDB CLI" "${DUCKDB_INSTALLER_URL}"
}

main() {
    log_info "Checking Data and Database CLI tools installation"

    if are_all_data_tools_installed; then
        log_skip "All Data and Database CLI tools are already installed."
        return 0
    fi

    install_rpm_packages
    install_duckdb
    log_ok "Data and Database CLI tools installed successfully."
}

main "$@"
