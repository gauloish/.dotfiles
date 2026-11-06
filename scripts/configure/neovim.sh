#!/usr/bin/env bash
# @id: configure/neovim
# @name: Neovim Editor Configuration
# @order: 20
# @depends: install/neovim

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

configure_neovim() {
    log_step "Linking Neovim configuration directory (config/nvim -> ~/.config/nvim)..."
    link_config "nvim"
}

main() {
    log_info "Starting Neovim configuration"
    configure_neovim
    log_ok "Neovim configuration linked successfully."
}

main "$@"
