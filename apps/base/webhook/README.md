# Webhook test

This deployment will not run automatically since no kustomization.yaml
file is given.

You must first create a secret `name: webhook-private-key`
with this command

```bash
kubectl -n webhook create secret generic webhook-private-key \
    --from-literal=webhook-private-key="$(cat ./secrets/webhook_prv_key)"
```

This command assumes you are running it from the project's root dir.
