# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}

    {%- if 'prefs' in sqlplus and sqlplus.prefs is mapping %}
           {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
           {%- set sls_archive_install = tplroot ~ '.archive.install' %}

include:
  - {{ sls_archive_install }}

sqlplus-config-file-managed-tnsnames_file:
           {%- if 'tnsnamesurl' in sqlplus.prefs and sqlplus.prefs.tnsnamesurl %}
  cmd.run:
    - name: curl -L -o '{{ sqlplus.tnsnames_file }}' '{{ sqlplus.prefs.tnsnamesurl }}'
    - runas: {{ sqlplus.identity.rootuser }}
    - if_missing: {{ sqlplus.tnsnames_file }}
    - onlyif: '{{ sqlplus.prefs.tnsnamesurl }}'
    - retry: {{ sqlplus.retry_option|json }}

            {%- elif 'tnsnames' in sqlplus.prefs and sqlplus.prefs.tnsnames %}

  file.managed:
    - name: {{ sqlplus.tnsnames_file }}
    - source: {{ files_switch(['tnsnames.ora.jinja'],
                              lookup='sqlplus-config-file-managed-tnsnames_file'
                 )
              }}
    - mode: 640
    - user: {{ sqlplus.identity.rootuser }}
    - group: {{ sqlplus.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        tnsnames: {{ sqlplus.prefs.tnsnames|json }}
    - require:
      - sls: {{ sls_archive.install }}

            {%- endif %}
    {%- endif %}
