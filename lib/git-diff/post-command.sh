#!/bin/bash

set -xeuo pipefail

aws ssm put-parameter \
  --name "$git_cache_reference" \
  --type "String" \
  --overwrite \
  --value "$BUILDKITE_COMMIT"
