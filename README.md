<img align="right" src="https://raw.githubusercontent.com/vroncevic/nfs_manager/dev/docs/nfs_manager_logo.png" width="25%">

# NFS server management

**nfs_manager** is shell tool for controlling/operating NFS Server.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![nfs_manager shell checker](https://github.com/vroncevic/nfs_manager/workflows/nfs_manager%20shell%20checker/badge.svg)](https://github.com/vroncevic/nfs_manager/actions?query=workflow%3A%22nfs_manager+shell+checker%22)

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/nfs_manager.svg)](https://github.com/vroncevic/nfs_manager/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/nfs_manager.svg)](https://github.com/vroncevic/nfs_manager/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Shell tool structure](#shell-tool-structure)
- [Docs](#docs)
- [Copyright and licence](#copyright-and-licence)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

![Debian Linux OS](https://raw.githubusercontent.com/vroncevic/nfs_manager/dev/docs/debtux.png)

Navigate to release **[page](https://github.com/vroncevic/nfs_manager/releases)** download and extract release archive.

To install **nfs_manager** type the following:

```
tar xvzf nfs_manager-x.y.tar.gz
cd nfs_manager-x.y
cp -R ~/sh_tool/bin/   /root/scripts/nfs_manager/ver.x.y/
cp -R ~/sh_tool/conf/  /root/scripts/nfs_manager/ver.x.y/
cp -R ~/sh_tool/log/   /root/scripts/nfs_manager/ver.x.y/
```

Self generated setup script and execution
```
./nfs_manager_setup.sh

[setup] installing App/Tool/Script nfs_manager
	Sun 28 Nov 2021 06:19:10 PM CET
[setup] clean up App/Tool/Script structure
[setup] copy App/Tool/Script structure
[setup] remove github editor configuration files
[setup] set App/Tool/Script permission
[setup] create symbolic link of App/Tool/Script
[setup] done

/root/scripts/nfs_manager/ver.2.0/
├── bin/
│   ├── center.sh
│   ├── display_logo.sh
│   ├── nfs_list.sh
│   ├── nfs_manager.sh
│   ├── nfs_operation.sh
│   └── nfs_version.sh
├── conf/
│   ├── nfs_manager.cfg
│   ├── nfs_manager.logo
│   └── nfs_manager_util.cfg
└── log/
    └── nfs_manager.log

3 directories, 10 files
lrwxrwxrwx 1 root root 52 Nov 28 18:19 /root/bin/nfs_manager -> /root/scripts/nfs_manager/ver.2.0/bin/nfs_manager.sh
```

Or You can use docker to create image/container.

[![nfs_manager docker checker](https://github.com/vroncevic/nfs_manager/workflows/nfs_manager%20docker%20checker/badge.svg)](https://github.com/vroncevic/nfs_manager/actions?query=workflow%3A%22nfs_manager+docker+checker%22)

### Usage

```
# Create symlink for shell tool
ln -s /root/scripts/nfs_manager/ver.x.y/bin/nfs_manager.sh /root/bin/nfs_manager

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating NFS Server
nfs_manager

nfs_manager ver.2.0
Sun 28 Nov 2021 06:24:16 PM CET

[check_root] Check permission for current session? [ok]
[check_root] Done

	                                                             
	        __                                                   
	 _ __  / _|___   _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ 
	| '_ \| |_/ __| | '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
	| | | |  _\__ \ | | | | | | (_| | | | | (_| | (_| |  __/ |   
	|_| |_|_| |___/ |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|   
	                                             |___/           
	                                                             
		Info   github.io/nfs_manager ver.2.0 
		Issue  github.io/issue
		Author vroncevic.github.io

  [Usage] nfs_manager [OPTIONS]
  [OPTIONS]
  [OPTION] start | stop | restart | list | version
  # Restart Apache Tomcat Server
  nfs_manager restart
  [help | h] print this option
```

### Dependencies

**nfs_manager** requires next modules and libraries
* sh_util [https://github.com/vroncevic/sh_util](https://github.com/vroncevic/sh_util)

### Shell tool structure

**nfs_manager** is based on MOP.

Shell tool structure
```
sh_tool/
├── bin/
│   ├── center.sh
│   ├── display_logo.sh
│   ├── nfs_list.sh
│   ├── nfs_manager.sh
│   ├── nfs_operation.sh
│   └── nfs_version.sh
├── conf/
│   ├── nfs_manager.cfg
│   ├── nfs_manager.logo
│   └── nfs_manager_util.cfg
└── log/
    └── nfs_manager.log
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/nfs_manager/badge/?version=latest)](https://nfs_manager.readthedocs.io/projects/nfs_manager/en/latest/?badge=latest)

More documentation and info at
* [https://nfs_manager.readthedocs.io/en/latest/](https://nfs_manager.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 by [vroncevic.github.io/nfs_manager](https://vroncevic.github.io/nfs_manager)

**nfs_manager** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/nfs_manager/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)
