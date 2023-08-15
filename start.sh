#!/bin/bash
cd /home/docker/actions-runner
REG_TOKEN=$(curl -sX POST -H "Authorization: token $ACCESS_TOKEN" https://api.github.com/orgs/$ORGANIZATION/actions/runners/registration-token | jq .token --raw-output)

cd /home/docker/actions-runner

if [ ! -f ".runner" ]; then
    ./config.sh --url https://github.com/$ORGANIZATION --token $REG_TOKEN --name DEV_DOCKER_RUNNER
fi

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token $REG_TOKEN
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# Install the runner as a service
sudo ./svc.sh install

# Start the runner service
sudo ./svc.sh start

# Keep the script running
tail -f /dev/null
