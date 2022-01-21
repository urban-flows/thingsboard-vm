# ThingsBoard PE
An installation script for [ThingsBoard](https://thingsboard.io/) PE to run on an Ubuntu virtual machine

Docs on [ITS Wiki ufiot2](https://itswiki.shef.ac.uk/wiki/Ufiot2)

ThingsBoard PE [Ubuntu installation instructions](https://thingsboard.io/docs/user-guide/install/pe/ubuntu/).

# Installation

1. Clone this repository
2. Create a secret license file `thingsboard_license.conf` which contains `export TB_LICENSE_SECRET=YOUR_LICENSE_SECRET_HERE`
3. Run the script as an administrator: `sudo sh install.sh`

## Verify

Check we have OpenJDK version 11

```bash
java -version
```

