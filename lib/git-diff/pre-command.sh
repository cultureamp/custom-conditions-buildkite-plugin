#!/bin/bash

set -euo pipefail
[ "${BUILDKITE_PLUGIN_DEBUG:-false}" == "true" ] && set -x ||:

# This condition script allows referencing arbitrary commit hashes or branches
# to run a git diff against a repository path

# check meta-data key is not already in use by something else
buildkite-agent meta-data exists "custom-condition-$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME" && \
  { echo "custom-condition already set in bk meta-data: $BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME" ; exit 1;} ||:

previous_git_rev=$(aws ssm get-parameter \
    --name "/$git_cache_reference" \
    --with-decryption \
    --output text \
    --query Parameter.Value 2>/dev/null) ||:

# control whether we will set buildkite metadata or not
set_bk_metadata=false

if [ -n "$previous_git_rev" ]
then
  # we have a stored git rev so run a git diff
  # if that returns 0, we know the git diff did not found any differences
  echo "GIT REFERENCE FOUND: ${git_cache_reference}"
  echo "CACHED VALUE: $previous_git_rev"
  echo "COMPARING $previous_git_rev <> ${BUILDKITE_COMMIT:-}"
  git diff --exit-code \
    "$previous_git_rev" \
    "$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH" && \
    set_bk_metadata=true ||:
else
  # we have no existing git rev to compare to
  # so trigger should fire
  echo "NO ENTRY IN ${git_cache_reference}"
fi

if [ "$set_bk_metadata" == "true" ]
then
  echo "Setting buildkite metadata custom-condition-${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME} ${previous_git_rev}"
  buildkite-agent annotate "No change detected since: $previous_git_rev"
  buildkite-agent meta-data set "custom-condition-$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME" "$previous_git_rev"
fi
