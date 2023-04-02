#!/bin/bash

if ! grep -q "^$INSTANCE_URL" ~/.ssh/known_hosts; then
  ssh-keyscan "$INSTANCE_URL" >> ~/.ssh/known_hosts
fi
./act_runner register --instance "http://$INSTANCE_IP" --token "$RUNNER_TOKEN" --no-interactive --labels self-hosted
./act_runner daemon

cd repo
git remote -v | grep -w gitea || git remote add gitea "ssh://git@$INSTANCE_IP/$GITEA_REPO_NAME"