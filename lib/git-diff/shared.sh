#!/bin/bash

set -euo pipefail

export

test -n "${BUILDKITE_COMMIT:-}" || { echo "BUILDKITE_COMMIT environment variable must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME:-}" || { echo "condition name must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX:-}" || { echo "cache-prefix option must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH:-}" || BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH="."

tag_params="$(plugin_read_list "TAGS")" ||:
[ -z "$tag_params" ] || {
  ssm_params_tag_switch='"'
  for _param in $tag_params ; do
    ssm_params_tag_switch="${SSM_PARAM_TAGS_SWITCH}${_param}"
  done
  export ssm_params_tag_switch
}

git_cache_reference="$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX/$BUILDKITE_PIPELINE_SLUG/$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH"
git_cache_reference="${git_cache_reference%%/}"

export git_cache_reference
