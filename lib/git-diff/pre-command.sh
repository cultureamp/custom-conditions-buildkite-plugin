#!/bin/bash

set -xeuo pipefail

# This condition script allows referencing arbitrary commit hashes or branches
# to run a git diff against a repository path

get_last_git_revision() {
  aws ssm get-parameter \
      --name "$ssm_parameter_name" \
      --with-decryption \
      --output text \
      --query Parameter.Value 2>/dev/null || return
}

previous_git_rev=$(get_last_git_revision) ||:

# by default we run
run_custom_script=true

if [ -n "$previous_git_rev" ]
then
  # we have a stored git rev so run a git diff
  # if that returns 0, we know the git diff did not found any differences
  echo "GIT REFERENCE FOUND: ssm:/$ssm_parameter_name"
  echo "SSM PARAMETER VALUE: $previous_git_rev"
  echo "COMPARING $previous_git_rev <> ${BUILDKITE_COMMIT:-}"
  git diff --exit-code \
    "$previous_git_rev" \
    "$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH" && \
    run_custom_script=false ||:
else
  # we have no existing git rev to compare to
  # so trigger should fire
  echo "NO ENTRY IN ssm:/$ssm_parameter_name"
fi

if [ "$run_custom_script" == "true" ]
then
  echo "Running $BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH ..."
  $BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH
else
  echo "No change detected since: $previous_git_rev"
  buildkite-agent annotate "No change detected since: $previous_git_rev"
fi