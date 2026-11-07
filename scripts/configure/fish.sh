#!/usr/bin/env bash
# @id: configure/fish
# @name: Fish Shell Configuration
# @order: 15
# @depends: install/fish, install/starship

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly FISH_CONFIG_REL_PATH="fish/config.fish"
readonly FISH_CONFIG_TARGET_PATH="${XDG_CONFIG_HOME:-${HOME}/.config}/fish/config.fish"

configure_fish() {
    log_step "Linking ${FISH_CONFIG_REL_PATH} to ${FISH_CONFIG_TARGET_PATH}..."
    link_path "${FISH_CONFIG_REL_PATH}" "${FISH_CONFIG_TARGET_PATH}"
}

main() {
    log_info "Starting Fish shell configuration"
    configure_fish
}

main "$@"
