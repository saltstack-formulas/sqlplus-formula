{% from "sqlplus/map.jinja" import sqlplus with context %}

{% if grains.os not in ('MacOS', 'Windows',) %}

#runtime dependency
sqlplus-libaio1:
  pkg.installed:
    {% if grains.os in ('Ubuntu', 'Suse', 'SUSE',) %}
    - name: libaio1
    {%- else %}
    - name: libaio
    {%- endif %}

# Update system profile with PATH
sqlplus-linux-profile:
  file.managed:
    - name: /etc/profile.d/sqlplus.sh
    - source: salt://sqlplus/files/sqlplus.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      home: '{{ sqlplus.oracle.home }}'
    - require:
      - pkg: sqlplus-libaio1

sqlplus-update-home-symlink:
  file.symlink:
    - name: '{{ sqlplus.oracle.home }}/instantclient'
    - target: '{{ sqlplus.oracle.realhome }}'
    - force: True
    - require:
      - file: sqlplus-linux-profile

  {% if sqlplus.linux.ldconfig == 'yes' %}

sqlplus-create-oracle-conf:
  file.managed:
    - name: /etc/ld.so.conf.d/oracle.conf
    - mkdirs: True
    - require:
      - file: sqlplus-update-home-symlink
    - onlyif: test -f {{ sqlplus.oracle.realcmd }}

sqlplus-ld-so-conf:
  file.append:
    - name: /etc/ld.so.conf.d/oracle.conf:
    - text: {{ sqlplus.oracle.realhome }}/client64/lib
    - require:
      - file: sqlplus-create-oracle-conf

sqlplus-ldconfig:
  cmd.run
    - name: ldconfig
    - require:
      - file: sqlplus-ld-so-conf

  {% endif %}

  ## Debian Alternatives ##
  {% if sqlplus.linux.altpriority > 0 %}
     {% if grains.os_family not in ('Arch',) %}

# Add swhome to alternatives system
sqlplus-home-alt-install:
  file.directory:
    - name: {{ sqlplus.oracle.home }}
    - makedirs: True
  alternatives.install:
    - name: sqlplus-home
    - link: {{ sqlplus.oracle.home }}/instantclient
    - path: {{ sqlplus.oracle.realhome }}
    - priority: {{ sqlplus.linux.altpriority }}
    - require:
      - file: sqlplus-home-alt-install

sqlplus-home-alt-set:
  alternatives.set:
    - name: sqlplus-home
    - path: {{ sqlplus.oracle.realhome }}
    - onchanges:
      - alternatives: sqlplus-home-alt-install

# Add to alternatives system
sqlplus-alt-install:
  alternatives.install:
    - name: sqlplus
    - link: {{ sqlplus.linux.symlink }}
    - path: {{ sqlplus.oracle.realcmd }}
    - priority: {{ sqlplus.linux.altpriority }}
    - require:
      - alternatives: sqlplus-home-alt-install
      - alternatives: sqlplus-home-alt-set

sqlplus-alt-set:
  alternatives.set:
    - name: sqlplus
    - path: {{ sqlplus.oracle.realcmd }}
    - onchanges:
      - alternatives: sqlplus-alt-install

     {% endif %}
  {% endif %}

{% endif %}

