{%- from slspath + '/map.jinja' import traefik with context -%}

{%- if grains.init == 'systemd' %}
traefik-service-file:
  file.managed:
    - source: salt://{{ slspath }}/files/traefik.service
    - name: /etc/systemd/system/traefik.service
    - mode: 0644
    - watch_in:
      - service: traefik-service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/traefik.service
{%- endif %}

traefik-service:
  service.running:
    - name: traefik
    - enable: True
    - watch:
      - file: {{ traefik.bindir }}/traefik
