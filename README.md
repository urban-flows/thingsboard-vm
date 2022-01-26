# ThingsBoard PE
An installation script and configuration for [ThingsBoard](https://thingsboard.io/) PE to run on an Ubuntu virtual machine.

**See the notes on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2)**

# Installation

This process and shell script installs the ThingsBoard service and a PostgreSQL database as per ThingsBoard PE [Ubuntu installation instructions](https://thingsboard.io/docs/user-guide/install/pe/ubuntu/).

1. Clone this repository
2. Go into that directory: `cd ./thingsboard-vm`
3. Run the script as an administrator: `sudo sh install.sh`
3. Check for any configuration changes: `diff ./thingsboard.conf /etc/thingsboard/conf/thingsboard.conf`
4. Create service users for each subsystem
   1. PostgreSQL superuser `sudo -u postgres psql -c "\password"`
   2. PostgreSQL service user `createuser -h localhost --username postgres --pwprompt thingsboard`
6. Set up RabbitMQ logins
   1. Create admin user
      1. `rabbitmqctl add_user <sa_user> password`
      2. `rabbitmqctl set_user_tags <sa_user> administrator`
      3. `rabbitmqctl set_permissions -p / <sa_user> ".*" ".*" ".*"`

   2. Create service user
      1. `rabbitmqctl add_user thingsboard password`
      2. `rabbitmqctl set_permissions -p / thingsboard ".*" ".*" ".*"`

7. Configure the license key and secrets: `sudo vi /etc/thingsboard/thingsboard.conf`
8. Go to your home directory `cd ~`
9. Run the ThingsBoard installation script: `sudo /usr/share/thingsboard/bin/install/install.sh`
10. Start the services

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

