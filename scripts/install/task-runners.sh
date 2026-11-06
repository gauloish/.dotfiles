#!/usr/bin/env bash
# @id: install/task-runners
# @name: Task Runners (Just and Task)
# @order: 56
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly -a TASK_RUNNER_PACKAGES=(
    "just"
    "go-task"
)

are_task_runners_installed() {
    local pkg
    for pkg in "${TASK_RUNNER_PACKAGES[@]}"; do
        if ! rpm_is_installed "${pkg}"; then
            return 1
        fi
    done
    return 0
}

install_task_runners() {
    log_step "Installing task runners (just and go-task) via dnf..."
    dnf_install "${TASK_RUNNER_PACKAGES[@]}"
}

main() {
    log_info "Checking task runners installation"

    if are_task_runners_installed; then
        log_skip "All task runners are already installed."
        return 0
    fi

    install_task_runners
    log_ok "Task runners installed successfully."
}

main "$@"
