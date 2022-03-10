#!/bin/bash

set -xeuo pipefail

export
printenv

# set_last_git_revision () {
#   aws ssm put-parameter \
#     --name "/sales-eng/custom-container-images/$CONDITIONAL_CHECK_SSM_PARAM_NAME" \
#     --region us-west-2 \
#     --type "String" \
#     --overwrite \
#     --value "$BUILDKITE_COMMIT"
# }

# # some inverted logic to allow propagation of exit codes
# if [ "${run_provided_cmd:-true}" == "true" ]
# then
#   $* && set_last_git_revision
# else
#   echo "No git diff for $previous_git_rev in $CONDITIONAL_CHECK_GIT_DIFF_PATH"
# fi

