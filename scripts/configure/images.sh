#!/usr/bin/env bash
# @id: configure/images
# @name: Profile and Wallpaper Images
# @order: 10

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../utils/core.sh
source "${SCRIPT_DIR}/../utils/core.sh"

readonly SOURCE_IMAGES_DIR="${DOTFILES_ROOT}/resources/images"
readonly TARGET_IMAGES_DIR="${HOME}/Imagens"

are_images_up_to_date() {
    if [[ ! -d "${SOURCE_IMAGES_DIR}" || ! -d "${TARGET_IMAGES_DIR}" ]]; then
        return 1
    fi

    local src_subdir dir_name dest_subdir
    local found_any=0
    for src_subdir in "${SOURCE_IMAGES_DIR}"/*; do
        [[ -d "${src_subdir}" ]] || continue
        found_any=1
        dir_name="$(basename "${src_subdir}")"
        dest_subdir="${TARGET_IMAGES_DIR}/${dir_name}"

        if [[ ! -d "${dest_subdir}" ]]; then
            return 1
        fi

        if ! diff -rq "${src_subdir}" "${dest_subdir}" >/dev/null 2>&1; then
            return 1
        fi
    done

    [[ ${found_any} -eq 1 ]]
}

copy_image_directories() {
    if [[ ! -d "${SOURCE_IMAGES_DIR}" ]]; then
        log_error "Source images directory does not exist: ${SOURCE_IMAGES_DIR}"
        return 1
    fi

    log_step "Ensuring target directory ${TARGET_IMAGES_DIR} exists..."
    mkdir -p "${TARGET_IMAGES_DIR}"

    local src_subdir dir_name
    for src_subdir in "${SOURCE_IMAGES_DIR}"/*; do
        [[ -d "${src_subdir}" ]] || continue
        dir_name="$(basename "${src_subdir}")"
        run_cmd "Copying '${dir_name}' to ${TARGET_IMAGES_DIR}/${dir_name}" \
            cp -r "${src_subdir}" "${TARGET_IMAGES_DIR}/"
    done
}

main() {
    log_info "Checking profile and wallpaper images in ${TARGET_IMAGES_DIR}"

    if are_images_up_to_date; then
        log_skip "Image directories in ${TARGET_IMAGES_DIR} are already up to date."
        return 0
    fi

    copy_image_directories
    log_ok "Profile and wallpaper images copied to ${TARGET_IMAGES_DIR}."
}

main "$@"
