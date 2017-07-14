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

# Add sqlplus home to alternatives system
sqlplushome-alt-install:
  alternatives.install:
    - name: sqlplus-home
    - link: {{ sqlplus.orahome }}/sqlplus
    - path: {{ sqlplus.sqlplus_real_home }}
    - priority: {{ sqlplus.alt_priority }}

sqlplushome-alt-set:
  alternatives.set:
  - name: sqlplus-home
  - path: {{ sqlplus.sqlplus_real_home }}
  - require:
    - sqlplushome-alt-install

# Add sqlplus to alternatives system
sqlplus-alt-install:
  alternatives.install:
    - name: sqlplus
    - link: {{ sqlplus.sqlplus_symlink }}
    - path: {{ sqlplus.sqlplus_realcmd }}
    - priority: {{ sqlplus.alt_priority }}
    - require:
      - sqlplushome-alt-set

sqlplus-alt-set:
  alternatives.set:
  - name: sqlplus
  - path: {{ sqlplus.sqlplus_realcmd }}
  - require:
    - sqlplus-alt-install

create /etc/tnsnames.ora:
  file.managed:
    - name: /etc/tnsnames.ora
    - backup: 'saltbak'
    - source: salt://sqlplus/files/tnsnames.ora
    - mode: 644
    - user: root
    - group: root
    - require:
      - sqlplus-alt-set

