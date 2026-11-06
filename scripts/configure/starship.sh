#!/usr/bin/env bash
# @id: configure/starship
# @name: Starship Prompt Configuration
# @order: 25
# @depends: install/starship, install/fonts

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly STARSHIP_CONFIG_REL_PATH="starship/starship.toml"
readonly STARSHIP_CONFIG_TARGET_PATH="${XDG_CONFIG_HOME:-${HOME}/.config}/starship.toml"

configure_starship() {
    log_step "Linking ${STARSHIP_CONFIG_REL_PATH} to ${STARSHIP_CONFIG_TARGET_PATH}..."
    link_path "${STARSHIP_CONFIG_REL_PATH}" "${STARSHIP_CONFIG_TARGET_PATH}"
}

main() {
    log_info "Starting Starship prompt configuration"
    configure_starship
}

main "$@"
