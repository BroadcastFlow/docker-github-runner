# GitHub Runner Docker Image

This repository contains a Dockerfile to build a GitHub Runner image with specific dependencies.

## Dockerfile Overview

The Dockerfile uses `ubuntu:20.04` as the base image and installs the necessary dependencies for the GitHub Runner. The runner version can be specified using the `RUNNER_VERSION` build argument.

## GitHub Actions Workflow

We have set up a GitHub Actions workflow that checks for new releases of the GitHub Runner every weekday at 9:30 am. If a new version is detected, the workflow builds a new Docker image and pushes it to GitHub's container registry (GHCR).

## Usage

To pull the latest version of the GitHub Runner Docker image from GHCR:

```docker pull ghcr.io/threemedia/docker-github-runner:<TAG>```

Replace <TAG> with the desired version tag.