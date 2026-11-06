#!/usr/bin/env bash
# @id: configure/git
# @name: Git Configuration
# @order: 05
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly GITCONFIG_REL_PATH="git/.gitconfig"
readonly GITCONFIG_TARGET_PATH="${HOME}/.gitconfig"

configure_git() {
    log_step "Linking ${GITCONFIG_REL_PATH} to ${GITCONFIG_TARGET_PATH}..."
    link_path "${GITCONFIG_REL_PATH}" "${GITCONFIG_TARGET_PATH}"
}

main() {
    log_info "Starting Git configuration"
    configure_git
}

main "$@"
