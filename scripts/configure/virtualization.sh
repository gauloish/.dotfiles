#!/usr/bin/env bash
# @id: configure/virtualization
# @name: Libvirt Daemon and User Permissions Configuration
# @order: 48
# @depends: install/virtualization

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly LIBVIRT_SERVICE_UNIT="libvirtd.service"
readonly LIBVIRT_GROUP="libvirt"
readonly TARGET_USER="${USER:-$(id -un)}"

is_libvirt_service_active() {
    systemctl is-enabled --quiet "${LIBVIRT_SERVICE_UNIT}" 2>/dev/null &&
        systemctl is-active --quiet "${LIBVIRT_SERVICE_UNIT}" 2>/dev/null
}

is_user_in_libvirt_group() {
    id -nG "${TARGET_USER}" 2>/dev/null | tr ' ' '\n' | grep -qx "${LIBVIRT_GROUP}"
}

is_virtualization_configured() {
    is_libvirt_service_active && is_user_in_libvirt_group
}

enable_libvirt_service() {
    if is_libvirt_service_active; then
        log_info "Service ${LIBVIRT_SERVICE_UNIT} is already enabled and active."
        return 0
    fi

    log_step "Enabling and starting ${LIBVIRT_SERVICE_UNIT}..."
    run_cmd "Enable and start ${LIBVIRT_SERVICE_UNIT}" \
        sudo systemctl enable --now "${LIBVIRT_SERVICE_UNIT}"
}

add_user_to_libvirt_group() {
    if is_user_in_libvirt_group; then
        log_info "User '${TARGET_USER}' is already a member of the '${LIBVIRT_GROUP}' group."
        return 0
    fi

    log_step "Adding user '${TARGET_USER}' to the '${LIBVIRT_GROUP}' group..."
    run_cmd "Add ${TARGET_USER} to ${LIBVIRT_GROUP} group" \
        sudo usermod -aG "${LIBVIRT_GROUP}" "${TARGET_USER}"
}

main() {
    log_info "Checking virtualization service and user permissions configuration"

    if is_virtualization_configured; then
        log_skip "Virtualization service is active and user '${TARGET_USER}' is already in the '${LIBVIRT_GROUP}' group."
        return 0
    fi

    enable_libvirt_service
    add_user_to_libvirt_group
    log_ok "Virtualization service and user permissions configured successfully."
}

main "$@"
