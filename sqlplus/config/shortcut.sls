# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower == 'linux' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ tplroot ~ '.archive.install' }}

sqlplus-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ sqlplus.linux.desktop_file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='sqlplus-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ sqlplus.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
        appname: {{ sqlplus.pkg.name }}
        edition: {{ sqlplus.edition|json }}
        command: {{ sqlplus.command|json }}
        path: {{ sqlplus.path }}
    - onlyif: test -f {{ sqlplus.path }}/{{ sqlplus.command }}
    - require:
      - sls: {{ tplroot ~ '.archive.install' }}

    {%- endif %}
