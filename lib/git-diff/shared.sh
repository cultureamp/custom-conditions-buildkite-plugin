#!/bin/bash

export
printenv

test -n "${BUILDKITE_COMMIT:-}" || { echo "BUILDKITE_COMMIT environment variable must be provided" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH:-}" || BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH="."
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path option must be provided" ; exit 1;}
test -x "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_SCRIPT_PATH:-}" || { echo "script-path not found or invalid" ; exit 1;}
test -n "${BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX:-}" || { echo "ssm-prefix option must be provided" ; exit 1;}

git_cache_reference="$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_CACHE_PREFIX/$BUILDKITE_PIPELINE_SLUG/$BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_GIT_PATH"
git_cache_reference="${git_cache_reference%%/}"

export git_cache_reference