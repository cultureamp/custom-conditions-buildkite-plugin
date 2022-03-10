#!/bin/bash

set -xeuo pipefail

# This condition script allows referencing arbitrary commit hashes or branches
# to run a git diff against a repository path

echo "Running git-diff.bash"

set -xeuo pipefail

test -n "${BUILDKITE_COMMIT:-}" || { echo "BUILDKITE_COMMIT environment variable must be provided" ; exit 1;}

test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH:-}" || BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH="."
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path option must be provided" ; exit 1;}
test -x "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path not found or invalid" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SSM_PREFIX:-}" || { echo "ssm-prefix option must be provided" ; exit 1;}

get_last_git_revision() {
  aws ssm get-parameter \
      --name "$ssm_parameter_name" \
      --region us-west-2 \
      --with-decryption \
      --output text \
      --query Parameter.Value 2>/dev/null || return
}

ssm_parameter_name="$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SSM_PREFIX/$BUILDKITE_PIPELINE_SLUG/$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH"
previous_git_rev=$(get_last_git_revision) ||:

unset run_custom_script

if [ -n "$previous_git_rev" ]
then
  # we have a stored git rev so run a git diff
  # if that returns 0, we know the git diff did not found any differences
  git diff --exit-code \
    "$previous_git_rev" \
    "$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH" && \
    run_custom_script=false ||:
else
  # we have no existing git rev to compare to
  # so trigger should fire
  run_custom_script=true
fi

if [ "$run_custom_script" == "true" ]
then
  echo "Would run $BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH now ."
fi