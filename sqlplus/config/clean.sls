# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}

include:
  - {{ tplroot ~ '.archive.clean' }}

sqlplus-config-clean-file-absent:
  file.absent:
    - names:
      - {{ sqlplus.tnsnames_file }}
               {%- if sqlplus.environ_file %}
      - {{ sqlplus.environ_file }}
               {%- endif %}
               {%- if grains.kernel|lower == 'linux' %}
      - {{ sqlplus.linux.desktop_file }}
               {%- endif %}
    - require:
      - sls: {{ tplroot ~ '.archive.clean' }}
