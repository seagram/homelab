#!/usr/bin/env bash
set -euo pipefail

cd ./terraform

TAILSCALE_OAUTH_CLIENT_ID=$(terraform output -raw tailscale_oauth_id)
export TAILSCALE_OAUTH_CLIENT_ID

TAILSCALE_OAUTH_CLIENT_SECRET=$(terraform output -raw tailscale_oauth_key)
export TAILSCALE_OAUTH_CLIENT_SECRET

cd ../kubernetes/

helmfile apply
