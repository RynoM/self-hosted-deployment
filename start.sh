#!/bin/bash
# Register if registration result file does not exist yet
mkdir -p /repo/gitea_act
[ -f runner_config.yaml ] && mv runner_config.yaml /repo/gitea_act/
if [ ! -f /repo/gitea_act/.runner ]
then
    ./act_runner register -c /repo/gitea_act/runner_config.yaml --instance "http://gitea:${GITEA_PORT}" --token "$RUNNER_TOKEN" --no-interactive --labels self-hosted
fi
./act_runner -c /repo/gitea_act/runner_config.yaml daemon