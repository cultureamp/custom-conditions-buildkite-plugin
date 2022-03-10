#!/bin/bash


test -n "${BUILDKITE_COMMIT:-}" || { echo "BUILDKITE_COMMIT environment variable must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_NAME:-}" || { echo "condition name must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX:-}" || { echo "cache-prefix option must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH:-}" || BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH="."

git_cache_reference="$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX/$BUILDKITE_PIPELINE_SLUG/$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH"
git_cache_reference="${git_cache_reference%%/}"

export git_cache_reference
