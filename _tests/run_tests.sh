#!/usr/bin/env bash
# This should be runned on a temporary VM with clean OS
set -ex

ANSIBLE_PLAYBOOK=(
    ansible-playbook -c local
    --sudo
    -i 'localhost ansible_connection=local,')

run_test_playbook() {
    "${ANSIBLE_PLAYBOOK[@]}" "${@}"
    "${ANSIBLE_PLAYBOOK[@]}" "${@}" | grep ' changed=0 '
}

run_test_playbook all.yml
