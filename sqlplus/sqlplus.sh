export ORACLE_HOME={{ prefix }}
export SQLPLUS_HOME={{ orahome }}/instantclient
export PATH=${ORACLE_HOME}:${SQLPLUS_HOME}:$PATH
