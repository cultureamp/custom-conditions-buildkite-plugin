#!/bin/bash

set -xeuo pipefail

test -n "${BUILDKITE_COMMIT:-}" || { echo "BUILDKITE_COMMIT environment variable must be provided" ; exit 1;}

test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path option must be provided" ; exit 1;}
test -x "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path not found or invalid" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SSM_PREFIX:-}" || { echo "ssm-prefix option must be provided" ; exit 1;}

export
printenv

ssm_parameter_name="$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SSM_PREFIX/$BUILDKITE_PIPELINE_SLUG/$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH"

aws ssm put-parameter \
  --name "$ssm_parameter_name" \
  --type "String" \
  --overwrite \
  --value "$BUILDKITE_COMMIT"

