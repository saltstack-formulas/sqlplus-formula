{% set p  = salt['pillar.get']('sqlplus', {}) %}
{% set g  = salt['grains.get']('sqlplus', {}) %}

{%- set sqlplus_home         = salt['grains.get']('sqlplus_home', salt['pillar.get']('sqlplus_home', '/opt/sqlplus')) %}

{%- set release		     = g.get('release', p.get('release', '12' %}
{%- set minor		     = g.get('minor', p.get('minor', '2' %}
{%- set version		     = g.get('version', p.get('version', release + '.' + minor + '.0.1.0' )) %}
{%- set version_name	     = 'instantclient_' + release + '_' + minor %}
{%- set suffix		     = '-linux.x64-12.2.0.1.0.zip' %}
{%- set mirror		     = 'http://download.oracle.com/otn/linux/instantclient/' + release + minor + '010/' %}

{%- set default_prefix       = '/usr/share/oracle' %}
{%- set default_source_url1  = mirror + 'instantclient-basic' + suffix %}
{%- set default_source_url2  = mirror + 'instantclient-sqlplus' + suffix %}
{%- set default_source_url3  = mirror + 'instantclient-sdk' + suffix %}
{%- set default_source_hash1 = 'xxxxx' %}
{%- set default_source_hash2 = 'xxxxx' %}
{%- set default_source_hash3 = 'xxxxx' %}
{%- set default_archive_type = 'zip' %}

{%- set source_url1          = g.get('source_url1', p.get('source_url1', default_source_url1 )) %}

{%- if source_url1 == default_source_url1 %}
  {%- set source_url2        = default_source_url2 %}
  {%- set source_url3        = default_source_url3 %}
  {%- set source_hash1       = default_source_hash1 %}
  {%- set source_hash2       = default_source_hash2 %}
  {%- set source_hash3       = default_source_hash3 %}
{%- else %}
  {%- set source_url2	     = g.get('source_url2', p.get('source_url2', '')) %}
  {%- set source_url3	     = g.get('source_url3', p.get('source_url3', '')) %}
  {%- set source_hash1	     = g.get('source_hash1', p.get('source_hash1', '')) %}
  {%- set source_hash2	     = g.get('source_hash2', p.get('source_hash2', '')) %}
  {%- set source_hash3	     = g.get('source_hash3', p.get('source_hash3', '')) %}
{%- endif %}

{%- set default_dl_opts     = '-s --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"' %}
{%- set default_symlink	    = g.get('sqlplus_symlink', p.get('sqlplus_symlink', '/usr/bin/sqlplus' )) %}
{%- set default_realcmd	    = g.get('sqlplus_realcmd', p.get('sqlplus_realcmd', sqlplus_home + '/sqlplus')) %}

{%- set dl_opts		    = g.get('dl_opts', p.get('dl_opts', default_dl_opts)) %}
{%- set prefix		    = g.get('prefix', p.get('prefix', default_prefix )) %}
{%- set sqlplus_real_home   = prefix + version_name %}
{%- set sqlplus_symlink	    = g.get('sqlplus_symlink', p.get('sqlplus_symlink', default_symlink )) %}
{%- set sqlplus_realcmd	    = g.get('sqlplus_realcmd', p.get('sqlplus_realcmd', default_realcmd )) %}

{%- set archive_type	    = g.get('archive_type', p.get('archive_type', default_archive_type )) %}
{%- set unpack_opts	    = g.get('unpack_opts', p.get('unpack_opts', '' )) %}

{%- set sqlplus = {} %}
{%- do sqlplus.update( {  'release'		: release,
			  'minor'		: minor,
			  'version'		: version,
			  'source_url1'		: source_url1,
			  'source_url2'		: source_url2,
			  'source_url3'		: source_url3,
                          'source_hash1'	: source_hash1,
                          'source_hash2'	: source_hash2,
                          'source_hash3'	: source_hash3,
			  'sqlplus_home'        : sqlplus_home,
			  'dl_opts'		: dl_opts,
			  'unpack_opts'		: unpack_opts,
			  'archive_type'	: archive_type,
			  'prefix'		: prefix,
			  'sqlplus_real_home'	: sqlplus_real_home,
			  'sqlplus_symlink'	: sqlplus_symlink,
			  'sqlplus_realcmd'	: sqlplus_realcmd,
                     }) %}
