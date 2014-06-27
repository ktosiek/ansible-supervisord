#!/usr/bin/env bash
# This should be run on a temporary VM with clean OS
set -ex

export ANSIBLE_FORCE_COLOR=yes

ANSIBLE_PLAYBOOK=(
    ansible-playbook -c local
    --sudo
    -vv
    --diff
    -i 'localhost ansible_connection=local,')

run_test_playbook() {
    "${ANSIBLE_PLAYBOOK[@]}" "${@}"
    "${ANSIBLE_PLAYBOOK[@]}" "${@}" | tee /tmp/ansible_output
    if ! grep -q 'changed=0.*failed=0' /tmp/ansible_output; then
        echo 'Idempotency test failed'
        return 1
    fi
}

run_test_playbook all.yml
