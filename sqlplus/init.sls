{%- from 'sqlplus/settings.sls' import sqlplus with context %}

{#- require a source_url - there is no default download location for sqlplus #}

{%- if sqlplus.source_url1 is defined %}

  {%- set archive_file1 = sqlplus.prefix + '/' + sqlplus.source_url1.split('/') | last %}
  {%- set archive_file2 = sqlplus.prefix + '/' + sqlplus.source_url2.split('/') | last %}
  {%- set archive_file3 = sqlplus.prefix + '/' + sqlplus.source_url3.split('/') | last %}

#runtime dependency
sqlplus-libaio1:
  pkg.installed:
    {%- if salt['grains.get']('os') == 'Ubuntu' or salt['grains.get']('os') == 'SUSE' %}
    - name: libaio1
    {%- else %}
    - name: libaio
    {%- endif %}

sqlplus-install-dir:
  file.directory:
    - names:
      - {{ sqlplus.prefix }}
      - {{ sqlplus.orahome }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

sqlplus-download-instantclient-basic-archive:
  cmd.run:
    - name: curl {{ sqlplus.dl_opts }} -o '{{ archive_file1 }}' '{{ sqlplus.source_url1 }}'
    - require:
      - file: sqlplus-install-dir
  {% if grains['saltversioninfo'] <= [2016, 11, 6] and sqlplus.source_hash1 %}
    # See: https://github.com/saltstack/salt/pull/41914 ensure hashchk in older salt.
  module.run:
    - name: file.check_hash
    - path: {{ archive_file1 }}
    - file_hash: {{ sqlplus.source_hash1 }}
    - onchanges:
      - cmd: sqlplus-download-instantclient-basic-archive
    - require_in:
      - archive: sqlplus-unpack-instantclient-basic-archive
  {%- endif %}

sqlplus-download-instantclient-sqlplus-archive:
  cmd.run:
    - name: curl {{ sqlplus.dl_opts }} -o '{{ archive_file2 }}' '{{ sqlplus.source_url2 }}'
    - require:
      - file: sqlplus-install-dir
 {% if grains['saltversioninfo'] <= [2016, 11, 6] and sqlplus.source_hash2 %}
    # See: https://github.com/saltstack/salt/pull/41914 ensure hashchk in older salt.
  module.run:
    - name: file.check_hash
    - path: {{ archive_file2 }}
    - file_hash: {{ sqlplus.source_hash2 }}
    - onchanges:
      - cmd: sqlplus-download-instantclient-sqlplus-archive
    - require_in:
      - archive: sqlplus-unpack-instantclient-sqlplus-archive
 {%- endif %}

sqlplus-download-instantclient-devel-archive:
  cmd.run:
    - name: curl {{ sqlplus.dl_opts }} -o '{{ archive_file3 }}' '{{ sqlplus.source_url3 }}'
    - require:
      - file: sqlplus-install-dir
 {% if grains['saltversioninfo'] <= [2016, 11, 6] and sqlplus.source_hash3 %}
    # See: https://github.com/saltstack/salt/pull/41914 ensure hashchk in older salt.
  module.run:
    - name: file.check_hash
    - path: {{ archive_file3 }}
    - file_hash: {{ sqlplus.source_hash3 }}
    - onchanges:
      - cmd: sqlplus-download-instantclient-devel-archive
    - require_in:
      - archive: sqlplus-unpack-instantclient-devel-archive
 {%- endif %}

sqlplus-unpack-instantclient-basic-archive:
  file.absent:
    - name: {{ sqlplus.sqlplus_real_home }}
  archive.extracted:
    - name: {{ sqlplus.prefix }}
    - source: file://{{ archive_file1 }}
    {%- if sqlplus.source_hash1 and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ sqlplus.source_hash1 }}
    {%- endif %}
    {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - if_missing: {{ sqlplus.sqlplus_realcmd }}
    {% endif %}
    - archive_format: {{ sqlplus.archive_type }}
    - require:
      - file: sqlplus-unpack-instantclient-basic-archive
    - onchanges:
      - cmd: sqlplus-download-instantclient-basic-archive

sqlplus-unpack-instantclient-sqlplus-archive:
  archive.extracted:
    - name: {{ sqlplus.prefix }}
    - source: file://{{ archive_file2 }}
    {%- if sqlplus.source_hash2 and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ sqlplus.source_hash2 }}
    {%- endif %}
    {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - if_missing: {{ sqlplus.sqlplus_realcmd }}
    {% endif %}
    - archive_format: {{ sqlplus.archive_type }}
    - onchanges:
      - cmd: sqlplus-download-instantclient-sqlplus-archive

sqlplus-unpack-instantclient-devel-archive:
  archive.extracted:
    - name: {{ sqlplus.prefix }}
    - source: file://{{ archive_file3 }}
    {%- if sqlplus.source_hash3 and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ sqlplus.source_hash3 }}
    {%- endif %}
    {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - if_missing: {{ sqlplus.sqlplus_realcmd }}
    {% endif %}
    - archive_format: {{ sqlplus.archive_type }}
    - onchanges:
      - cmd: sqlplus-download-instantclient-devel-archive

sqlplus-update-home-symlink:
  cmd.run:
    - name: mv {{ sqlplus.sqlplus_unpackdir }} {{ sqlplus.sqlplus_real_home }}
    - onchanges:
      - archive: sqlplus-unpack-instantclient-basic-archive
      - archive: sqlplus-unpack-instantclient-sqlplus-archive
      - archive: sqlplus-unpack-instantclient-devel-archive
  file.symlink:
    - name: {{ sqlplus.orahome }}/sqlplus
    - target: {{ sqlplus.sqlplus_real_home }}
    - force: True
    - require:
      - cmd: sqlplus-update-home-symlink

sqlplus-remove-instantclient-archives:
  file.absent:
    - names:
      - {{ archive_file1 }}
      - {{ archive_file2 }}
      - {{ archive_file3 }}
    - onchanges:
      - archive: sqlplus-unpack-instantclient-basic-archive
      - archive: sqlplus-unpack-instantclient-sqlplus-archive
      - archive: sqlplus-unpack-instantclient-devel-archive

{%- endif %}
