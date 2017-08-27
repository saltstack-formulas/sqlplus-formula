{%- from 'sqlplus/settings.sls' import sqlplus with context %}

sqlplus-config:
  file.managed:
    - name: /etc/profile.d/sqlplus.sh
    - source: salt://sqlplus/files/sqlplus.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      orahome: {{ sqlplus.orahome }}/sqlplus
      prefix: {{ sqlplus.prefix }}

{% if sqlplus.user != 'undefined_user' and sqlplus.tnsnames_url != 'undefined' %}
sqlplus-tnsnames-ora:
  cmd.run:
    - name: curl {{ sqlplus.dl_opts }} -o /etc/tnsnames.ora '{{ sqlplus.tnsnames_url }}'
    - runas: {{ sqlplus.user}}
    - if_missing: /etc/tnsnames.ora
{%- endif %}

{%if sqlplus.ldconfig == 'yes' %}
sqlplus-oracle-conf:
  file.managed:
    - name: /etc/ld.so.conf.d/oracle.conf
    - mkdirs: True

sqlplus-ld-so-conf:
  file.append:
    - name: /etc/ld.so.conf.d/oracle.conf:
    - text: {{ sqlplus.real_home }}/client64/lib

sqlplus-ldconfig:
  cmd.run
    - name: ldconfig
{% endif %}

# Add sqlplus home to alternatives system
sqlplushome-alt-install:
  alternatives.install:
    - name: sqlplus-home
    - link: {{ sqlplus.orahome }}/sqlplus
    - path: {{ sqlplus.real_home }}
    - priority: {{ sqlplus.alt_priority }}

sqlplushome-alt-set:
  alternatives.set:
  - name: sqlplus-home
  - path: {{ sqlplus.real_home }}
  - onchanges:
    - alternatives: sqlplushome-alt-install

# Add sqlplus to alternatives system
sqlplus-alt-install:
  alternatives.install:
    - name: sqlplus
    - link: {{ sqlplus.symlink }}
    - path: {{ sqlplus.realcmd }}
    - priority: {{ sqlplus.alt_priority }}
    - onchanges:
      - alternatives: sqlplushome-alt-install
      - alternatives: sqlplushome-alt-set

sqlplus-alt-set:
  alternatives.set:
  - name: sqlplus
  - path: {{ sqlplus.realcmd }}
  - onchanges:
    - alternatives: sqlplus-alt-install

