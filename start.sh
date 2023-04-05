#!/bin/bash
./act_runner register --instance "http://gitea:${GITEA_PORT}" --token "$RUNNER_TOKEN" --no-interactive --labels self-hosted
./act_runner daemon