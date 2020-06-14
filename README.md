# NFS server management.

***nfs_manager*** is shell tool for controlling/operating NFS Server.

Developed in bash code: ***100%***.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/nfs_manager.svg)](https://github.com/vroncevic/nfs_manager/issues)
 [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/nfs_manager.svg)](https://github.com/vroncevic/nfs_manager/graphs/contributors)

<!-- START doctoc -->
**Table of Contents**

- [Installation](https://github.com/vroncevic/nfs_manager#installation)
- [Usage](https://github.com/vroncevic/nfs_manager#usage)
- [Dependencies](https://github.com/vroncevic/nfs_manager#dependencies)
- [Shell tool structure](https://github.com/vroncevic/nfs_manager#shell-tool-structure)
- [Docs](https://github.com/vroncevic/nfs_manager#docs)
- [Copyright and Licence](https://github.com/vroncevic/nfs_manager#copyright-and-licence)
<!-- END doctoc -->

### INSTALLATION

Navigate to release [page](https://github.com/vroncevic/nfs_manager/releases) download and extract release archive.

To install modules type the following:

```
tar xvzf nfs_manager-x.y.z.tar.gz
cd nfs_manager-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/nfs_manager/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/nfs_manager/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/nfs_manager/ver.1.0/
```

![alt tag](https://raw.githubusercontent.com/vroncevic/nfs_manager/dev/docs/setup_tree.png)

Or You can use docker to create image/container.

### USAGE

```
# Create symlink for shell tool
ln -s /root/scripts/nfs_manager/ver.1.0/bin/nfs_manager.sh /root/bin/nfs_manager

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating NFS Server
nfs_manager version
```

### DEPENDENCIES

This tool requires these other modules and libraries:

* sh_util https://github.com/vroncevic/sh_util

### SHELL TOOL STRUCTURE

***nfs_manager*** is based on MOP.

Shell tool structure:
```
.
├── bin/
│   ├── nfs_list.sh
│   ├── nfs_manager.sh
│   ├── nfs_operation.sh
│   └── nfs_version.sh
├── conf/
│   ├── nfs_manager.cfg
│   └── nfs_manager_util.cfg
└── log/
    └── nfs_manager.log
```

### DOCS

[![Documentation Status](https://readthedocs.org/projects/nfs_manager/badge/?version=latest)](https://nfs_manager.readthedocs.io/projects/nfs_manager/en/latest/?badge=latest)

More documentation and info at:

* https://nfs_manager.readthedocs.io/en/latest/

### COPYRIGHT AND LICENCE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2018 by https://vroncevic.github.io/nfs_manager

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

