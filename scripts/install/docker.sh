#!/usr/bin/env bash
# @id: install/docker
# @name: Docker, Docker Compose, and Lazydocker
# @order: 42

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a DOCKER_PACKAGES=(
    "moby-engine"
    "docker-compose"
    "docker-compose-switch"
    "docker-buildx"
)

readonly LAZYDOCKER_COPR_REPO="atim/lazydocker"
readonly LAZYDOCKER_PACKAGE="lazydocker"

are_docker_packages_installed() {
    local pkg
    for pkg in "${DOCKER_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

is_lazydocker_installed() {
    rpm_is_installed "${LAZYDOCKER_PACKAGE}"
}

are_all_docker_components_installed() {
    are_docker_packages_installed && is_lazydocker_installed
}

install_docker_packages() {
    log_step "Installing Docker and Docker Compose packages via dnf..."
    dnf_install "${DOCKER_PACKAGES[@]}"
}

install_lazydocker() {
    if is_lazydocker_installed; then
        log_info "${LAZYDOCKER_PACKAGE} is already installed."
        return 0
    fi

    log_step "Enabling COPR repository: ${LAZYDOCKER_COPR_REPO}..."
    dnf_enable_copr "${LAZYDOCKER_COPR_REPO}"

    log_step "Installing ${LAZYDOCKER_PACKAGE} via dnf..."
    dnf_install "${LAZYDOCKER_PACKAGE}"
}

main() {
    log_info "Checking Docker, Docker Compose, and Lazydocker installation"

    if are_all_docker_components_installed; then
        log_skip "Docker, Docker Compose, and Lazydocker are already installed."
        return 0
    fi

    install_docker_packages
    install_lazydocker
    log_ok "Docker, Docker Compose, and Lazydocker installed successfully."
}

main "$@"
