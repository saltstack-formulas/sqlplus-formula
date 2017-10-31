{% from "sqlplus/map.jinja" import sqlplus with context %}

#runtime dependency
sqlplus-libaio1:
  pkg.installed:
    {% if grains.os in ('Ubuntu', 'Suse', 'SUSE') %}
    - name: libaio1
    {%- else %}
    - name: libaio
    {%- endif %}

sqlplus-create-extract-dirs:
  file.directory:
    - names:
      - '{{ sqlplus.tmpdir }}'
      - '{{ sqlplus.oracle.realhome }}/{{ sqlplus.oracle.release }}_tmp'
  {% if grains.os not in ('MacOS', 'Windows') %}
    - user: root
    - group: root
    - mode: 755
  {% endif %}
    - clean: True
    - makedirs: True

{% for pkg in sqlplus.dl.pkgs %}

  {% set src_url  = sw.dl.uri ~ pkg ~ '-' ~ sw.arch ~ '-' ~ sw.oracle.version ~ '.' ~ sw.dl.suffix %}
  {% set src_hash = salt['cmd.run']('curl -s {0}.sha256'.format( src_url )).split(' ')[0] %}

sqlplus-extract-{{ pkg }}:
  cmd.run:
    - name: curl {{sqlplus.dl.opts}} -o {{sqlplus.tmpdir}}/{{ pkg }}.{{sqlplus.dl.suffix}}' {{ src_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ sqlplus.dl.retries }}
        interval: {{ sqlplus.dl.interval }}
      {% endif %}
    - require:
      - sqlplus-create-extract-dirs
  module.run:
    - name: file.check_hash
    - path: '{{ sqlplus.tmpdir }}/{{ pkg }}.{{ sqlplus.dl.suffix }}'
    - file_hash: {{ src_hash }}
    - onchanges:
      - cmd: sqlplus-extract-{{ pkg }}
    - require_in:
      - archive: sqlplus-extract-{{ pkg }}
  archive.extracted:
    - source: 'file://{{ sqlplus.tmpdir }}/{{ pkg }}.{{ sqlplus.dl.suffix }}'
    - name: '{{ sqlplus.oracle.realhome }}/{{ sqlplus.oracle.release }}_tmp'
    - archive_format: {{ sqlplus.dl.suffix }}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
 
sqlplus-install-{{ pkg }}:
  cmd.run:
    - name: mv '{{ sqlplus.oracle.realhome }}/{{ sqlplus.oracle.release }}_tmp/*' {{ sqlplus.oracle.realhome }}
    - onchanges:
      - archive: sqlplus-extract-{{ pkg }}
    - require_in:
      - file: sqlplus-remove-extract-dirs

{% endfor %}

sqlplus-remove-extract-dirs:
  file.absent:
    - names:
      - '{{ sqlplus.tmpdir }}'
      - '{{ sqlplus.oracle.realhome }}/{{ sqlplus.oracle.release }}_tmp'

{% if grains.os == 'Linux' %}

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
      sqlplus_home: '{{ sqlplus.oracle.symhome }}'
    - require:
      - file: sqlplus-remove-extract-dirs

sqlplus-update-home-symlink:
  file.symlink:
    - name: '{{ sqlplus.oracle.symhome }}'
    - target: '{{ sqlplus.oracle.realhome }}'
    - force: True
    - require:
      - file: sqlplus-linux-profile

  {% if sqlplus.prefs.ldconfig == 'yes' %}
sqlplus-create-oracle-conf:
  file.managed:
    - name: /etc/ld.so.conf.d/oracle.conf
    - mkdirs: True
    - require:
      - file: sqlplus-update-home-symlink

sqlplus-ld-so-conf:
  file.append:
    - name: /etc/ld.so.conf.d/oracle.conf:
    - text: {{ sqlplus.alt.realhome }}/client64/lib
    - require:
      - file: sqlplus-create-oracle-conf

sqlplus-ldconfig:
  cmd.run
    - name: ldconfig
    - require:
      - file: sqlplus-ld-so-conf

  {% endif %}

{% endif %}

