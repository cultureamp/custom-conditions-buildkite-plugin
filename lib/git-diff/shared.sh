#!/bin/bash

set -euo pipefail

export

test -n "${BUILDKITE_COMMIT:-}" || { echo "BUILDKITE_COMMIT environment variable must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME:-}" || { echo "condition name must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX:-}" || { echo "cache-prefix option must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH:-}" || BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH="."

tag_params="$(plugin_read_list "TAGS")" ||:
[ -z "$tag_params" ] || {
  unset ssm_tag_params
  for _param in $tag_params ; do
    [ -n "${ssm_tag_params:-}" ] && \
      ssm_tag_params="${ssm_tag_params},${_param}" || \
      ssm_tag_params="${_param}"
  done
  ssm_tag_params=$ssm_tag_params
  export ssm_tag_params
}

git_cache_reference="$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX/$BUILDKITE_PIPELINE_SLUG/$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH"
git_cache_reference="${git_cache_reference%%/}"

export git_cache_reference
