# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}

sqlplus-package-archive-install-prepare:
  pkg.installed:
    - names: {{ sqlplus.pkg.deps|json }}
  file.directory:
    - name: {{ sqlplus.pkg.archive.name }}
    - user: {{ sqlplus.identity.rootuser }}
    - group: {{ sqlplus.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - recurse:
        - user
        - group
        - mode

    {%- for name in sqlplus.pkg.wanted %}

sqlplus-package-archive-install-{{ name }}:
  archive.extracted:
    - name: {{ sqlplus.pkg.archive.name }}
    - source: {{ sqlplus.pkg.urls[name] }}
    - source_hash: {{ sqlplus.pkg.checksums[name] }}
    - retry: {{ sqlplus.retry_option|json }}
    - user: {{ sqlplus.identity.rootuser }}
    - group: {{ sqlplus.identity.rootgroup }}
    - require:
      - pkg: sqlplus-package-archive-install-prepare
      - file: sqlplus-package-archive-install-prepare

    {%- endfor %}
    {%- if sqlplus.linux.altpriority|int == 0 or grains.os_family not in ('Arch', 'Windows')  %}

sqlplus-archive-install-file-symlink-sqlplus:
  file.symlink:
    - name: /usr/local/bin/sqlplus
    - target: {{ sqlplus.path }}/{{ sqlplus.command }}
    - force: True
    - onlyif: test -f {{ sqlplus.path }}/{{ sqlplus.command }}

    {%- endif %}
