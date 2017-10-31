{% from "sqlplus/map.jinja" import sqlplus with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add swhome to alternatives system
sqlplus-home-alt-install:
  alternatives.install:
    - name: sqlplus-home
    - link: {{ sqlplus.symhome }}
    - path: {{ sqlplus.alt.realhome }}
    - priority: {{ sqlplus.alt.priority }}

sqlplus-home-alt-set:
  alternatives.set:
    - name: sqlplus-home
    - path: {{ sqlplus.alt.realhome }}
    - onchanges:
      - alternatives: sqlplus-home-alt-install

# Add to alternatives system
sqlplus-alt-install:
  alternatives.install:
    - name: sqlplus
    - link: {{ sqlplus.symlink }}
    - path: {{ sqlplus.alt.realcmd }}
    - priority: {{ sqlplus.alt.priority }}
    - require:
      - alternatives: sqlplus-home-alt-install
      - alternatives: sqlplus-home-alt-set

sqlplus-alt-set:
  alternatives.set:
    - name: sqlplus
    - path: {{ sqlplus.alt.realcmd }}
    - onchanges:
      - alternatives: sqlplus-alt-install

  {% endif %}

{% endif %}

