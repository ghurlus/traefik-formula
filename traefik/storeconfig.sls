include:
  - {{ slspath }}.service
  - {{ slspath }}.config

traefik_storeconfig:
  cmd.run:
    - name: traefik storeconfig
    - require:
      - service: start_traefik_service
    - onchanges:
      - file: traefik_config
