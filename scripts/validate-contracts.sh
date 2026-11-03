#!/usr/bin/env bash
# Static contract validator for scripts in scripts/install/ and scripts/configure/.
# Enforces all rules specified in docs/specs/architecture-and-contracts.md.

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=./utils/logger.sh
source "${SCRIPT_DIR}/utils/logger.sh"

validate_single_script() {
    local file="$1"
    local rel_file="${file#"${REPO_ROOT}/"}"
    local errors=()

    # Determine expected phase from path
    local expected_phase=""
    if [[ "${file}" == */scripts/install/*.sh ]]; then
        expected_phase="install"
    elif [[ "${file}" == */scripts/configure/*.sh ]]; then
        expected_phase="configure"
    fi
    local base_name
    base_name="$(basename "${file}" .sh)"

    # 1. Bash syntax check
    if ! bash -n "${file}" 2>/dev/null; then
        errors+=("Invalid Bash syntax (bash -n failed)")
    fi

    # 2. Executable permission check
    if [[ ! -x "${file}" ]]; then
        errors+=("Script is not executable (missing chmod +x)")
    fi

    # 3. Shebang check (Line 1)
    local first_line
    first_line="$(head -n 1 "${file}")"
    if [[ "${first_line}" != "#!/usr/bin/env bash" ]]; then
        errors+=("Line 1 must be '#!/usr/bin/env bash' (found: '${first_line}')")
    fi

    # 4. Metadata headers check (@id, @name, @order)
    local meta_id meta_name meta_order
    meta_id="$(sed -n 's/^#[[:space:]]*@id:[[:space:]]*\(.*\)$/\1/p' "${file}" | head -n 1 | xargs || true)"
    meta_name="$(sed -n 's/^#[[:space:]]*@name:[[:space:]]*\(.*\)$/\1/p' "${file}" | head -n 1 | xargs || true)"
    meta_order="$(sed -n 's/^#[[:space:]]*@order:[[:space:]]*\(.*\)$/\1/p' "${file}" | head -n 1 | xargs || true)"

    if [[ -z "${meta_id}" ]]; then
        errors+=("Missing '# @id: <phase>/<name>' metadata header")
    elif [[ -n "${expected_phase}" && "${meta_id}" != "${expected_phase}/${base_name}" ]]; then
        errors+=("Metadata @id '${meta_id}' does not match file path '${expected_phase}/${base_name}'")
    fi

    if [[ -z "${meta_name}" ]]; then
        errors+=("Missing '# @name: <Human Readable Name>' metadata header")
    fi

    if [[ -z "${meta_order}" ]]; then
        errors+=("Missing '# @order: <number>' metadata header")
    elif ! [[ "${meta_order}" =~ ^[0-9]+$ ]]; then
        errors+=("Metadata @order '${meta_order}' must be a non-negative integer")
    fi

    # 5. Strict mode check
    if ! grep -Eq '^[[:space:]]*set -Eeuo pipefail([[:space:]]|$)' "${file}"; then
        errors+=("Missing required 'set -Eeuo pipefail'")
    fi

    # 6. Core import check
    if ! grep -Eq '^[[:space:]]*(source|\.)[[:space:]]+.*utils/core\.sh' "${file}"; then
        errors+=("Missing import of 'utils/core.sh'")
    fi

    # 7. Function structure & top-level command checks via awk
    local struct_issues
    struct_issues="$(awk '
        BEGIN {
            in_func = 0
            brace_depth = 0
            main_line = 0
            helper_after_main = 0
            bad_top_level = ""
            last_code_line = ""
        }
        /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
        {
            # Track last non-comment, non-empty line
            line_trimmed = $0
            sub(/^[[:space:]]+/, "", line_trimmed)
            sub(/[[:space:]]+$/, "", line_trimmed)
            last_code_line = line_trimmed
        }
        # Function definition start: func_name() {
        /^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*\(\)[[:space:]]*\{/ {
            fn = $0
            sub(/^[[:space:]]*/, "", fn)
            sub(/[[:space:]]*\(\).*$/, "", fn)
            if (fn == "main") {
                main_line = NR
            } else if (main_line > 0 && brace_depth == 0) {
                helper_after_main = NR
            }
            in_func = 1
        }
        {
            # Count braces outside quotes roughly for standard Bash script formatting
            n_open = gsub(/\{/, "{")
            n_close = gsub(/\}/, "}")
            if (in_func) {
                brace_depth += (n_open - n_close)
                if (brace_depth <= 0) {
                    brace_depth = 0
                    in_func = 0
                }
                next
            }
        }
        # Top-level lines (outside functions)
        brace_depth == 0 {
            if (line_trimmed ~ /^set -Eeuo pipefail/) next
            if (line_trimmed ~ /^SCRIPT_DIR=/) next
            if (line_trimmed ~ /^(source|\.)[[:space:]]+/) next
            if (line_trimmed ~ /^readonly[[:space:]]+[A-Za-z_][A-Za-z0-9_]*=/) next
            if (line_trimmed == "main \"$@\"") next
            if (bad_top_level == "") {
                bad_top_level = sprintf("line %d (%s)", NR, line_trimmed)
            }
        }
        END {
            if (main_line == 0) {
                print "Missing main() function definition"
            }
            if (helper_after_main > 0) {
                printf "Helper function declared after main() at line %d\n", helper_after_main
            }
            if (bad_top_level != "") {
                printf "Disallowed top-level statement outside functions at %s\n", bad_top_level
            }
            if (last_code_line != "main \"$@\"") {
                printf "Last executable line must be '\''main \"$@\"'\'' (found: '\''%s'\'')\n", last_code_line
            }
        }
    ' "${file}")"

    if [[ -n "${struct_issues}" ]]; then
        while IFS= read -r issue; do
            [[ -n "${issue}" ]] && errors+=("${issue}")
        done <<< "${struct_issues}"
    fi

    # 8. Logging check
    if ! grep -Eq '\b(log_info|log_step|log_ok|log_skip|log_warn|log_error|run_cmd)\b' "${file}"; then
        errors+=("Script must write log messages using core logging functions")
    fi

    if [[ ${#errors[@]} -eq 0 ]]; then
        printf "  %s[PASS]%s %s\n" "${C_BOLD_GREEN}" "${C_RESET}" "${rel_file}"
        return 0
    else
        printf "  %s[FAIL]%s %s\n" "${C_BOLD_RED}" "${C_RESET}" "${rel_file}"
        local err
        for err in "${errors[@]}"; do
            printf "         %s-%s %s\n" "${C_RED}" "${C_RESET}" "${err}"
        done
        return 1
    fi
}

main() {
    local target_files=()

    if [[ $# -gt 0 ]]; then
        target_files=("$@")
    else
        while IFS= read -r -d '' f; do
            target_files+=("${f}")
        done < <(find "${SCRIPT_DIR}/install" "${SCRIPT_DIR}/configure" -maxdepth 1 -type f -name "*.sh" -print0 2>/dev/null | sort -z)
    fi

    printf "%sValidating script contracts...%s\n" "${C_BOLD}" "${C_RESET}"

    if [[ ${#target_files[@]} -eq 0 ]]; then
        printf "  %s[INFO]%s No scripts found in scripts/install/ or scripts/configure/.\n" "${C_BOLD_BLUE}" "${C_RESET}"
        return 0
    fi

    local total=0
    local failed=0
    local f
    for f in "${target_files[@]}"; do
        total=$((total + 1))
        if ! validate_single_script "${f}"; then
            failed=$((failed + 1))
        fi
    done

    printf "\n%sSummary:%s %d checked, %s%d passed%s, %s%d failed%s\n" \
        "${C_BOLD}" "${C_RESET}" \
        "${total}" \
        "${C_BOLD_GREEN}" "$((total - failed))" "${C_RESET}" \
        "${C_BOLD_RED}" "${failed}" "${C_RESET}"

    if [[ ${failed} -gt 0 ]]; then
        return 1
    fi
    return 0
}

main "$@"
