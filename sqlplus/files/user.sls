
##TODO: THINK THIS IS NOT NEEDED (USING LD_LIBRARY_PATH INSTEAD)
##Remove this file if states below are not needed

sqlplus-oracle-conf:
  file.managed:
    - name: /etc/ld.so.conf.d/oracle.conf
    - mkdirs: True

sqlplus-ld-so-conf:
  file.append:
    - name: /etc/ld.so.conf.d/oracle.conf:
    - text: {{ sqlplus.sqlplus_real_home }}/client64/lib

sqlplus-ldconfig:
  cmd.run
    - name: ldconfig

