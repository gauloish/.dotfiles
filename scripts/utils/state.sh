#!/usr/bin/env bash
# State persistence manager (.state/status.tsv) for script execution tracking.

if [[ -n "${_DOTFILES_STATE_LOADED:-}" ]]; then
    return 0
fi
readonly _DOTFILES_STATE_LOADED=1

state_file_path() {
    printf "%s\n" "${DOTFILES_STATE_FILE:-${DOTFILES_ROOT}/.state/status.tsv}"
}

state_init() {
    local state_file
    state_file="$(state_file_path)"
    local state_dir
    state_dir="$(dirname "${state_file}")"

    mkdir -p "${state_dir}"

    if [[ ! -f "${state_file}" ]]; then
        printf "# script_id\tstatus\tsubstatus\texit_code\ttimestamp\tlog_file\n" > "${state_file}"
    fi
}

# Returns the recorded status (SUCCESS, FAILED, BLOCKED) or PENDING if not present.
state_get_status() {
    local script_id="$1"
    local state_file
    state_file="$(state_file_path)"

    if [[ ! -f "${state_file}" ]]; then
        printf "PENDING\n"
        return 0
    fi

    local status
    status="$(awk -F'\t' -v id="${script_id}" '$1 == id { print $2; exit }' "${state_file}")"
    if [[ -z "${status}" ]]; then
        printf "PENDING\n"
    else
        printf "%s\n" "${status}"
    fi
}

state_get_substatus() {
    local script_id="$1"
    local state_file
    state_file="$(state_file_path)"

    if [[ ! -f "${state_file}" ]]; then
        printf -- "-\n"
        return 0
    fi

    local sub
    sub="$(awk -F'\t' -v id="${script_id}" '$1 == id { print $3; exit }' "${state_file}")"
    if [[ -z "${sub}" ]]; then
        printf -- "-\n"
    else
        printf "%s\n" "${sub}"
    fi
}

state_get_log_file() {
    local script_id="$1"
    local state_file
    state_file="$(state_file_path)"

    if [[ ! -f "${state_file}" ]]; then
        printf -- "-\n"
        return 0
    fi

    local log_f
    log_f="$(awk -F'\t' -v id="${script_id}" '$1 == id { print $6; exit }' "${state_file}")"
    if [[ -z "${log_f}" ]]; then
        printf -- "-\n"
    else
        printf "%s\n" "${log_f}"
    fi
}

# Atomically updates or appends the status record for a script_id.
state_set_status() {
    local script_id="$1"
    local status="$2"
    local exit_code="${3:--}"
    local log_file="${4:--}"
    local substatus="${5:--}"

    state_init

    local state_file
    state_file="$(state_file_path)"
    local ts
    ts="$(date +"%Y-%m-%dT%H:%M:%S")"

    local tmp_state
    tmp_state="$(mktemp "${state_file}.tmp.XXXXXX")"

    awk -F'\t' -v OFS='\t' \
        -v id="${script_id}" \
        -v st="${status}" \
        -v sub="${substatus}" \
        -v ec="${exit_code}" \
        -v tm="${ts}" \
        -v lf="${log_file}" '
        BEGIN { updated = 0 }
        $1 == id {
            print id, st, sub, ec, tm, lf
            updated = 1
            next
        }
        { print $0 }
        END {
            if (!updated) {
                print id, st, sub, ec, tm, lf
            }
        }
    ' "${state_file}" > "${tmp_state}"

    mv "${tmp_state}" "${state_file}"
}
