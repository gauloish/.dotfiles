#!/usr/bin/env bash
# Bootstrap installer for gauloish/.dotfiles on Fedora Linux.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/main/bootstrap.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/gauloish/.dotfiles/dev/bootstrap.sh | bash -s -- --branch dev

set -Eeuo pipefail

readonly DEFAULT_REPO_URL="https://github.com/gauloish/.dotfiles.git"
readonly DEFAULT_BRANCH="main"
readonly DEFAULT_TARGET_DIR="${HOME}/.dotfiles"

declare -a BOOTSTRAP_PASSTHROUGH=()

readonly C_RESET=$'\033[0m'
readonly C_BOLD=$'\033[1m'
readonly C_RED=$'\033[1;31m'
readonly C_GREEN=$'\033[1;32m'
readonly C_YELLOW=$'\033[1;33m'
readonly C_BLUE=$'\033[1;34m'

info() {
    printf "%s[INFO]%s  %s\n" "${C_BLUE}" "${C_RESET}" "$*"
}

ok() {
    printf "%s[OK]%s    %s\n" "${C_GREEN}" "${C_RESET}" "$*"
}

warn() {
    printf "%s[WARN]%s  %s\n" "${C_YELLOW}" "${C_RESET}" "$*" >&2
}

die() {
    printf "%s[ERROR]%s %s\n" "${C_RED}" "${C_RESET}" "$*" >&2
    exit 1
}

verify_environment() {
    if [[ "${EUID}" -eq 0 ]]; then
        die "Do not run bootstrap.sh directly as root. Run as your regular user with sudo privileges."
    fi

    if [[ ! -f /etc/os-release ]]; then
        die "Cannot detect operating system (/etc/os-release not found)."
    fi

    # shellcheck disable=SC1091
    source /etc/os-release
    if [[ "${ID:-}" != "fedora" ]]; then
        die "Unsupported distribution '${ID:-unknown}'. This repository targets Fedora Linux only."
    fi

    if ! command -v sudo >/dev/null 2>&1; then
        die "'sudo' is required but not installed."
    fi

    info "Validating sudo credentials..."
    sudo -v
}

ensure_prerequisites() {
    local missing=()
    local cmd
    for cmd in git curl; do
        if ! command -v "${cmd}" >/dev/null 2>&1; then
            missing+=("${cmd}")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        info "Installing bootstrap prerequisites via dnf: ${missing[*]}"
        sudo dnf install -y "${missing[@]}"
    else
        ok "Prerequisites (git, curl) are already installed."
    fi
}

sync_repository() {
    local repo_url="${DOTFILES_REPO_URL:-${DEFAULT_REPO_URL}}"
    local branch="${DOTFILES_BRANCH:-${DEFAULT_BRANCH}}"
    local target_dir="${DOTFILES_DIR:-${DEFAULT_TARGET_DIR}}"

    if [[ -d "${target_dir}/.git" ]]; then
        info "Existing dotfiles repository detected at ${target_dir}"
        if [[ -z "$(git -C "${target_dir}" status --porcelain)" ]]; then
            info "Updating branch '${branch}'..."
            git -C "${target_dir}" fetch origin "${branch}"
            git -C "${target_dir}" checkout "${branch}"
            git -C "${target_dir}" pull --ff-only origin "${branch}"
            ok "Repository updated to latest '${branch}'."
        else
            warn "Working tree at ${target_dir} has local modifications; skipping git pull."
        fi
        return 0
    fi

    if [[ -e "${target_dir}" || -L "${target_dir}" ]]; then
        local backup_dir="${target_dir}.backup.$(date +%Y-%m-%d_%H-%M-%S)"
        warn "Target path ${target_dir} already exists and is not a git repository; moving to ${backup_dir}"
        mv "${target_dir}" "${backup_dir}"
    fi

    info "Cloning ${repo_url} (branch: ${branch}) into ${target_dir}..."
    git clone --branch "${branch}" "${repo_url}" "${target_dir}"
    ok "Repository cloned into ${target_dir}."
}

run_orchestrator() {
    local target_dir="${DOTFILES_DIR:-${DEFAULT_TARGET_DIR}}"
    local orchestrator="${target_dir}/scripts/run.sh"

    if [[ ! -x "${orchestrator}" ]]; then
        chmod +x "${orchestrator}"
    fi

    info "Launching dotfiles orchestrator..."
    exec "${orchestrator}" "$@"
}

parse_bootstrap_args() {
    local passthrough=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -b|--branch)
                [[ $# -ge 2 ]] || die "--branch requires an argument."
                DOTFILES_BRANCH="$2"
                shift 2
                ;;
            --repo)
                [[ $# -ge 2 ]] || die "--repo requires an argument."
                DOTFILES_REPO_URL="$2"
                shift 2
                ;;
            --dir)
                [[ $# -ge 2 ]] || die "--dir requires an argument."
                DOTFILES_DIR="$2"
                shift 2
                ;;
            *)
                passthrough+=("$1")
                shift
                ;;
        esac
    done
    if [[ ${#passthrough[@]} -gt 0 ]]; then
        BOOTSTRAP_PASSTHROUGH=("${passthrough[@]}")
    else
        BOOTSTRAP_PASSTHROUGH=()
    fi
}

main() {
    printf "%s==> Dotfiles Bootstrap (Fedora Linux)%s\n" "${C_BOLD}" "${C_RESET}"
    parse_bootstrap_args "$@"
    verify_environment
    ensure_prerequisites
    sync_repository
    run_orchestrator ${BOOTSTRAP_PASSTHROUGH[@]+"${BOOTSTRAP_PASSTHROUGH[@]}"}
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
