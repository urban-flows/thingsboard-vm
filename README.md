# ThingsBoard PE
An installation script for [ThingsBoard](https://thingsboard.io/) PE to run on an Ubuntu virtual machine. See the notes on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2)

This script installs the ThingsBoard service and a PostgreSQL database as per ThingsBoard PE [Ubuntu installation instructions](https://thingsboard.io/docs/user-guide/install/pe/ubuntu/).

# Installation

1. Clone this repository
2. Go into that directory: `cd ./thingsboard-vm`
3. Create a secret license file: `echo "export TB_LICENSE_SECRET=YOUR_LICENSE_SECRET_HERE" > thingsboard_license.conf` and insert the license key in that file.
4. Run the script as an administrator: `sudo sh install.sh`

## Verify

Check we have OpenJDK version 11

```bash
java -version
```

