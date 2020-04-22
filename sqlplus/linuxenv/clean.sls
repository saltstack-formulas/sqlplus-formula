# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower == 'linux' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import sqlplus with context %}

          {%- if sqlplus.linux.ldconfig %}

sqlplus-linuxenv-home-file-absent:
  pkg.removed:
    - name: {{ sqlplus.pkg.libaio }}
  file.absent:
    - names:
      - /opt/sqlplus
      - /etc/ld.so.conf.d/oracle.conf
      - {{ sqlplus.path }}

          {%- endif %}
          {%- if sqlplus.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

sqlplus-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: sqlplushome
    - path: {{ sqlplus.path }}
    - onlyif: update-alternatives --get-selections |grep ^sqlplushome

sqlplus-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: sqlplus
    - path: {{ sqlplus.path }}/sqlplus
    - onlyif: update-alternatives --get-selections |grep ^sqlplus

          {%- else %}

sqlplus-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (sqlplus.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.

          {% endif %}
    {% endif %}
