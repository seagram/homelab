# `targets/ubuntu-docker/`

This target provisions a Docker host on Ubuntu and deploys the Compose stacks under `services/`.

## Secrets

`targets/ubuntu-docker/.env` now holds only non-secret configuration.

Encrypted secrets live in `targets/ubuntu-docker/.secrets.yaml` and are loaded directly by mise from `env._.file`.
The encrypted file is safe to commit.

Typical workflow:

```sh
cd ../../bootstrap
mise install
mise run generate-age-key
mise run show-age-recipient
cd ../targets/ubuntu-docker
mise install
# put the printed recipient into targets/ubuntu-docker/.env as SOPS_AGE_RECIPIENTS
mise run init-secrets
mise run edit-secrets
mise run install-ansible-deps
```

By default mise looks for the age private key at `~/.config/mise/age.txt`. Override with `MISE_SOPS_AGE_KEY_FILE` if needed.

Deploy commands automatically receive secrets from `.secrets.yaml`.
