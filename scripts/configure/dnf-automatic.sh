#!/usr/bin/env bash
# @id: configure/dnf-automatic
# @name: DNF Automatic Daily Updates Configuration
# @order: 08
# @depends: install/dnf-automatic

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly SOURCE_CONF_FILE="${DOTFILES_CONFIG_DIR}/dnf/automatic.conf"
readonly TARGET_CONF_FILE="/etc/dnf/automatic.conf"
readonly AUTOMATIC_TIMER_UNIT="dnf5-automatic.timer"

is_conf_up_to_date() {
    [[ -f "${SOURCE_CONF_FILE}" && -f "${TARGET_CONF_FILE}" ]] &&
        cmp -s "${SOURCE_CONF_FILE}" "${TARGET_CONF_FILE}"
}

is_timer_enabled_and_active() {
    systemctl is-enabled --quiet "${AUTOMATIC_TIMER_UNIT}" 2>/dev/null &&
        systemctl is-active --quiet "${AUTOMATIC_TIMER_UNIT}" 2>/dev/null
}

is_dnf_automatic_configured() {
    is_conf_up_to_date && is_timer_enabled_and_active
}

copy_automatic_conf() {
    if [[ ! -f "${SOURCE_CONF_FILE}" ]]; then
        log_error "Source configuration file not found: ${SOURCE_CONF_FILE}"
        return 1
    fi

    if is_conf_up_to_date; then
        log_info "${TARGET_CONF_FILE} is already up to date with ${SOURCE_CONF_FILE}."
        return 0
    fi

    log_step "Copying ${SOURCE_CONF_FILE} to ${TARGET_CONF_FILE}..."
    run_cmd "Install ${TARGET_CONF_FILE} (root:root 0644)" \
        sudo install -o root -g root -m 0644 "${SOURCE_CONF_FILE}" "${TARGET_CONF_FILE}"
}

enable_automatic_timer() {
    if is_timer_enabled_and_active; then
        log_info "Systemd timer ${AUTOMATIC_TIMER_UNIT} is already enabled and active."
        return 0
    fi

    log_step "Enabling and starting ${AUTOMATIC_TIMER_UNIT}..."
    run_cmd "Enable and start ${AUTOMATIC_TIMER_UNIT}" \
        sudo systemctl enable --now "${AUTOMATIC_TIMER_UNIT}"
}

main() {
    log_info "Checking DNF automatic daily updates configuration"

    if is_dnf_automatic_configured; then
        log_skip "DNF automatic daily updates are already configured and active."
        return 0
    fi

    copy_automatic_conf
    enable_automatic_timer
    log_ok "DNF automatic daily updates configured and timer enabled."
}

main "$@"
