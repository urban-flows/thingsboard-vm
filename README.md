# ThingsBoard PE
An installation script for [ThingsBoard](https://thingsboard.io/) PE to run on an Ubuntu virtual machine. See the notes on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2)

This script installs the ThingsBoard service and a PostgreSQL database as per ThingsBoard PE [Ubuntu installation instructions](https://thingsboard.io/docs/user-guide/install/pe/ubuntu/).

# Installation

1. Clone this repository
2. Go into that directory: `cd ./thingsboard-vm`
3. Run the script as an administrator: `sudo sh install.sh`
3. Check for any configuration changes: `diff ./thingsboard.conf /etc/thingsboard/conf/thingsboard.conf`
4. Create service users for each subsystem
   1. PostgreSQL superuser `sudo -u postgres psql -c "\password"`
   2. PostgreSQL service user `createuser -h localhost --username postgres --pwprompt thingsboard`
5. Configure the license key and secrets: `sudo vi /etc/thingsboard/thingsboard.conf`
6. Go to your home directory `cd ~`
7. Run the ThingsBoard installation script: `sudo /usr/share/thingsboard/bin/install/install.sh`
7. Start the services

## Verify

Check we have OpenJDK version 11

```bash
java -version
```

Check the service is running:

```bash
sudo systemctl status thingsboard.service
```

Check HAProxy is installed

```bash
haproxy -v
```

# Monitoring

View logs:

```bash
sudo journalctl -u thingsboard.service --since "24 hours ago"
```

