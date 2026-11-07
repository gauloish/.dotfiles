#!/usr/bin/env bash
# @id: configure/gnome-tools
# @name: GNOME User Theme Extension
# @order: 20
# @depends: install/gnome-tools

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly USER_THEME_UUID="user-theme@gnome-shell-extensions.gcampax.github.com"

is_user_theme_enabled() {
    if cmd_exists "gsettings"; then
        local current
        current="$(gsettings get org.gnome.shell enabled-extensions 2>/dev/null || true)"
        if [[ "${current}" == *"'${USER_THEME_UUID}'"* ]]; then
            return 0
        fi
    fi

    if cmd_exists "gnome-extensions"; then
        if gnome-extensions list --enabled 2>/dev/null | grep -qx "${USER_THEME_UUID}"; then
            return 0
        fi
    fi

    return 1
}

enable_user_theme_extension() {
    log_step "Enabling GNOME Shell extension '${USER_THEME_UUID}'..."

    if cmd_exists "gsettings"; then
        run_cmd "Register extension in org.gnome.shell enabled-extensions" \
            python3 -c "
import subprocess, ast
try:
    res = subprocess.check_output(['gsettings', 'get', 'org.gnome.shell', 'enabled-extensions']).decode().strip()
    res = res.replace('@as ', '').strip()
    exts = ast.literal_eval(res) if res else []
except Exception:
    exts = []
uuid = '${USER_THEME_UUID}'
if uuid not in exts:
    exts.append(uuid)
    subprocess.check_call(['gsettings', 'set', 'org.gnome.shell', 'enabled-extensions', str(exts)])
"
    fi

    if cmd_exists "gnome-extensions"; then
        gnome-extensions enable "${USER_THEME_UUID}" 2>/dev/null || true
    fi
}

main() {
    log_info "Checking GNOME User Theme extension status"

    if is_user_theme_enabled; then
        log_skip "GNOME User Theme extension (${USER_THEME_UUID}) is already enabled."
        return 0
    fi

    enable_user_theme_extension
    log_ok "GNOME User Theme extension enabled successfully."
}

main "$@"
