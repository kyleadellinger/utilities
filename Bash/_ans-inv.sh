#!/usr/bin/env bash

_ANSIBLE=_ans-venv/bin/ansible-inventory

case "$1" in
    [Dd][Ee][Vv]* )
        echo 'Target development.ini'
        _TARGET_ENV=hosts/development.ini
        ;;
    [Tt][Ee][Ss]* )
        echo 'Target testing'
        _TARGET_ENV=hosts/testing.ini
        ;;
    [Pp][Rr][Oo]* )
        echo 'Target prod'
        _TARGET_ENV=hosts/production.ini
        ;;
    * )
        echo 'invalid input. atleast "dev" or "tes" or "pro" expected'.
        exit 1
        ;;
esac

if [[ -z "$2" ]]; then
    echo 'host or host group expected as second argument.'
    exit 2
else
    _TARGET_GROUP="${2}"
fi

echo ""
echo "Running: \"ansible-inventory -i ${_TARGET_ENV} --graph ${_TARGET_GROUP}\""
echo ""
echo "Target host(s)/group: ${_TARGET_GROUP}"
echo ""
"${_ANSIBLE}" -i "${_TARGET_ENV}" --graph "${_TARGET_GROUP}"
