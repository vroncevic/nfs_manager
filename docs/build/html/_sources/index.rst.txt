nfs_manager
------------

.. toctree::
 :hidden:

 self


nfs_manager is shell tool for controlling/operating NFS Server.

Developed in bash code: 100%.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/nfs_manager.svg
   :target: https://github.com/vroncevic/nfs_manager/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/nfs_manager.svg
   :target: https://github.com/vroncevic/nfs_manager/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/nfs_manager/badge/?version=latest
   :target: https://nfs_manager.readthedocs.io/projects/nfs_manager/en/latest/?badge=latest

INSTALLATION
-------------
Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/nfs_manager/releases

To install this set of modules type the following:

.. code-block:: bash

   tar xvzf nfs_manager-x.y.z.tar.gz
   cd nfs_manager-x.y.z
   cp -R ~/sh_tool/bin/   /root/scripts/nfs_manager/ver.1.0/
   cp -R ~/sh_tool/conf/  /root/scripts/nfs_manager/ver.1.0/
   cp -R ~/sh_tool/log/   /root/scripts/nfs_manager/ver.1.0/

DEPENDENCIES
-------------
This tool requires these other modules and libraries:

.. code-block:: bash

   sh_util https://github.com/vroncevic/sh_util

SHELL TOOL STRUCTURE
---------------------
nfs_manager is based on MOP.

Shell tool structure:

.. code-block:: bash

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

COPYRIGHT AND LICENCE
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2018 by https://vroncevic.github.io/nfs_manager

This tool is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

