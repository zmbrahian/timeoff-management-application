#!/bin/bash
VALUES_FILE='../values.tfvars'
VALUES_FILE_EXAMPLE='../values.tfvars.example'

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
