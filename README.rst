=============
sqlplus-formula
=============

This formula will set up and configure Oracle SqlPlus client sourced from URL.

.. note1::

   The SOURCE URI in settings.sls must be updated with your internal mirror.

.. note2::

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

``sqlplus.env``
-------------

Full support for linux alternatives system. Add /etc/profile.d/sqlplus.sh to include SQLPLUS_HOME,
LD_LIBRARY_PATH, and SQLPLUS_HOME/bin. Create a tnsnames.ora file.

Please see the pillar.example for configuration.

