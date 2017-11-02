========
sqlplus
========

Formula to download and configure the SQLPLUS software from Oracle.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    
Available states
================

.. contents::
    :local:

``sqlplus``
------------
Downloads the archives from uri specified as pillar, unpack locally, and installs on the Operating System.

.. note::

This formula installs the version of sqlplus defined as default. Can be overridden by version pillar.

``sqlplus.developer``
------------
Optionally download a 'tnsnames.ora' file from url/share and save into 'user' (pillar) home directory.


``sqlplus.linuxenv``
------------
On Linux, the PATH is set for all system users by adding software profile to /etc/profile.d/ directory. Full support for debian alternatives in supported Linux distributions (i.e. not Archlinux).

.. note::

The linux-alternatives 'priority' pillar value must be updated for each newly installed release/editions.


Please see the pillar.example for configuration.
Tested on Linux (Ubuntu, Fedora, Arch, and Suse), MacOS. Not verified on Windows OS.
