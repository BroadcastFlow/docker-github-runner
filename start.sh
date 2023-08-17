#!/bin/bash

cd /home/docker/actions-runner

REG_TOKEN=$(curl -sX POST -H "Authorization: token $ACCESS_TOKEN" https://api.github.com/orgs/$ORGANIZATION/actions/runners/registration-token | jq .token --raw-output)

if [ ! -f ".runner" ]; then
    ./config.sh --url https://github.com/$ORGANIZATION --token $REG_TOKEN --name $RUNNER_NAME --ephemeral
fi

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token $REG_TOKEN
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
