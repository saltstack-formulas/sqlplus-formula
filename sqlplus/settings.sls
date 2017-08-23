{% set p  = salt['pillar.get']('sqlplus', {}) %}
{% set g  = salt['grains.get']('sqlplus', {}) %}

{%- set orarelease   = salt['pillar.get']('oracle_release', '12_2') %}
{%- set orahome      = salt['pillar.get']('oracle_home', '/opt/oracle/' + orarelease + '/')) %}

{%- set release      = g.get('release', p.get('release', '12')) %}
{%- set major        = g.get('major', p.get('major', '2')) %}
{%- set minor        = g.get('minor', p.get('minor', '0')) %}
{%- set version      = g.get('version', p.get('version', release + '.' + major + '.' + minor + '.1.0' )) %}
{%- set name         = 'instantclient' %}

{########## YOU MUST CHANGE THIS URL TO YOUR LOCAL MIRROR ####### #}
{%- set mirror  = 'http://download.oracle.com/otn/linux/instantclient/' + release + major + minor + '10/' %}

{%- set default_ldconfig     = 'no' %}
{%- set default_tnsnames_url = 'undefined' %}
{%- set default_archive_type = 'zip' %}
{%- set suffix               = '-linux.x64' + '-' + version + '.' + default_archive_type %}
{%- set default_prefix       = '/usr/share/oracle/' + orarelease + '/' %}
{%- set default_source_url1  = mirror + 'instantclient-basic' + suffix %}
{%- set default_source_url2  = mirror + 'instantclient-sqlplus' + suffix %}
{%- set default_source_url3  = mirror + 'instantclient-sdk' + suffix %}

  ##### Hashes for version 12.2 lixux binary zipfile #####
{%- set default_source_hash1 = 'md5=d9639092e3dea2e023272e52e2bd42da' %}
{%- set default_source_hash2 = 'md5=93ae87df1d08bb31da57443a416edc8c' %}
{%- set default_source_hash3 = 'md5=077fa2f215185377ccb670de9ca1678f' %}

{%- set source_url1          = g.get('source_url1', p.get('source_url1', default_source_url1 )) %}
{%- if source_url1 == default_source_url1 %}
  {%- set source_url2        = default_source_url2 %}
  {%- set source_url3        = default_source_url3 %}
  {%- set source_hash1       = default_source_hash1 %}
  {%- set source_hash2       = default_source_hash2 %}
  {%- set source_hash3       = default_source_hash3 %}
{%- else %}
  {%- set source_url2        = g.get('source_url2', p.get('source_url2', default_source_url2 )) %}
  {%- set source_url3        = g.get('source_url3', p.get('source_url3', default_source_url3 )) %}
  {%- set source_hash1       = g.get('source_hash1', p.get('source_hash1', default_source_hash1 )) %}
  {%- set source_hash2       = g.get('source_hash2', p.get('source_hash2', default_source_hash2 )) %}
  {%- set source_hash3       = g.get('source_hash3', p.get('source_hash3', default_source_hash3 )) %}
{%- endif %}

{%- set default_alt_priority = '30' %}
{%- set default_dl_opts      = ' -s ' %}
{%- set default_symlink      = '/usr/bin/sqlplus' %}
{%- set default_real_home    = default_prefix + name + '/' %}
{%- set default_realcmd      = default_real_home + '/sqlplus' %}

{%- set ldconfig             = g.get('ldconfig', p.get('ldconfig', default_ldconfig )) %}
{%- set tnsnames_url         = g.get('tnsnames_url', p.get('tnsnames_url', default_tnsnames_url )) %}
{%- set prefix               = g.get('prefix', p.get('prefix', default_prefix )) %}
{%- set dl_opts              = g.get('dl_opts', p.get('dl_opts', default_dl_opts)) %}
{%- set archive_type         = g.get('archive_type', p.get('archive_type', default_archive_type )) %}
{%- set symlink              = g.get('symlink', p.get('symlink', default_symlink )) %}
{%- set real_home            = g.get('real_home', p.get('real_home', default_real_home )) %}
{%- set unpackdir            = g.get('unpackdir', p.get('unpackdir', prefix + name + '_' + orarelease )) %}
{%- set realcmd              = g.get('realcmd', p.get('realcmd', default_realcmd )) %}
{%- set alt_priority         = g.get('alt_priority', p.get('alt_priority', default_alt_priority )) %}

{%- set sqlplus = {} %}
{%- do sqlplus.update( {  'orahome'          : orahome,
                          'source_url1'      : source_url1,
                          'source_url2'      : source_url2,
                          'source_url3'      : source_url3,
                          'source_hash1'     : source_hash1,
                          'source_hash2'     : source_hash2,
                          'source_hash3'     : source_hash3,
                          'ldconfig'         : ldconfig,
                          'tnsnames_url'     : tnsnames_url,
                          'prefix'           : prefix,
                          'dl_opts'          : dl_opts,
                          'archive_type'     : archive_type,
                          'real_home'        : real_home,
                          'symlink'          : symlink,
                          'realcmd'          : realcmd,
                          'unpackdir'        : unpackdir,
                          'alt_priority'     : alt_priority,
                     }) %}
