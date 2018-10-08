#!/bin/bash

set -eu

# init operator
vault operator init -format=json -key-shares=1 -key-threshold=1 > \
	/etc/vault/secrets.json

# check source
if [ ! -e /etc/vault/secrets.json ]; then
	echo "file /etc/vault/secrets.json is not readable."
	exit 1
fi

# unseal vault
cat /etc/vault/secrets.json | \
	/snap/bin/jq '.unseal_keys_b64|.[0]' | \
	sed -e 's/^"//' -e 's/"$//' | \
	xargs vault operator unseal

# login vault
cat /etc/vault/secrets.json | \
	/snap/bin/jq '.root_token' | \
	sed -e 's/^"//' -e 's/"$//' | \
	xargs vault login

# mount concourse
vault mount -path=/concourse -description="Secrets for concourse pipelines" generic

# create policy
vault policy write policy-concourse /etc/vault/concourse-policy.hcl

# create token for concourse
vault token-create --policy=policy-concourse -period="600h" -format=json | \
	/snap/bin/jq '.auth | .client_token' | \
	sed -e 's/^"//' -e 's/"$//' | \
	tee /etc/vault/concourse-token


