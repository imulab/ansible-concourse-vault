# ansible-concourse-vault
Ansible playbook to bootstrap a single node Concourse CI Server, back by Vault and PostgreSQL

## TLDR;

**Prerequisites:**
- Ubuntu 18.04 LTS

```bash
git clone https://github.com/imulab/ansible-concourse-vault.git
cd ansible-concourse-vault
sudo -s
chmod +x install
./install
```

If you encounter an error complaining about ansible dependency `sshpass` is not met, update your `/etc/apt/sources.list` with [this](https://gist.github.com/jackw1111/d31140946901fab417131ff4d9ae92e3).

Downloading Concourse executable may take some time. After the installation finishes:

```bash
# absorb the VAULT_ADDR environment variable
source /etc/environment

# you should see vault is unsealed now.
vault status 							

# check out vault seal key and root token	
cat /opt/deployment-secrets/secrets.json

# login to vault
vault login <your_vault_root_token>

# write some secret
vault write concourse/main/foo value=bar
vault write concourse/main/key value=@my_key
```

## What it does

This playbook installs and configures [Concourse CI](https://concourse-ci.org) in an opinionated fashion to allow personal/lab use of a continuous integration server that can manage secrets using [Vault](https://www.vaultproject.io) in a minimal way.

Some of the opinions that this playbook took:
- Vault is installed and enabled on `localhost` with no TLS.
- Vault uses a local file backend, which is placed by default at `/mnt/vault/data`.
- Vault issues only one seal key.
- Vault places seal key and root token at `/opt/deployment-secrets`.
- After the installation, Vault is unsealed.
- Concourse is enabled on the external ip address specified by user during installation and on default port `8080`.

## Resources

- [Setting Up and Using Concourse CI on Ubuntu 16.04](https://www.digitalocean.com/community/tutorial_series/setting-up-and-using-concourse-ci-on-ubuntu-16-04) by [Digital Ocean](https://www.digitalocean.com)
- [Vault Integration with Concourse](https://github.com/pivotalservices/concourse-pipeline-samples/tree/master/concourse-pipeline-patterns/vault-integration) by [Pivotal Services](https://github.com/pivotalservices)
- [Secure credential automation with Vault](https://github.com/pivotal-cf/pcf-pipelines/blob/master/docs/vault-integration.md) by [Pivotal Services](https://github.com/pivotalservices)