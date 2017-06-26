{%- from 'sqlplus/settings.sls' import sqlplus with context %}

sqlplus-config:
  file.managed:
    - name: /etc/profile.d/sqlplus.sh
    - source: salt://sqlplus/sqlplus.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      sqlplus_home: {{ sqlplus.sqlplus_home }}

# Add sqlplus to alternatives system
sqlplushome-alt-install:
  alternatives.install:
    - name: sqlplus-home
    - link: {{ sqlplus.sqlplus_home }}
    - path: {{ sqlplus.sqlplus_real_home }}
    - priority: 30
    - require:
      - update-sqlplus-home-symlink

sqlplus-alt-install:
  alternatives.install:
    - name: sqlplus
    - link: {{ sqlplus.sqlplus_symlink }}
    - path: {{ sqlplus.sqlplus_realcmd }}
    - priority: 30
    - onlyif: test -d {{ sqlplus.sqlplus_real_home }} && test ! -L {{ sqlplus.sqlplus_home }}
    - require:
      - update-sqlplus-home-symlink

# Set sqlplus alternatives
sqlplushome-alt-set:
  alternatives.set:
  - name: sqlplus-home
  - path: {{ sqlplus.sqlplus_real_home }}
  - onchanges:
    - sqlplushome-alt-install

sqlplus-alt-set:
  alternatives.set:
  - name: sqlplus
  - path: {{ sqlplus.sqlplus_realcmd }}
  - onchanges:
    - sqlplus-alt-install

# source PATH with JAVA_HOME
source_sqlplus_file:
  cmd.run:
  - name: source /etc/profile
  - cwd: /root
  - require:
    - update-sqlplus-home-symlink

create our /etc/tnsnames.ora:
  file.managed:
    - name: /etc/tnsnames.ora
    - source: salt://sqlplus/tnsnames.ora
    - mode: 644
    - user: root
    - group: root

