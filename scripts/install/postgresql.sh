#!/usr/bin/env bash
# @id: install/postgresql
# @name: PostgreSQL Client and Tools
# @order: 45

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a POSTGRESQL_PACKAGES=(
    "postgresql"
    "postgresql-server"
    "postgresql-contrib"
)

is_postgresql_installed() {
    local pkg
    for pkg in "${POSTGRESQL_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_postgresql() {
    log_step "Installing PostgreSQL packages via dnf..."
    dnf_install "${POSTGRESQL_PACKAGES[@]}"
}

main() {
    log_info "Checking PostgreSQL packages installation"

    if is_postgresql_installed; then
        log_skip "PostgreSQL packages are already installed."
        return 0
    fi

    install_postgresql
    log_ok "PostgreSQL packages installed successfully."
}

main "$@"
