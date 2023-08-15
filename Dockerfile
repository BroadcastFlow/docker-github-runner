# base
FROM ubuntu:20.04

# set the github runner version
ARG RUNNER_VERSION="2.307.1"

# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# Set timezone to Europe/Dublin and prevent prompts
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Dublin /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# install necessary packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip sudo

# Allow the docker user to run the svc.sh script without a password
RUN echo "docker ALL=NOPASSWD: /home/docker/actions-runner/svc.sh" >> /etc/sudoers

# Download and setup the GitHub runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# set the user to "docker"
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
