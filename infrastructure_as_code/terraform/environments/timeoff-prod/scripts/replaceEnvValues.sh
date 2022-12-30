#!/bin/bash
#VALUES_FILE='../values.tfvars'
#VALUES_FILE_EXAMPLE='../values.tfvars.example'
# This script receives two files as arguments and pass them to replace env vars marked as follow example %EXAMPLE%
# first one is the final version file and the second one is the example that contains env vars enclosed between %% characteres

VALUES_FILE=$1
VALUES_FILE_EXAMPLE=$2


if [[ -f "$VALUES_FILE_EXAMPLE" ]]; then
    cp $VALUES_FILE_EXAMPLE "${VALUES_FILE_EXAMPLE}.bk"
    VARS_TO_REPLACE=$(cat $VALUES_FILE_EXAMPLE | grep -o "%.*%")
    for i in $VARS_TO_REPLACE; do
        VAL="$(echo $i | tr -d "%")"
        sed -i "s#"${i}"#"${!VAL}"#g" "$VALUES_FILE_EXAMPLE"
    done
    mv $VALUES_FILE_EXAMPLE $VALUES_FILE
    mv "${VALUES_FILE_EXAMPLE}.bk" "$VALUES_FILE_EXAMPLE"
else
    echo "$VALUES_FILE_EXAMPLE does not exist"
    exit 1
fi
