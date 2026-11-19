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
readonly DOTFILES_SSH_REMOTE_URL="git@github.com:gauloish/.dotfiles.git"

is_gitconfig_linked() {
    local source_abs="${DOTFILES_CONFIG_DIR}/${GITCONFIG_REL_PATH}"
    [[ -L "${GITCONFIG_TARGET_PATH}" ]] && [[ "$(readlink "${GITCONFIG_TARGET_PATH}")" == "${source_abs}" ]]
}

is_dotfiles_remote_ssh() {
    if [[ ! -d "${DOTFILES_ROOT}/.git" ]]; then
        return 0
    fi
    local current_url
    current_url="$(git -C "${DOTFILES_ROOT}" remote get-url origin 2>/dev/null || true)"
    [[ "${current_url}" == "${DOTFILES_SSH_REMOTE_URL}" ]]
}

is_git_configured() {
    is_gitconfig_linked && is_dotfiles_remote_ssh
}

configure_git() {
    log_step "Linking ${GITCONFIG_REL_PATH} to ${GITCONFIG_TARGET_PATH}..."
    link_path "${GITCONFIG_REL_PATH}" "${GITCONFIG_TARGET_PATH}"
}

configure_dotfiles_remote() {
    if [[ ! -d "${DOTFILES_ROOT}/.git" ]]; then
        log_warn "Dotfiles directory ${DOTFILES_ROOT} is not a Git repository; skipping remote configuration."
        return 0
    fi

    if is_dotfiles_remote_ssh; then
        log_info "Dotfiles origin remote is already set to ${DOTFILES_SSH_REMOTE_URL}."
        return 0
    fi

    log_step "Setting dotfiles origin remote URL to ${DOTFILES_SSH_REMOTE_URL}..."
    if git -C "${DOTFILES_ROOT}" remote get-url origin >/dev/null 2>&1; then
        run_cmd "Set dotfiles origin remote to SSH URL" \
            git -C "${DOTFILES_ROOT}" remote set-url origin "${DOTFILES_SSH_REMOTE_URL}"
    else
        run_cmd "Add dotfiles origin remote with SSH URL" \
            git -C "${DOTFILES_ROOT}" remote add origin "${DOTFILES_SSH_REMOTE_URL}"
    fi
}

main() {
    log_info "Starting Git configuration"

    if is_git_configured; then
        log_skip "Git configuration and dotfiles SSH remote are already configured."
        return 0
    fi

    configure_git
    configure_dotfiles_remote
    log_ok "Git configuration completed successfully."
}

main "$@"
