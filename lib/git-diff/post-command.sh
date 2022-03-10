#!/bin/bash

set -xeuo pipefail

aws ssm put-parameter \
  --name "$ssm_parameter_name" \
  --type "String" \
  --overwrite \
  --value "$BUILDKITE_COMMIT"

