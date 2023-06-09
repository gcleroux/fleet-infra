#!/usr/bin/bash

# Creating the cluster
kind create cluster

# Exporting env var for flux bootstrap
export GITHUB_USER=$(cat ./secrets/github_account)
export GITHUB_TOKEN=$(cat ./secrets/github_token)

# Secret to pull image from ghcr private repo
kubectl -n default create secret docker-registry ghcr-login-secret \
    --docker-server=https://ghcr.io \
    --docker-username="$(cat ./secrets/github_account)" \
    --docker-password="$(cat ./secrets/ghcr_token)"

# Bootstrapping flux on the cluster
flux bootstrap github \
    --components-extra=image-reflector-controller,image-automation-controller \
    --owner="$GITHUB_USER" \
    --repository=fleet-infra \
    --branch=main \
    --path=clusters/my-cluster \
    --personal \
    --read-write-key

# Adding discord secret url to cluster
kubectl -n flux-system create secret generic discord-url \
    --from-literal=address="$(cat ./secrets/discord_webhook)"
