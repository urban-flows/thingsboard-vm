#!/usr/bin/env sh

# Exit immediately if a command exits with a non-zero status.
set -e

apt update
apt upgrade --yes
apt install --yes openjdk-11-jdk
