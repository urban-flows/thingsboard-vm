# ThingsBoard PE
An installation script and configuration for [ThingsBoard](https://thingsboard.io/) PE to run on an Ubuntu virtual machine.

**See the notes on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2)**

## Architecture

See: [ThingsBoard Microservices architecture](https://thingsboard.io/docs/reference/msa/)

# Installation

This process and shell script installs the ThingsBoard service, a RabbitMQ message broker, a PostgreSQL database, and a HAProxy reverse web proxy, as per ThingsBoard PE [Ubuntu installation instructions](https://thingsboard.io/docs/user-guide/install/pe/ubuntu/).

1. Update operating system packages:
   1. `apt update`
   2. `apt upgrade`

2. Clone this repository
3. Go into that directory: `cd ./thingsboard-vm`
4. Run the script as an administrator: `sudo sh install.sh` (this script should be idempotent and safe to run for initial installation, changes, and upgrades.)
5. Create service users for each subsystem
   1. PostgreSQL superuser `sudo -u postgres psql -c "\password"`
   2. PostgreSQL service user `createuser -h localhost --username postgres --pwprompt thingsboard`
6. Set up RabbitMQ logins
   1. Delete guest user: `rabbitmqctl delete_user guest`
   2. Create service user
      1. `rabbitmqctl add_user thingsboard <password>`
      2. `rabbitmqctl set_permissions -p / thingsboard ".*" ".*" ".*"`

7. Check for any configuration changes: `diff ./thingsboard.conf /etc/thingsboard/conf/thingsboard.conf`
8. Configure the license key and secrets: `sudo vi /etc/thingsboard/conf/thingsboard.conf`
9. Go to your home directory `cd ~`
10. Run the ThingsBoard installation script: `sudo /usr/share/thingsboard/bin/install/install.sh`
11. Start the services

## Verify

Run the commands below to check everything's set up properly. Also see the notes on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2).

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

# Administration

Check the documentation for each of the subsystems.
