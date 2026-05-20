# `targets/ubuntu-docker/`

This target provisions a Docker host on Ubuntu and deploys the Compose stacks under `services/`.

## Secrets

`targets/ubuntu-docker/.env` now holds only non-secret configuration.

Encrypted secrets live in `targets/ubuntu-docker/.secrets.yaml` and are loaded directly by mise from `env._.file`.
The encrypted file is safe to commit.

Secrets are encrypted with AWS KMS via SOPS. The KMS key and repo-root `.sops.yaml`
are provisioned by `../../bootstrap`.

Typical workflow:

```sh
cd ../../bootstrap
mise install
mise run bootstrap          # creates KMS key + writes ../.sops.yaml
cd ../targets/ubuntu-docker
mise install
mise run init-secrets
mise run edit-secrets
mise run install-ansible-deps
```

Decryption requires AWS credentials with `kms:Decrypt` on the `alias/homelab-sops` key.

Deploy commands automatically receive secrets from `.secrets.yaml`.
