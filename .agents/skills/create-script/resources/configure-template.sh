#!/usr/bin/env bash
# @id: configure/example
# @name: Example Configuration
# @order: 50
# @depends: install/example

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

configure_example() {
    log_step "Linking Example configuration files..."
    # Links config/example -> ~/.config/example (with automatic conflict backup)
    link_config "example"
}

main() {
    log_info "Starting Example configuration"
    configure_example
    log_ok "Example configuration applied successfully."
}

main "$@"
