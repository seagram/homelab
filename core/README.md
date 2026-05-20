# `core/`

## Secrets

Non-sensitive secrets are stored in `core/.env`
Sensitive secrets are stored and encrypted in `core/.secrets.yaml` and are loaded directly by `mise` from `env._.file`.
> Note: both files are safe to commit publicly as the sensitive secrets are encrypted with `sops` and AWS KMS.
