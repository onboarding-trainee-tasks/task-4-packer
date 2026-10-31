# Onboarding Task 4 — Packer AMIs

This repository builds AMIs for the Task 4 Ansible controller and web server. Terraform infrastructure is in `task-4-infra`; the runtime configuration is in `task-4-ansible`.

## Images

| Directory | Image | Preinstalled components |
| --- | --- | --- |
| `ansible/` | Ansible Controller | Ansible and basic administration tools |
| `web-server/` | Web Server | Ubuntu 24.04, Nginx, Docker, Docker Compose v2, OAuth2 Proxy 7.15.3 |

The Web Server image contains **no** OAuth client secrets, Keycloak realm, application users or Nginx domain configuration. Ansible configures those after EC2 startup.

## Local Web Server AMI build

Run in WSL or another environment with Packer and AWS credentials for `eu-central-1`:

```bash
cd web-server
packer init .
packer fmt -check .
packer validate .
packer build .
```

Read the resulting AMI ID from `packer-manifest.json` or the build log. Terraform must use the new AMI ID for `module.web_server_instance.ami_id`.

## GitHub Actions

The existing workflow `.github/workflows/packer.yml` runs on a PR **labeled** with:

- `build:web-server` — build Web Server AMI from `web-server/`.
- `build:ansible` — build Ansible Controller AMI from `ansible/`.

It authenticates through GitHub OIDC and the `T4-build` Environment. Use a PR targeting `main`. The workflow reads `packer-manifest.json` and reports the AMI ID in the job summary.

The Ansible Controller Packer template currently copies an SSH **private key** into the resulting AMI via the `ANSIBLE_SSH_PRIVATE_KEY_B64` GitHub secret. This is an acknowledged training-only risk: access to the image/snapshot implies access to the private key. Do not replicate this approach for production. Prefer delivering the internal key securely to the controller after instance creation and retire old AMIs/snapshots containing outdated keys.