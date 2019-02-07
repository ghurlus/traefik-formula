{%- from slspath + '/map.jinja' import traefik with context -%}

# Create traefik user
traefik-group:
  group.present:
    - name: {{ traefik.group }}

traefik-user:
  user.present:
    - name: {{ traefik.user }}
    - groups:
      - {{ traefik.group }}
    - createhome: False
    - system: True
    - require:
      - group: traefik-group

# Create directories
traefik-configdir:
  file.directory:
    - name: {{ traefik.configdir }}
    - user: root
    - group: root
    - mode: 0755

traefik-bindir:
  file.directory:
    - name: {{ traefik.bindir }}
    - makedirs: True
    - user: root
    - group: staff
    - mode: 2775

# Install Traefik
traefik-install:
  file.managed:
    - name: {{ traefik.bindir }}/traefik_linux-{{ traefik.arch }}
    - source: https://{{ traefik.download_host }}/containous/traefik/releases/download/v{{ traefik.version }}/traefik_linux-{{ traefik.arch }}
    - unless: test -f {{ traefik.bindir }}/traefik_linux-{{ traefik.version }}-{{ traefik.arch }}
    - require:
      - file: traefik-bindir
