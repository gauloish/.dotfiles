#!/usr/bin/env bash
# @id: install/docker
# @name: Docker and Docker Compose
# @order: 42

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly DOCKER_PACKAGES="moby-engine docker-compose docker-compose-switch docker-buildx"

is_docker_installed() {
    local pkg
    for pkg in ${DOCKER_PACKAGES}; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_docker() {
    local pkgs=()
    read -r -a pkgs <<< "${DOCKER_PACKAGES}"

    log_step "Installing Docker and Docker Compose packages via dnf..."
    dnf_install "${pkgs[@]}"
}

main() {
    log_info "Checking Docker and Docker Compose installation"

    if is_docker_installed; then
        log_skip "Docker and Docker Compose are already installed."
        return 0
    fi

    install_docker
    log_ok "Docker and Docker Compose installed successfully."
}

main "$@"
