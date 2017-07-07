{%- from 'sqlplus/settings.sls' import sqlplus with context %}

export ORACLE_HOME={{ sqlplus.prefix }}
export SQLPLUS_HOME={{ sqlplus.orahome }}/instantclient
export PATH=${ORACLE_HOME}:${SQLPLUS_HOME}:$PATH
