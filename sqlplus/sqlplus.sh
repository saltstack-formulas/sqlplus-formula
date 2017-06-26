{%- from 'sqlplus/settings.sls' import sqlplus with context %}
export SQLPLUS_HOME={{ sqlplus.sqlplus_home }}
export PATH=$SQLPLUS_HOME:$PATH
