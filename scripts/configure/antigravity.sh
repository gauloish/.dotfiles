#!/usr/bin/env bash
# @id: configure/antigravity
# @name: Antigravity Customizations and Plugins
# @order: 60
# @depends: install/antigravity-cli

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly PLUGINS=(
    "antigravity/plugins/conventional-commits-pt"
    "antigravity/plugins/conventional-commits-en"
)
readonly GEMINI_PLUGINS_TARGET_DIR="${HOME}/.gemini/config/plugins"

configure_antigravity_plugins() {
    log_step "Configuring Antigravity plugins..."

    local plugin_rel
    for plugin_rel in "${PLUGINS[@]}"; do
        local plugin_name
        plugin_name="$(basename "${plugin_rel}")"
        local target_path="${GEMINI_PLUGINS_TARGET_DIR}/${plugin_name}"

        log_step "Linking plugin ${plugin_name} to ${target_path}..."
        link_path "${plugin_rel}" "${target_path}"
    done
}

main() {
    log_info "Starting Antigravity configuration"
    configure_antigravity_plugins
    log_ok "Antigravity configuration completed successfully."
}

main "$@"
