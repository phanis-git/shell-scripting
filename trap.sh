#!/bin/bash

set -euo pipefail

trap 'echo "There is an error in $LINENO, Command is: $BASH_COMMAND"' ERR

echo "Start"
dsjif
echo "End"