
#!/usr/bin/env bash

echo "The script you are running has:"
echo "basename: [$(basename "$0")]"
echo "dirname : [$(dirname "$0")]"
echo "pwd     : [$(pwd)]"
script_dir="$(dirname "$(realpath "$0")")"
echo $script_dir
