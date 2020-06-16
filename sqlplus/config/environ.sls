# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if 'environ' in sqlplus and sqlplus.environ %}

include:
  - {{ tplroot ~ '.archive.install' }}

sqlplus-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ sqlplus.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='sqlplus-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ sqlplus.identity.rootuser }}
    - group: {{ sqlplus.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        path: {{ sqlplus.path }}
        environ: {{ sqlplus.environ|json }}
    - require:
      - sls: {{ tplroot ~ '.archive.install' }}

    {%- endif %}
