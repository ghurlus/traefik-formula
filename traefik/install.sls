{% from slspath + "/map.jinja" import traefik with context %}

{% set version = traefik.version %}
{% set user = traefik.user %}
{% set group = traefik.group %}
{% set bin_dir = traefik.bin_dir %}
{% set config_dir = traefik.config_dir %}
{% set osarch = salt.grains.get('osarch') %}
{% set os = salt.grains.get('kernel') | lower %}
{% set bin_full_name = 'traefik_' + os + '-' + osarch %}
{% set wget_pkg = traefik.wget_pkg %}
{% set wget_opts = traefik.wget_opts %}
{% if traefik.https_proxy is defined or traefik.http_proxy is defined %}
  {% set proxy_enabled = True %}
  {% set https_proxy = traefik.https_proxy %}
  {% set http_proxy = traefik.http_proxy %}
{% else%}
  {% set proxy_enabled = False %}
{% endif %}

# create traefik group
traefik_group:
  group.present:
    - name: {{ group }}
    - system: True

# create traefik user
traefik_user:
  user.present:
    - name: {{ user }}
    - groups:
      - {{ group }}
    - createhome: False
    - system: True
    - require:
      - group: traefik_group

# create config directory
traefik_config_dir:
  file.directory:
    - name: {{ config_dir }}
    - user: root
    - group: root
    - mode: 0755

# create bin directory
traefik_bin_dir:
  file.directory:
    - name: {{ bin_dir }}
    - makedirs: True
    - user: root
    - group: staff
    - mode: 2775
    - watch:
      - file: traefik_config_dir

# install wget
traefik_wget_pkg:
  pkg.installed:
    - name: {{ wget_pkg }}

# download traefik binary
traefik_download_binary:
  cmd.run:
    - name: wget {{ wget_opts }} --output-document={{ bin_dir }}/{{ bin_full_name }} https://github.com/containous/traefik/releases/download/v{{ version }}/{{ bin_full_name }}
    - unless: ls {{ bin_dir }}/{{ bin_full_name }}
    {% if proxy_enabled %}
    - env:
      {% if https_proxy != '' %}
      - https_proxy: {{ traefik.https_proxy }}
      {% endif %}
      {% if http_proxy != '' %}
      - http_proxy: {{ traefik.http_proxy }}
      {% endif %}
    {% endif %}
    - require:
      - file: traefik_bin_dir
      - pkg: traefik_wget_pkg

# rename downloaded traefik binary to "traefik"
traefik_bin_rename:
  file.rename:
    - name: {{ bin_dir }}/traefik
    - source: {{ bin_dir }}/{{ bin_full_name }}
    - watch:
      - cmd: traefik_download_binary

# make traefik binary executable
traefik_bin_make_exec:
  file.managed:
    - name: {{ bin_dir }}/traefik
    - mode: 755
    - watch:
      - file: traefik_bin_rename

# create log directory
traefik_var_log:
  file.directory:
    - name: /var/log/traefik
    - user: root
    - group: {{ group }}
    - mode: 0775
    - watch:
      - file: traefik_bin_rename

# create logrotate file
traefik_logrotate:
  file.managed:
    - name: /etc/logrotate.d/traefik
    - source: salt://{{ slspath }}/files/traefik.logrotate
    - template: jinja
    - context:
      mode: 0644
      owner: root
      group: {{ group }}
    - watch:
      - file: traefik_var_log
