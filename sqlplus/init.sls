{%- from 'sqlplus/settings.sls' import sqlplus with context %}

{#- require a source_url - there is no default download location for sqlplus #}

{%- if sqlplus.source_url is defined %}

  {%- set archive_file1 = sqlplus.prefix + '/' + sqlplus.source_url1.split('/') | last %}
  {%- set archive_file2 = sqlplus.prefix + '/' + sqlplus.source_url2.split('/') | last %}
  {%- set archive_file3 = sqlplus.prefix + '/' + sqlplus.source_url3.split('/') | last %}

sqlplus-libaio1:
  pkg.installed
    - name: libaio1

sqlplus-install-dir:
  file.directory:
    - name: {{ sqlplus.prefix }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

sqlplus-download-instantclient-basic-archive:
  cmd.run:
    - name: curl {{ sqlplus.dl_opts }} -o '{{ archive_file1 }}' '{{ sqlplus.source_url1 }}'
    - unless: test -d {{ sqlplus.sqlplus_real_home }} || test -f {{ archive_file1 }}
    - require:
      - file: sqlplus-install-dir

sqlplus-download-instantclient-sqlplus-archive:
  cmd.run:
    - name: curl {{ sqlplus.dl_opts }} -o '{{ archive_file2 }}' '{{ sqlplus.source_url2 }}'
    - unless: test -d {{ sqlplus.sqlplus_real_home }} || test -f {{ archive_file2 }}
    - require:
      - file: sqlplus-install-dir

sqlplus-download-instantclient-devel-archive:
  cmd.run:
    - name: curl {{ sqlplus.dl_opts }} -o '{{ archive_file3 }}' '{{ sqlplus.source_url3 }}'
    - unless: test -d {{ sqlplus.sqlplus_real_home }} || test -f {{ archive_file3 }}
    - require:
      - file: sqlplus-install-dir

sqlplus-unpack-instantclient-basic-archive:
  archive.extracted:
    - name: {{ sqlplus.prefix }}
    - source: file://{{ archive_file1 }}
    {%- if sqlplus.source_hash1 %}
    - source_hash: sha256={{ sqlplus.source_hash1 }}
    {%- endif %}
    - archive_format: {{ sqlplus.archive_type }}
    - options: {{ sqlplus.unpack_opts }}
    - user: root
    - group: root
    - if_missing: {{ sqlplus.sqlplus_real_home }}
    - require:
      - cmd: sqlplus-download-instantclient-basic-archive

sqlplus-unpack-instantclient-sqlplus-archive:
  archive.extracted:
    - name: {{ sqlplus.prefix }}
    - source: file://{{ archive_file2 }}
    {%- if sqlplus.source_hash2 %}
    - source_hash: sha256={{ sqlplus.source_hash2 }}
    {%- endif %}
    - archive_format: {{ sqlplus.archive_format }}
    - options: {{ sqlplus.unpack_opts }}
    - user: root
    - group: root
    - if_missing: {{ sqlplus.sqlplus_real_home }}
    - onchanges:
      - cmd: download-instantclient-sqlplus-archive

sqlplus-unpack-instantclient-devel-archive:
  archive.extracted:
    - name: {{ sqlplus.prefix }}
    - source: file://{{ archive_file3 }}
    {%- if sqlplus.source_hash3 %}
    - source_hash: sha256={{ sqlplus.source_hash3 }}
    {%- endif %}
    - archive_format: {{ sqlplus.archive_format }}
    - options: {{ sqlplus.unpack_opts }}
    - user: root
    - group: root
    - if_missing: {{ sqlplus.sqlplus_real_home }}
    - onchanges:
      - cmd: download-instantclient-devel-archive

sqlplus-update-home-symlink:
  file.symlink:
    - name: {{ sqlplus.sqlplus_home }}
    - target: {{ sqlplus.sqlplus_real_home }}
    - force: True
    - require:
      - sqlplus-unpack-instantclient-basic-archive
      - sqlplus-unpack-instantclient-sqlplus-archive
      - sqlplus-unpack-instantclient-devel-archive

sqlplus-remove-instantclient-basic-archive:
  file.absent:
    - name: {{ archive_file1 }}

sqlplus-remove-instantclient-sqlplus-archive:
  file.absent:
    - name: {{ archive_file2 }}

sqlplus-remove-instantclient-devel-archive:
  file.absent:
    - name: {{ archive_file3 }}

include:
  - sqlplus.env


{%- endif %}
