# `core/`

This directory contains the IaC for configuring [Proxmox](https://www.proxmox.com/en/), the type-1 hypervisor we install directly onto bare
metal.

## Secrets

`core/.env` now holds only non-secret configuration.

Encrypted secrets live in `core/.secrets.yaml` and are loaded directly by mise from `env._.file`.
The encrypted file is safe to commit.

Typical workflow:

```sh
cd ../bootstrap
mise install
mise run generate-age-key
mise run show-age-recipient
cd ../core
mise install
# put the printed recipient into core/.env as SOPS_AGE_RECIPIENTS
mise run init-secrets
mise run edit-secrets
```

By default mise looks for the age private key at `~/.config/mise/age.txt`. Override with `MISE_SOPS_AGE_KEY_FILE` if needed.

The `bootstrap`, `configure-proxmox`, and `deploy-dns` tasks automatically receive secrets from `.secrets.yaml`.
