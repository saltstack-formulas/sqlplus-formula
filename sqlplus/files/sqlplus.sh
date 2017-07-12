export ORACLE_HOME={{ prefix }}
export SQLPLUS_HOME={{ orahome }}/instantclient
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SQLPLUS_HOME}
export PATH=${ORACLE_HOME}:${SQLPLUS_HOME}:$PATH
