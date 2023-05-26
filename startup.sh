#!/usr/bin/bash

# Creating the cluster
kind create cluster

# Exporting env var for flux bootstrap
export GITHUB_USER=$(cat ./secrets/github_account)
export GITHUB_TOKEN=$(cat ./secrets/github_token)

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
discord_url=$(cat ./secrets/discord_webhook)

kubectl -n flux-system create secret generic discord-url \
    --from-literal=address="$discord_url"
