#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE=".bashrc"
CONFIG_DIR="${HOME}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\e[0;33m'
NC='\033[0m'

OK_MSG="[ ${GREEN}DONE${NC} ]  "
ERR_MSG="[ ${RED}FAIL${NC} ]  "
WARN_MSG="[ ${YELLOW}WARN${NC} ]  "
INFO_MSG="[ INFO ]  "

if [ ! -f $SCRIPT_DIR/$CONFIG_FILE ]; then
    echo -e "${ERR_MSG}No file ${CONFIG_FILE} in ${SCRIPT_DIR}"
    exit 1
elif [ -f $CONFIG_DIR/$CONFIG_FILE ]; then
    mv $CONFIG_DIR/$CONFIG_FILE $CONFIG_DIR/$CONFIG_FILE.old 
    echo -e "${WARN_MSG}Moved: ${CONFIG_DIR}/${CONFIG_FILE} -> ${CONFIG_DIR}/${CONFIG_FILE}.old"
fi

cp $SCRIPT_DIR/$CONFIG_FILE $CONFIG_DIR/$CONFIG_FILE
echo -e "${OK_MSG}Copied: ${SCRIPT_DIR}/${CONFIG_FILE} -> ${CONFIG_DIR}/${CONFIG_FILE}"
echo -e "${INFO_MSG}Manually: source ${CONFIG_DIR}/${CONFIG_FILE}"


