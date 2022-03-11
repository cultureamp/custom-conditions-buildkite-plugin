#!/bin/bash

curr_dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

condition_type="${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_TYPE:-}"
condition_script="$curr_dir/../lib/${condition_type}/${PLUGIN_STAGE}.sh"
shared_script="$curr_dir/../lib/${condition_type}/shared.sh"

test -e "$condition_script" || { echo "condition not supported in ${PLUGIN_STAGE}: $condition_type" ; exit 1 ;}
test ! -e "$shared_script" || . "$shared_script"

$condition_script
