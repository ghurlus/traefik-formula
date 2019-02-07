{%- from slspath + '/map.jinja' import traefik with context -%}

include:
  - {{ slspath }}.install
  - {{ slspath }}.config
  - {{ slspath }}.service
