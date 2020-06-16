# -*- coding: utf-8 -*-
# vim: ft=sls

    {% if grains.kernel|lower == 'linux' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}

          {% if sqlplus.linux.ldconfig %}

sqlplus-linuxenv-oracle-conf-file-managed:
  pkg.installed:
    - name: {{ sqlplus.pkg.libaio }}
  file.managed:
    - name: /etc/ld.so.conf.d/oracle.conf
    - mkdirs: True
    - require:
      - file: sqlplus-linuxenv-package-installed
    - onlyif: test -d {{ sqlplus.path }}

sqlplus-linuxenv-ld-so-conf-file:
  file.append:
    - name: /etc/ld.so.conf.d/oracle.conf
    - text: {{ sqlplus.path }}/client64/lib
    - require:
      - file: sqlplus-linuxenv-oracle-conf-file-managed
  cmd.run
    - name: ldconfig
    - require:
      - file: sqlplus-linuxenv-ld-so-conf-file

          {% endif %}
          {% if sqlplus.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

sqlplus-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: sqlplushome
    - link: /opt/sqlplus
    - path: {{ sqlplus.path }}
    - priority: {{ sqlplus.linux.altpriority }}
    - retry: {{ sqlplus.retry_option|json }}

sqlplus-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: sqlplushome
    - path: {{ sqlplus.path }}
    - onchanges:
      - alternatives: sqlplus-linuxenv-home-alternatives-install
    - retry: {{ sqlplus.retry_option|json }}

sqlplus-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: sqlplus
    - link: {{ sqlplus.linux.symlink }}
    - path: {{ sqlplus.path }}/{{ sqlplus.command }}
    - priority: {{ sqlplus.linux.altpriority }}
    - require:
      - alternatives: sqlplus-linuxenv-home-alternatives-install
      - alternatives: sqlplus-linuxenv-home-alternatives-set
    - retry: {{ sqlplus.retry_option|json }}

sqlplus-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: sqlplus
    - path: {{ sqlplus.path }}/{{ sqlplus.command }}
    - onchanges:
      - alternatives: sqlplus-linuxenv-executable-alternatives-install
    - retry: {{ sqlplus.retry_option|json }}

          {%- else %}

sqlplus-linuxenv-alternatives-install-unapplicable:
  file.symlink:
    - name: /opt/sqlplus
    - target: {{ sqlplus.path }}
    - onlyif: test -d {{ sqlplus.path }}
    - force: True
  test.show_notification:
    - text: |
        Linux alternatives are turned off (sqlplus.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.

          {% endif %}
    {% endif %}
