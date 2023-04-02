#!/bin/bash

touch ~/.ssh/known_hosts  # make sure it exists
if ! grep -q "^$INSTANCE_URL" ~/.ssh/known_hosts; then
  ssh-keyscan "$INSTANCE_URL" >> ~/.ssh/known_hosts
fi

cd repo
git remote -v | grep -w gitea || git remote add gitea "ssh://git@$INSTANCE_IP:222/$GITEA_REPO_NAME.git"

cd /
./act_runner register --instance "http://$INSTANCE_IP:$GITEA_PORT" --token "$RUNNER_TOKEN" --no-interactive --labels self-hosted
./act_runner daemon