# ThingsBoard PE
An installation script for [ThingsBoard](https://thingsboard.io/) PE to run on an Ubuntu virtual machine. See the notes on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2)

This script installs the ThingsBoard service and a PostgreSQL database as per ThingsBoard PE [Ubuntu installation instructions](https://thingsboard.io/docs/user-guide/install/pe/ubuntu/).

# Installation

1. Clone this repository
2. Go into that directory: `cd ./thingsboard-vm`
3. Run the script as an administrator: `sudo sh install.sh`
4. Configure the license key and secrets

## Verify

Check we have OpenJDK version 11

```bash
java -version
```

