#!/usr/bin/env bash

set -euo pipefail
[ "${BUILDKITE_PLUGIN_DEBUG:-false}" == "true" ] && set -x ||:

plugin_prefix="BUILDKITE_PLUGIN_CUSTOM_CONDITIONS_"

# Reads either a value or a list from plugin config
function plugin_read_list() {
  prefix_read_list "${plugin_prefix}${1}"
}

# Reads either a value or a list from the given env prefix
function prefix_read_list() {
  local prefix="${1}"
  local parameter="${prefix}_0"

  if [[ -n "${!parameter:-}" ]]; then
    local i=0
    local parameter="${prefix}_${i}"
    while [[ -n "${!parameter:-}" ]]; do
      echo -n "${!parameter}"
      i=$((i+1))
      parameter="${prefix}_${i}"
    done
  elif [[ -n "${!prefix:-}" ]]; then
    echo -n "${!prefix}"
  fi
}
