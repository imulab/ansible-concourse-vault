#!/bin/bash

# extract all 5 unseal keys
for i in 1 2 3 4 5; do
  cat /etc/vault/secrets | grep "Unseal Key $i: " | sed -e "s/^Unseal\sKey\s$i:\s//" > "/etc/vault/unseal.key.$i"
done

# extract root token
cat /etc/vault/secrets | grep "Initial Root Token: " | sed -e "s/^Initial\sRoot\sToken:\s//" > /etc/vault/root_token
