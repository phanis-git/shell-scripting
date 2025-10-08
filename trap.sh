#!/bin/bash

set -euo pipefail

trap 'echo "There is an error in line number :: $LINENO,and the command is: $BASH_COMMAND"' ERR

echo "Start"
dsjif
echo "End"
# Check catalogue-set.sh we implemented the same instaed of validate functions