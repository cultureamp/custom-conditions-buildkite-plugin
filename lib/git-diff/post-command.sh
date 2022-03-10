#!/bin/bash

set -xeuo pipefail
test -n ""

buildkite-agent meta-data get "custom-condition-$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME" || \
  aws ssm put-parameter \
    --name "/$git_cache_reference" \
    --type "String" \
    --overwrite \
    --value "$BUILDKITE_COMMIT"
