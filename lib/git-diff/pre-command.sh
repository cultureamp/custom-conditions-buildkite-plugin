#!/bin/bash

set -xeuo pipefail

# This condition script allows referencing arbitrary commit hashes or branches
# to run a git diff against a repository path

echo "Running git-diff.bash"

set -xeuo pipefail

test -n "${BUILDKITE_COMMIT:-}" || { echo "BUILDKITE_COMMIT environment variable must be provided" ; exit 1;}
    git-path: string
    script-path: string

test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH:-}" || BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH="."
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path option must be provided" ; exit 1;}
test -d "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path not found or invalid" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SSM_PREFIX:-}" || { echo "ssm-prefix option must be provided" ; exit 1;}

get_last_git_revision() {
  aws ssm get-parameter \
      --name "/sales-eng/custom-container-images/$CONDITIONAL_CHECK_SSM_PARAM_NAME" \
      --region us-west-2 \
      --with-decryption \
      --output text \
      --query Parameter.Value 2>/dev/null || return
}


previous_git_rev=$(get_last_git_revision) ||:

unset run_provided_cmd

if [ "$previous_git_rev" == "" ]
then
  # we have no existing git rev to compare to, so just run the provided command
  echo "No existing git revision found in $CONDITIONAL_CHECK_SSM_PARAM_NAME"
else
  $*
  # we have a stored git rev so run a git diff
  # if that returns 0, we know the git diff did not found any differences
  pushd "$CONDITIONAL_CHECK_GIT_REPO_PATH" >/dev/null
  git diff --exit-code \
    "$previous_git_rev" \
    "$CONDITIONAL_CHECK_GIT_DIFF_PATH" && \
    run_provided_cmd=false ||:
  popd >/dev/null
fi
