# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower in ('linux', 'darwin',) %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}

include:
  - .archive.clean
  - .config.clean
  - .linuxenv.clean

    {%- else %}

sqlplus-not-available-to-install:
  test.show_notification:
    - text: |
        The sqlplus package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
