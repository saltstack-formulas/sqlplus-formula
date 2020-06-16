# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}

sqlplus-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ sqlplus.path }}
      - /usr/local/bin/sqlplus
