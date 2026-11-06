#!/usr/bin/env bash
# @id: configure/docker
# @name: Docker Service and User Group Configuration
# @order: 42
# @depends: install/docker

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly DOCKER_SERVICE_UNIT="docker.service"
readonly DOCKER_GROUP="docker"
readonly TARGET_USER="${USER:-$(id -un)}"

is_docker_service_active() {
    systemctl is-enabled --quiet "${DOCKER_SERVICE_UNIT}" 2>/dev/null &&
        systemctl is-active --quiet "${DOCKER_SERVICE_UNIT}" 2>/dev/null
}

is_user_in_docker_group() {
    id -nG "${TARGET_USER}" 2>/dev/null | tr ' ' '\n' | grep -qx "${DOCKER_GROUP}"
}

is_docker_configured() {
    is_docker_service_active && is_user_in_docker_group
}

enable_docker_service() {
    if is_docker_service_active; then
        log_info "Service ${DOCKER_SERVICE_UNIT} is already enabled and active."
        return 0
    fi

    log_step "Enabling and starting ${DOCKER_SERVICE_UNIT}..."
    run_cmd "Enable and start ${DOCKER_SERVICE_UNIT}" \
        sudo systemctl enable --now "${DOCKER_SERVICE_UNIT}"
}

add_user_to_docker_group() {
    if is_user_in_docker_group; then
        log_info "User '${TARGET_USER}' is already a member of the '${DOCKER_GROUP}' group."
        return 0
    fi

    log_step "Adding user '${TARGET_USER}' to the '${DOCKER_GROUP}' group..."
    run_cmd "Add ${TARGET_USER} to ${DOCKER_GROUP} group" \
        sudo usermod -aG "${DOCKER_GROUP}" "${TARGET_USER}"
}

main() {
    log_info "Checking Docker service and user group configuration"

    if is_docker_configured; then
        log_skip "Docker service is active and user '${TARGET_USER}' is already in the '${DOCKER_GROUP}' group."
        return 0
    fi

    enable_docker_service
    add_user_to_docker_group
    log_ok "Docker service and user group configured successfully."
}

main "$@"
