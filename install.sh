#!/usr/bin/env sh

# ThingsBoard PE installation script
# https://thingsboard.io/docs/user-guide/install/pe/ubuntu

# This script should be idempotent and safe to run for initial installation,
# changes, and upgrades

thingsboard_version="3.3.1pe"
release=$(lsb_release -cs)

# Exit immediately if a command exits with a non-zero status.
set -e

# Step 0 - Upgrade OS packages
apt-get -qq update
apt-get -qq upgrade --yes
apt-get -qq install --yes wget

# Step 1. Install Java 11 (OpenJDK)
echo "Installing Java..."
apt install --yes openjdk-11-jdk

# Step 2. ThingsBoard service installation
echo "Installing ThingsBoard $thingsboard_version..."
wget --quiet "https://dist.thingsboard.io/thingsboard-$thingsboard_version.deb" --output-document=/tmp/thingsboard.deb
dpkg -i /tmp/thingsboard.deb
# Make config file (which contains passwords) private
chmod 640 /etc/thingsboard/conf/thingsboard.conf
# Backup original configuration file
cp --preserve=mode,ownership --verbose --no-clobber /etc/thingsboard/conf/thingsboard.conf /etc/thingsboard/conf/thingsboard.conf.bak

# Step 3. Obtain and configure license key
sed -i 's/# export TB_LICENSE_SECRET/export TB_LICENSE_SECRET/g' /etc/thingsboard/conf/thingsboard.conf
echo "You must manually configure the ThingsBoard license key"
echo "Set TB_LICENSE_SECRET in /etc/thingsboard/conf/thingsboard.conf"

# Step 4. Configure ThingsBoard database
# Install PostgreSQL
# import the repository signing key:
echo "Installing PostgreSQL..."
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# add repository contents to your system:
echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ ${release}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
# install and launch the postgresql service:
apt-get -qq install --yes postgresql-12
#service postgresql start
#sudo -u postgres psql -c "\password"
#createuser -h localhost --username postgres --pwprompt thingsboard
#createdb -h localhost --username postgres --owner thingsboard thingsboard

# Append custom configuration
echo "You must manually configure the database login"
echo "Set SPRING_DATASOURCE_PASSWORD in /etc/thingsboard/conf/thingsboard.conf"

# Step 5. Choose ThingsBoard queue service
# Install RabbitMQ
apt-get -qq install --yes erlang rabbitmq-server
# Delete guest user
# rabbitmqctl delete_user guest
# Create service user
#rabbitmqctl add_user thingsboard <password>
#rabbitmqctl set_permissions -p / thingsboard ".*" ".*" ".*"
echo "You must manually configure the database login"
echo "Set TB_QUEUE_RABBIT_MQ_PASSWORD in /etc/thingsboard/conf/thingsboard.conf"

# Step 7. Run installation script
#/usr/share/thingsboard/bin/install/install.sh

# Install HAProxy
# https://www.haproxy.com/blog/how-to-install-haproxy-on-ubuntu/
# We'll use the PPA to get the latest LTS version
echo "Installing HAProxy..."
apt-get -qq install --yes --no-install-recommends software-properties-common
add-apt-repository --yes ppa:vbernat/haproxy-2.4
apt-get -qq install --yes haproxy=2.4.\*

# Backup original config file
cp --preserve=mode,ownership --verbose --no-clobber /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
# Install our proxy configuration file
cp -v ./haproxy.cfg /etc/haproxy/haproxy.cfg

# Disable CORS for security reasons
# SHEF 2201 9482
# Make sure the original config file is backed up
cp --preserve=mode,ownership --verbose --no-clobber /etc/thingsboard/conf/thingsboard.yml /etc/thingsboard/conf/thingsboard.yml.bak
# Restrict CORS to this domain (escape the forward-slashes in the URL)
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin
sed --in-place 's/allowed-origins:.*/allowed-origins: "https:\/\/ufiot2.shef.ac.uk"/g' /etc/thingsboard/conf/thingsboard.yml

# Step 8. Start ThingsBoard service
#service thingsboard start

# Create database backup directory
backup_dir=/mnt/data/pg_dump
mkdir --parents --verbose thingsboard $backup_dir
chown --recursive thingsboard:thingsboard $backup_dir
chmod --recursive 775 $backup_dir

# Install database backup script
mkdir --parents /home/thingsboard
cp ./backup_database.sh /home/thingsboard/backup_database.sh
touch /home/thingsboard/.pgpass
chown thingsboard:thingsboard /home/thingsboard/.pgpass
chmod 600 /home/thingsboard/.pgpass
echo "You must manually input the database password into /home/thingsboard/.pgpass"
crontab -u thingsboard ./crontab.txt
