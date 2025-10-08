#!/bin/bash

set -euo pipefail

trap 'There is an error in line : $LINENO and Command is $BASH_COMMAND' ERR

echo "Start"
dsjif
echo "End"