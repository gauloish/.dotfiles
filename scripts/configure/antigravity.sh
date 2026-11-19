#!/usr/bin/env bash
# @id: configure/antigravity
# @name: Antigravity Customizations and Plugins
# @order: 60
# @depends: install/antigravity-cli
#
# Symlinks the Google Antigravity engineering standards and language selector
# plugins from config/antigravity/plugins/ into ~/.gemini/config/plugins/.

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly PLUGINS=(
    "antigravity/plugins/dev-standards"
    "antigravity/plugins/lang-en"
    "antigravity/plugins/lang-pt"
)
readonly GEMINI_PLUGINS_TARGET_DIR="${HOME}/.gemini/config/plugins"

# Checks whether all managed Antigravity plugin symlinks are already configured.
#
# Globals:
#   PLUGINS (array, read-only) - Relative paths of plugins under config/.
#   DOTFILES_CONFIG_DIR (string, read-only) - Root configuration directory.
#   GEMINI_PLUGINS_TARGET_DIR (string, read-only) - Target Antigravity plugins directory.
# Arguments:
#   None
# Returns:
#   0 if all plugin symlinks point to their expected sources; 1 otherwise.
is_antigravity_configured() {
    local plugin_rel
    for plugin_rel in "${PLUGINS[@]}"; do
        local plugin_name
        plugin_name="$(basename "${plugin_rel}")"
        local source_abs="${DOTFILES_CONFIG_DIR}/${plugin_rel}"
        local target_path="${GEMINI_PLUGINS_TARGET_DIR}/${plugin_name}"

        if [[ ! -L "${target_path}" ]] || [[ "$(readlink "${target_path}")" != "${source_abs}" ]]; then
            return 1
        fi
    done
    return 0
}

# Creates idempotent symlinks for all managed Antigravity plugins.
#
# Globals:
#   PLUGINS (array, read-only) - Relative paths of plugins under config/.
#   GEMINI_PLUGINS_TARGET_DIR (string, read-only) - Target Antigravity plugins directory.
# Arguments:
#   None
# Returns:
#   0 on success; non-zero if any symlink operation fails.
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

    if is_antigravity_configured; then
        log_skip "Antigravity plugins (dev-standards, lang-en, lang-pt) are already configured."
        return 0
    fi

    configure_antigravity_plugins
    log_ok "Antigravity configuration completed successfully."
}

main "$@"
