{% from slspath + '/map.jinja' import traefik with context %}

{% if salt.grains.get('init') == 'systemd' %}
include:
  - {{ slspath }}.config

{% set user = traefik.user %}
{% set group = traefik.group %}
{% set config_dir = traefik.config_dir%}
{% set bin_dir = traefik.bin_dir%}
{% set config_file = traefik.config_file %}

traefik_configure_service:
  file.managed:
    - name: /etc/systemd/system/traefik.service
    - source: salt://{{ slspath }}/files/traefik.service
    - template: jinja
    - context:
      user: {{ user }}
      group: {{ group }}
      configfile: {{ config_dir }}/{{ config_file }}
      binfile: {{ bin_dir }}/traefik
    - mode: 0644
    - watch_in:
      - service: start_traefik_service

traefik_systemd_reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: traefik_configure_service
{%- endif %}

start_traefik_service:
  service.running:
    - name: traefik
    - enable: True
