#!/bin/bash

set -euo pipefail
[ "${BUILDKITE_PLUGIN_DEBUG:-false}" == "true" ] && set -x ||:

# if the meta-data is not set, the cache condition was missed
# and we want to set it to the current git commit
buildkite-agent meta-data get "custom-condition-$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME" || \
  aws ssm put-parameter \
    --name "/$git_cache_reference" \
    --type "String" \
    --overwrite \
    --value "$BUILDKITE_COMMIT"
