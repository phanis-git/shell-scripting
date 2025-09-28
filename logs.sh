#!/bin/bash

RED="\e[32m"
isRootUser=$(id -u)
if [ $isRootUser -eq 0 ]; then
    echo "Root user"
    else 
    echo -e "$RED Root user privelege is needed"
fi

