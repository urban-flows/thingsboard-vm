#!/usr/bin/env sh

# ThingsBoard PE installation script
# https://thingsboard.io/docs/user-guide/install/pe/ubuntu

thingsboard_version="3.3.2pe"
release=$(lsb_release -cs)

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

# Step 4. Configure ThingsBoard database
# Install PostgreSQL
# import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# add repository contents to your system:

echo "deb http://apt.postgresql.org/pub/repos/apt/ ${release}"-pgdg main | sudo tee /etc/apt/sources.list.d/pgdg.list

# install and launch the postgresql service:
apt install postgresql-12
service postgresql start
# sudo -u postgres psql -c "\password"
#createuser -h localhost --username postgres --pwprompt thingsboard

# Append custom configuration
cat ./thingsboard_extra.conf >> /etc/thingsboard/conf/thingsboard.conf
