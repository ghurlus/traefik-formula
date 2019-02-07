=======
Traefik
=======

Formula to install `Traefik <https://traefik.io>`_

.. note::
    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``traefik``
------------

Install and configure Traefik.

``traefik.install``
--------------------

Download and install the Traefik binary file.

``traefik.config``
-------------------

Provision the Traefik configuration file.

``traefik.service``
-------------------

Add the Traefik service startup configuration or script to an operating system.


``traefik.storeconfig``
-----------------------
Store Traefik configuration in a KV store (ex: Consul)

Notes
=====

- Please adapt files/config.toml to your needs as it is a generic configuration
- The init service is only compatible with systemd for the moment
