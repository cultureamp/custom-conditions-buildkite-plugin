#!/bin/bash

curr_dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

export
printenv

condition_type="${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CONDITION:-}"
condition_script="$curr_dir/../lib/${condition_type}/${PLUGIN_STAGE}.sh"

test -e "$condition_script" || { echo "condition not supported in ${PLUGIN_STAGE}: $condition_type" ; exit 1 ;}
exec $condition_script
