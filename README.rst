=============
sqlplus-formula
=============

This formula will set up and configure Oracle SqlPlus client sourced from URL.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``sqlplus``
---------

Downloads zip archives from **sqlplus:source_url** and unpacks them.

- instantclient-basic-linux.x64
- instantclient-sdk-linux.x64
- instantclient-devel-linux.x64

The formula also configures an alternatives path. The default vendor source URL requires credentials as download arguments.

- The current default is **sqlplus:version** of 12.2 

``sqlplus.env``
-------------

Adds /etc/profile.d/sqlplus.sh, this includesd SQLPLUS__HOME in the PATH of any user.

Please see the pillar.example for configuration.

