{% from "sqlplus/map.jinja" import sqlplus with context %}

sqlplus-create-extract-dirs:
  file.directory:
    - names:
      - '{{ sqlplus.tmpdir }}'
      - '{{ sqlplus.oracle.home }}'
  {% if grains.os not in ('MacOS', 'Windows') %}
      - '{{ sqlplus.oracle.realhome }}'
    - user: root
    - group: root
    - mode: 755
  {% endif %}
    - clean: True
    - makedirs: True

{% for pkg in sqlplus.oracle.pkgs %}

  {% set url = sqlplus.oracle.uri ~ 'instantclient-' ~ pkg ~ '-' ~ sqlplus.arch ~ '-' ~ sqlplus.oracle.version ~ '.' ~ sqlplus.dl.suffix %}

sqlplus-extract-{{ pkg }}:
  cmd.run:
    - name: curl {{sqlplus.dl.opts}} -o '{{sqlplus.tmpdir}}/{{ pkg }}.{{sqlplus.dl.suffix}}' {{ url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ sqlplus.dl.retries }}
        interval: {{ sqlplus.dl.interval }}
      {% endif %}
    - require:
      - sqlplus-create-extract-dirs
    - require_in:
      - archive: sqlplus-extract-{{ pkg }}
  {% if sqlplus.dl.skip_hashcheck not in ('True', True) %}
  module.run:
    - name: file.check_hash
    - path: '{{ sqlplus.tmpdir }}/{{ pkg }}.{{ sqlplus.dl.suffix }}'
    - file_hash: {{ sqlplus.oracle.md5[ pkg ] }}
    - onchanges:
      - cmd: sqlplus-extract-{{ pkg }}
    - require_in:
      - archive: sqlplus-extract-{{ pkg }}
  {% endif %}
  archive.extracted:
    - source: 'file://{{ sqlplus.tmpdir }}{{ pkg }}.{{ sqlplus.dl.suffix }}'
    - name: '{{ sqlplus.prefix }}'
    - archive_format: {{ sqlplus.dl.suffix }}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
    - require_in:
      - file: sqlplus-complete-instantclient
 
{% endfor %}

sqlplus-complete-instantclient:
  file.absent:
    - name: {{ sqlplus.oracle.realhome }}
  cmd.run:
    - name: mv '{{ sqlplus.prefix }}instantclient_12_2' '{{ sqlplus.oracle.realhome }}'
    - require:
      - file: sqlplus-complete-instantclient

