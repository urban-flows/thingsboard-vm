#!/usr/bin/env sh

thingsboard_version="3.3.2pe"

# Exit immediately if a command exits with a non-zero status.
set -e

# Step 0 - Upgrade OS packages
apt update
apt upgrade --yes
apt install --yes wget

# Step 1. Install Java 11 (OpenJDK)
apt install --yes openjdk-11-jdk

# Step 2. ThingsBoard service installation
wget "https://dist.thingsboard.io/thingsboard-$thingsboard_version.deb" --output-document=thingsboard.deb
dpkg -i thingsboard.deb
# Backup original configuration file
cp --preserve=mode,ownership --verbose --no-clobber /etc/thingsboard/conf/thingsboard.conf /etc/thingsboard/conf/thingsboard.conf.bak

# Step 3. Obtain and configure license key
cat /etc/thingsboard/conf/thingsboard.conf.bak ./thingsboard_license.conf > /etc/thingsboard/conf/thingsboard.conf
