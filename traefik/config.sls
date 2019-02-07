{%- from slspath + '/map.jinja' import traefik with context -%}

traefik-config:
  file.managed:
    - name: {{ traefik.configdir }}/traefik.toml
    - source: {{ slspath }}/files/traefik.toml
    - user: {{ traefik.user }}
    - group: {{ traefik.group }}
    - mode: 0644
