#!/bin/bash

set -xeuo pipefail

buildkite-agent meta-data set "${git_cache_reference}" "$BUILDKITE_COMMIT"
