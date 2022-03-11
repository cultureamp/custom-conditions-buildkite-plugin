#!/bin/bash

set -euo pipefail
[ "${BUILDKITE_PLUGIN_DEBUG:-false}" == "true" ] && set -x ||:

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# shellcheck source=lib/helpers.sh
. "$DIR/../lib/helpers.sh"

condition_type="${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_TYPE:-}"
condition_script="$DIR/../lib/${condition_type}/${PLUGIN_STAGE}.sh"
shared_script="$DIR/../lib/${condition_type}/shared.sh"

test -e "$condition_script" || { echo "condition not supported in ${PLUGIN_STAGE}: $condition_type" ; exit 1 ;}
test ! -e "$shared_script" || . "$shared_script"

$condition_script
