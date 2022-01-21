# ThingsBoard PE
An installation script for [ThingsBoard](https://thingsboard.io/) PE to run on an Ubuntu virtual machine. See the notes on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2)

This script installs the ThingsBoard service and a PostgreSQL database as per ThingsBoard PE [Ubuntu installation instructions](https://thingsboard.io/docs/user-guide/install/pe/ubuntu/).

# Installation

1. Clone this repository
2. Go into that directory: `cd ./thingsboard-vm`
3. Run the script as an administrator: `sudo sh install.sh`
4. Create service users for each subsystem
   1. PostgreSQL superuser `sudo -u postgres psql -c "\password"`
   2. PostgreSQL service user `createuser -h localhost --username postgres --pwprompt thingsboard`
5. Configure the license key and secrets
6. `cd`
7. `sudo /usr/share/thingsboard/bin/install/install.sh`

## Verify

Check we have OpenJDK version 11

```bash
java -version
```

Check the service is running:

```bash
sudo systemctl status thingsboard.service
```

View logs:

```bash
sudo journalctl -u thingsboard.service --since "24 hours ago"
```

