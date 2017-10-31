{% from "sqlplus/map.jinja" import sqlplus with context %}

{% if sqlplus.prefs.tnsnamesurl not in (None, 'undefined') %}

sqlplus-tnsnames-ora:
  cmd.run:
    - name: curl {{ sqlplus.dl.opts }} -o /etc/tnsnames.ora '{{ sqlplus.prefs.tnsnamesurl }}'
    - runas: root
    - if_missing: /etc/tnsnames.ora
    {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ sqlplus.dl.retries }}
        interval: {{ sqlplus.dl.interval }}
    {% endif %}

{%- endif %}

