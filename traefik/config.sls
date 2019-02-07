{% from slspath + "/map.jinja" import traefik with context %}

{% set bin_dir = traefik.bin_dir %}
{% set config_dir = traefik.config_dir %}
{% set config_file = traefik.config_file %}
{% set user = traefik.user %}
{% set group = traefik.group %}

traefik_config:
  file.managed:
    - name: {{ config_dir }}/{{ config_file }}
    - source: salt://{{ slspath }}/files/{{ config_file }}
    - skip_verify: True
    - user: {{ user }}
    - group: {{ group }}
    - mode: 0644
