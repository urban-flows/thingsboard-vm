#!/usr/bin/env sh

# ThingsBoard PE installation script
# https://thingsboard.io/docs/user-guide/install/pe/ubuntu

thingsboard_version="3.3.1pe"
release=$(lsb_release -cs)

# Exit immediately if a command exits with a non-zero status.
set -e

# Step 0 - Upgrade OS packages
apt-get -qq update
apt-get -qq upgrade --yes
apt-get -qq install --yes wget

# Step 1. Install Java 11 (OpenJDK)
apt install --yes openjdk-11-jdk

# Step 2. ThingsBoard service installation
wget --quiet "https://dist.thingsboard.io/thingsboard-$thingsboard_version.deb" --output-document=/tmp/thingsboard.deb
dpkg -i /tmp/thingsboard.deb
# Backup original configuration file
cp --preserve=mode,ownership --verbose --no-clobber /etc/thingsboard/conf/thingsboard.conf /etc/thingsboard/conf/thingsboard.conf.bak

# Step 3. Obtain and configure license key
sed -i 's/# export TB_LICENSE_SECRET/export TB_LICENSE_SECRET/g' /etc/thingsboard/conf/thingsboard.conf
echo "You must manually configure the ThingsBoard license key"
echo "Set TB_LICENSE_SECRET in /etc/thingsboard/conf/thingsboard.conf"

# Step 4. Configure ThingsBoard database
# Install PostgreSQL
# import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# add repository contents to your system:
echo "deb http://apt.postgresql.org/pub/repos/apt/ ${release}"-pgdg main > /etc/apt/sources.list.d/pgdg.list
# install and launch the postgresql service:
apt-get -qq install --yes postgresql-12
service postgresql start
#sudo -u postgres psql -c "\password"
#createuser -h localhost --username postgres --pwprompt thingsboard
#createdb -h localhost --username postgres --owner thingsboard thingsboard

# Append custom configuration
echo "You must manually configure the database login"
echo "Set SPRING_DATASOURCE_PASSWORD in /etc/thingsboard/conf/thingsboard.conf"

# Step 5. Choose ThingsBoard queue service
# Install RabbitMQ
#apt-get -qq install --yes erlang rabbitmq-server
#systemctl enable rabbitmq-server.service
#systemctl start rabbitmq-server.service
# Create admin user
#rabbitmqctl add_user $USER password
#rabbitmqctl set_user_tags $USER administrator
#rabbitmqctl set_permissions -p / $USER ".*" ".*" ".*"
# Create service user
#rabbitmqctl add_user thingsboard password
#rabbitmqctl set_permissions -p / thingsboard ".*" ".*" ".*"
#echo "You must manually configure the database login"
#echo "Set TB_QUEUE_RABBIT_MQ_PASSWORD in /etc/thingsboard/conf/thingsboard.conf"

# Show configuration differences
diff ./thingsboard.conf /etc/thingsboard/conf/thingsboard.conf

# Step 7. Run installation script
#/usr/share/thingsboard/bin/install/install.sh

# Step 8. Start ThingsBoard service
#service thingsboard start

# Disable CORS for security reasons
# SHEF 2201 9482
# Make sure the original config file is backed up
cp --preserve=mode,ownership --verbose --no-clobber /etc/thingsboard/conf/thingsboard.yml /etc/thingsboard/conf/thingsboard.yml.bak
# Disable CORS (escape the asterisk character)
sed --in-place 's/allowed-origins: "\*"/allowed-origins: ""/g' /etc/thingsboard/conf/thingsboard.yml
