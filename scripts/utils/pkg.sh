#!/usr/bin/env bash
# Multi-method package and tool installation helpers for Fedora Linux.

if [[ -n "${_DOTFILES_PKG_LOADED:-}" ]]; then
    return 0
fi
readonly _DOTFILES_PKG_LOADED=1

# Checks whether a command/binary is available in PATH.
cmd_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Checks whether an RPM package is installed on the system.
rpm_is_installed() {
    rpm -q "$1" >/dev/null 2>&1
}

# Idempotently installs one or more DNF packages, filtering out already installed ones.
dnf_install() {
    if [[ $# -eq 0 ]]; then
        log_error "dnf_install requires at least one package name"
        return 1
    fi

    local missing_pkgs=()
    local pkg
    for pkg in "$@"; do
        if rpm_is_installed "${pkg}"; then
            log_info "DNF package already installed: ${pkg}"
        else
            missing_pkgs+=("${pkg}")
        fi
    done

    if [[ ${#missing_pkgs[@]} -eq 0 ]]; then
        log_skip "All requested DNF packages are already installed ($*)"
        return 0
    fi

    run_cmd "Installing DNF packages: ${missing_pkgs[*]}" \
        sudo dnf install -y "${missing_pkgs[@]}"
}

# Enables a Fedora COPR repository if not already enabled.
dnf_enable_copr() {
    if [[ $# -lt 1 ]]; then
        log_error "dnf_enable_copr requires <owner/project>"
        return 1
    fi

    local copr_repo="$1"
    local repo_slug="${copr_repo//\//-}"

    if compgen -G "/etc/yum.repos.d/*${repo_slug}*.repo" >/dev/null 2>&1; then
        log_skip "COPR repository already enabled: ${copr_repo}"
        return 0
    fi

    run_cmd "Enabling COPR repository: ${copr_repo}" \
        sudo dnf copr enable -y "${copr_repo}"
}

# Installs a DNF package group.
dnf_group_install() {
    if [[ $# -lt 1 ]]; then
        log_error "dnf_group_install requires a group name"
        return 1
    fi

    local group_name="$1"
    run_cmd "Installing DNF group: ${group_name}" \
        sudo dnf group install -y "${group_name}"
}

# Ensures Flatpak is installed and the Flathub remote is registered.
flatpak_ensure_flathub() {
    if ! cmd_exists "flatpak"; then
        dnf_install "flatpak"
    fi

    if flatpak remotes --columns=name 2>/dev/null | grep -qx "flathub"; then
        return 0
    fi

    run_cmd "Adding Flathub remote repository" \
        sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

# Checks whether a Flatpak application is installed.
flatpak_is_installed() {
    if ! cmd_exists "flatpak"; then
        return 1
    fi
    flatpak info "$1" >/dev/null 2>&1
}

# Idempotently installs one or more Flatpak applications from Flathub.
flatpak_install() {
    if [[ $# -eq 0 ]]; then
        log_error "flatpak_install requires at least one application ID"
        return 1
    fi

    flatpak_ensure_flathub

    local missing_apps=()
    local app_id
    for app_id in "$@"; do
        if flatpak_is_installed "${app_id}"; then
            log_info "Flatpak application already installed: ${app_id}"
        else
            missing_apps+=("${app_id}")
        fi
    done

    if [[ ${#missing_apps[@]} -eq 0 ]]; then
        log_skip "All requested Flatpak applications are already installed ($*)"
        return 0
    fi

    run_cmd "Installing Flatpak applications: ${missing_apps[*]}" \
        sudo flatpak install -y --noninteractive flathub "${missing_apps[@]}"
}

# Downloads an upstream installer script to a temporary file and executes it via bash.
install_from_script() {
    if [[ $# -lt 2 ]]; then
        log_error "install_from_script requires <description> and <script_url> [args...]"
        return 1
    fi

    local description="$1"
    local script_url="$2"
    shift 2

    local tmp_installer
    tmp_installer="$(mktemp)"

    run_cmd "Downloading installer from ${script_url}" \
        curl -fsSL "${script_url}" -o "${tmp_installer}"

    chmod +x "${tmp_installer}"

    local rc=0
    if run_cmd "${description}" bash "${tmp_installer}" "$@"; then
        rc=0
    else
        rc=$?
    fi

    rm -f "${tmp_installer}"
    return "${rc}"
}
