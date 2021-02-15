#!/bin/bash

# Class name
CLASS_NAME="ObfuscatedConstants"

# Dirs
BASEDIR=$(dirname $0)
DEFDIR=${SRCROOT%/*}/../pmconstants

# File names
BASE_FILE_NAME="$BASEDIR/$CLASS_NAME.base.swift"
DEF_FILE_NAME="$DEFDIR/$CLASS_NAME.swift"
DEST_FILE_NAME="$BASEDIR/$CLASS_NAME.swift"

FILE_CONTENT="//
// Auto generated file, don't change it manually
//

import Foundation

class $CLASS_NAME {
"

# $1: variable line
addVariableToFile () {
    VARIABLE_STRING="    $1"
    FILE_CONTENT="$FILE_CONTENT$VARIABLE_STRING
"
}
    
getVariableFromPMConstants () {
    [[ ! -f "$DEF_FILE_NAME" ]] && return
    while read -r line
    do
        if [[ $line == "static let "* ]]; then
            F_LINE_REMAINDER=${line#"static let "} # remove "static let "
            F_VARIABLE_NAME=$(echo $F_LINE_REMAINDER | awk '{print $1;}')
            F_VARIABLE_NAME="${F_VARIABLE_NAME//:}" # remove collon to get variable name

            if [[ $F_VARIABLE_NAME == $1 ]]; then
                RESULT=${F_LINE_REMAINDER#$F_VARIABLE_NAME*} # get type with value
                return
            fi
        fi
    RESULT=
    done <<< "$(cat $DEF_FILE_NAME)"
}

# Parse base file and replace the default values based on env vars of the same names

[[ ! -f "$DEF_FILE_NAME" ]] && echo "warning: pmconstants file $DEF_FILE_NAME not found"

while read line
do
    if [[ $line == "static let "* ]]; then
        LINE_REMAINDER=${line#"static let "} # remove "static let "
        VARIABLE_NAME=$(echo $LINE_REMAINDER | awk '{print $1;}')
        VARIABLE_NAME="${VARIABLE_NAME//:}" # remove collon to get variable name

        getVariableFromPMConstants $VARIABLE_NAME

        if [[ ! -z "$RESULT" ]]; then
            addVariableToFile "static let $VARIABLE_NAME$RESULT"
        else # copy line verbatum from base file
            if [[ -f "$DEF_FILE_NAME" ]]; then
                echo "warning: Variable $VARIABLE_NAME not found in $BASE_FILE_NAME"
            fi
            VARIABLE_VALUE=${LINE_REMAINDER#$VARIABLE_NAME*} # get type with value
            addVariableToFile "static let $VARIABLE_NAME$VARIABLE_VALUE"
        fi
    fi
done <<< "$(cat $BASE_FILE_NAME)"

FILE_CONTENT="$FILE_CONTENT}"

echo "Creating file $DEST_FILE_NAME"
echo "$FILE_CONTENT" > $DEST_FILE_NAME
