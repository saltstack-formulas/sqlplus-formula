# -*- coding: utf-8 -*-
# vim: ft=yaml
---
sqlplus:
  release: '12_2'      # quotes
  version: 12.2.0.1.0
  environ:
    a: b
  identity:
    user: undefined_user
  linux:
    altpriority: 0

  pkg:
    use_upstream_archive: true
    name: Sqlplus
    deps:
      - curl
      - tar
      - gzip
    # in real world, this value cannot work (oracle login)
    uri: http://download.oracle.com/otn/linux/instantclient/122010/
    wanted:
      - basic
      - sdk
      - sqlplus
    checksums:
      basic: md5=d9639092e3dea2e023272e52e2bd42da
      sdk: md5=077fa2f215185377ccb670de9ca1678f
      sqlplus: md5=93ae87df1d08bb31da57443a416edc8c
      basiclite: md5=b024039f518975f5a5b6473130c74e43
      jdbc: md5=3e6cdc6686b44160a8a5e4af0cacf5fd
      odbc: md5=8d82fa4d6f96fae458c2af16e70a5985
      tools: md5=5e258c34f947c31f0cf0e6322da8fe2c

  prefs:
    tnsnames: {}
    tnsnamesurl: null
