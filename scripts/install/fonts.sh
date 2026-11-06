#!/usr/bin/env bash
# @id: install/fonts
# @name: JetBrains Mono and Nerd Font Symbols
# @order: 12
# @depends: install/cli-utils

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly JETBRAINS_MONO_PKG="jetbrains-mono-fonts"
readonly NERD_SYMBOLS_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz"
readonly USER_FONTS_DIR="${HOME}/.local/share/fonts/NerdFontsSymbolsOnly"
readonly FONTCONFIG_CONF_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/fontconfig/conf.d"
readonly FONTCONFIG_RULE_FILE="${FONTCONFIG_CONF_DIR}/10-nerd-font-symbols.conf"

is_jetbrains_mono_installed() {
    rpm_is_installed "${JETBRAINS_MONO_PKG}"
}

is_nerd_symbols_installed() {
    [[ -f "${USER_FONTS_DIR}/SymbolsNerdFontMono-Regular.ttf" && -f "${FONTCONFIG_RULE_FILE}" ]]
}

are_all_fonts_installed() {
    is_jetbrains_mono_installed && is_nerd_symbols_installed
}

install_jetbrains_mono() {
    if is_jetbrains_mono_installed; then
        log_info "Package ${JETBRAINS_MONO_PKG} is already installed."
        return 0
    fi

    log_step "Installing official JetBrains Mono font via dnf..."
    dnf_install "${JETBRAINS_MONO_PKG}"
}

install_nerd_symbols() {
    if is_nerd_symbols_installed; then
        log_info "Nerd Font Symbols and Fontconfig rule are already installed."
        return 0
    fi

    local tmp_dir
    tmp_dir="$(mktemp -d)"
    local archive_path="${tmp_dir}/NerdFontsSymbolsOnly.tar.xz"

    log_step "Downloading NerdFontsSymbolsOnly release archive..."
    if ! run_cmd "Download NerdFontsSymbolsOnly.tar.xz" \
        curl -fsSL "${NERD_SYMBOLS_URL}" -o "${archive_path}"; then
        rm -rf "${tmp_dir}"
        return 1
    fi

    log_step "Extracting Nerd Font Symbols..."
    if ! run_cmd "Extract NerdFontsSymbolsOnly.tar.xz" \
        tar -xJf "${archive_path}" -C "${tmp_dir}"; then
        rm -rf "${tmp_dir}"
        return 1
    fi

    mkdir -p "${USER_FONTS_DIR}" "${FONTCONFIG_CONF_DIR}"

    run_cmd "Install Symbols Nerd Font .ttf files to ${USER_FONTS_DIR}" \
        bash -c "cp -f '${tmp_dir}'/*.ttf '${USER_FONTS_DIR}/'"

    if [[ -f "${tmp_dir}/10-nerd-font-symbols.conf" ]]; then
        run_cmd "Install Fontconfig fallback rule to ${FONTCONFIG_RULE_FILE}" \
            cp -f "${tmp_dir}/10-nerd-font-symbols.conf" "${FONTCONFIG_RULE_FILE}"
    fi

    rm -rf "${tmp_dir}"

    if cmd_exists "fc-cache"; then
        run_cmd "Refresh font cache" fc-cache -f "${HOME}/.local/share/fonts"
    fi
}

main() {
    log_info "Checking JetBrains Mono and Nerd Font Symbols installation"

    if are_all_fonts_installed; then
        log_skip "JetBrains Mono and Nerd Font Symbols are already installed."
        return 0
    fi

    install_jetbrains_mono
    install_nerd_symbols
    log_ok "JetBrains Mono and Nerd Font Symbols installed successfully."
}

main "$@"
