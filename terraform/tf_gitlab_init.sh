#!/usr/bin/env bash

export GITLAB_ACCESS_TOKEN="$(pass gitlab-all-access-pat)"
export TF_STATE_NAME="homelab-cluster"
tofu init \
	-backend-config="address=https://gitlab.com/api/v4/projects/23069628/terraform/state/$TF_STATE_NAME" \
	-backend-config="lock_address=https://gitlab.com/api/v4/projects/23069628/terraform/state/$TF_STATE_NAME/lock" \
	-backend-config="unlock_address=https://gitlab.com/api/v4/projects/23069628/terraform/state/$TF_STATE_NAME/lock" \
	-backend-config="username=insanitywholesale" \
	-backend-config="password=$GITLAB_ACCESS_TOKEN" \
	-backend-config="lock_method=POST" \
	-backend-config="unlock_method=DELETE" \
	-backend-config="retry_wait_min=5"
