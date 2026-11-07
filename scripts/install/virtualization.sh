#!/usr/bin/env bash
# @id: install/virtualization
# @name: KVM, QEMU, Virt-Manager, and GNOME Boxes
# @order: 48
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a VIRT_PACKAGES=(
    "qemu-kvm"
    "libvirt"
    "virt-install"
    "virt-manager"
    "virt-viewer"
    "gnome-boxes"
)

are_virt_packages_installed() {
    local pkg
    for pkg in "${VIRT_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_virt_packages() {
    log_step "Installing virtualization packages via dnf..."
    dnf_install "${VIRT_PACKAGES[@]}"
}

main() {
    log_info "Checking virtualization packages installation"

    if are_virt_packages_installed; then
        log_skip "All virtualization packages are already installed."
        return 0
    fi

    install_virt_packages
    log_ok "Virtualization packages installed successfully."
}

main "$@"
