#!/usr/bin/env bash
# Filesystem and idempotent symlink utilities with automatic conflict backup.

if [[ -n "${_DOTFILES_FS_LOADED:-}" ]]; then
    return 0
fi
readonly _DOTFILES_FS_LOADED=1

# Moves an existing conflicting target into backups/<timestamp>/ preserving relative hierarchy.
backup_conflict_path() {
    local target_path="$1"
    local session_ts="${DOTFILES_SESSION_TS:-$(date +%Y-%m-%d_%H-%M-%S)}"
    local backup_root="${DOTFILES_BACKUP_DIR:-${DOTFILES_ROOT}/backups}/${session_ts}"

    local rel_path="${target_path#"${HOME}/"}"
    if [[ "${rel_path}" == "${target_path}" ]]; then
        rel_path="$(basename "${target_path}")"
    fi

    local dest_path="${backup_root}/${rel_path}"
    local dest_dir
    dest_dir="$(dirname "${dest_path}")"

    mkdir -p "${dest_dir}"

    if [[ -e "${dest_path}" || -L "${dest_path}" ]]; then
        dest_path="${dest_path}.$(date +%s)"
    fi

    log_warn "Conflict detected at ${target_path}; moving existing target to ${dest_path}"
    mv "${target_path}" "${dest_path}"
}

# Creates an idempotent symlink from config/<source_rel_path> to <target_abs_path>.
link_path() {
    if [[ $# -lt 2 ]]; then
        log_error "link_path requires <config_relative_path> and <target_absolute_path>"
        return 1
    fi

    local config_rel="$1"
    local target_abs="$2"
    local source_abs="${DOTFILES_CONFIG_DIR:-${DOTFILES_ROOT}/config}/${config_rel}"

    if [[ ! -e "${source_abs}" && ! -L "${source_abs}" ]]; then
        log_error "Source configuration path does not exist: ${source_abs}"
        return 1
    fi

    # Check if target is already a symlink pointing to the exact source path
    if [[ -L "${target_abs}" ]]; then
        local current_link
        current_link="$(readlink "${target_abs}")"
        if [[ "${current_link}" == "${source_abs}" ]]; then
            log_skip "Symlink already configured: ${target_abs} -> ${source_abs}"
            return 0
        fi
        backup_conflict_path "${target_abs}"
    elif [[ -e "${target_abs}" ]]; then
        backup_conflict_path "${target_abs}"
    fi

    local parent_dir
    parent_dir="$(dirname "${target_abs}")"
    if [[ ! -d "${parent_dir}" ]]; then
        log_step "Creating parent directory ${parent_dir}"
        mkdir -p "${parent_dir}"
    fi

    ln -s "${source_abs}" "${target_abs}"
    log_ok "Linked ${target_abs} -> ${source_abs}"
}

# Convenience wrapper: links config/<app> to ~/.config/<app>.
link_config() {
    if [[ $# -lt 1 ]]; then
        log_error "link_config requires an application directory/file name under config/"
        return 1
    fi

    local app_name="$1"
    local xdg_config_home="${XDG_CONFIG_HOME:-${HOME}/.config}"
    link_path "${app_name}" "${xdg_config_home}/${app_name}"
}
