# Docker Compose files

This directory contains various Docker Compose files which I use in my home network to manage
my various services.

There are a couple of common themes around these services:

* Nginx Proxy Manager is used to operate an Nginx service as the reverse proxy for all
  web based access methods for these services.
* The Docker environment must provide an existing network called `dmz` to which all the
  backend services exposed through the Nginx reverse proxy must be connected.
* All backend services connected to the `dmz` network need not have any port mappings
  configured as the respective ports are accessible to the Nginx reverse proxy on the
  `dmz` network.
* For emergency reasons, services may still map their web ports to the bridge network
  allowing them to be accessed directly from the internal (home) network in case the
  Nginx reverse proxy is not available.
* Services exposing non-HTTP services such as Pi-Hole serving as a DNS server must
  still map their non-HTTP service ports to the bridge network to make them available !

## Note on Networking

Normally services will be bound to the `dmz` network to support them being exposed
through the reverse proxy. If a Docker Compose file contains multiple containers
they should be connected amongst each other with a separate Docker Compose internal
network, such as for example the `db` network in the `nginxproxymanager`.

Last but not least, in some exceptional cases this internal network needs to be
manually managed for IP addresses, an example of which is `pihole` because the
Pi-Hole container must be configured with an explicit IP address of its upstream
DNS service for which we use Unbound DNS.

To this avail the network `172.30.0.0/16` is put asside for manual IP address
management. Currently the following network is reserved:

* `172.30.0.4/30` for Pi-Hole
