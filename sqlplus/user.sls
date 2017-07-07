
#### TODO: IS THIS NEEDED OR NOT?

sqlplus-libaio1:
  pkg.installed
    - name: libaio1

sqlplus-tnsnames-ora:
  file.managed:
    - name: /etc/tnsnames.ora:
    - source: salt://sqlplus/tnsnames.ora

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

