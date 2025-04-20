#!/bin/bash

KEY_NAME="id_rsa_mykey"
KEY_PATH="$HOME/.ssh/$KEY_NAME"

# Generate SSH key without prompt (no passphrase)
ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -q

echo "SSH key generated:"
echo "Private key: $KEY_PATH"
echo "Public key : ${KEY_PATH}.pub"

echo "Adding ssh keys:"
eval "$(ssh-agent -s)" 
ssh-add $KEY_PATH
ssh-add -l

echo " SSH Keys added"

echo "###### Adding Identify key file in ssh config file ########"
cat <<EOF >> ~/.ssh/config

Host github.com
  HostName github.com
  User git
  IdentityFile $KEY_PATH

EOF

ssh -T git@github.com
