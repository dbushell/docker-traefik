# 🐋 Docker 🐁 Traefik 🦄 .Localhost

Use Traefik to proxy Docker containers for `*.localhost` development. Assuming `*.localhost` domains resolve to the loopback interface.

Now updated to provided HTTPS for a custom domain.

## Usage

Create a bridge network named `traefik`:

```sh
docker network create -d bridge traefik
```

Create an `.env` file (chmod 600):

```sh
TRFK_HOST_IP=127.0.0.1
TRFK_HTTP_PORT=80
TRFK_HTTPS_PORT=443
TRFK_ACME_DOMAIN=example.dev
TRFK_ACME_EMAIL=hello@example.com
TRFK_ACME_PROVIDER=cloudflare
TRFK_ACME_RESOLVER="1.1.1.1:53"
CF_DNS_API_TOKEN="see: https://go-acme.github.io/lego/dns/cloudflare/"
```

Start the Traefik container (this repo):

```sh
docker-compose up -d
```

### Discovery

Traefik will automatically discover containers in the `traefik` network that use labels. See [docker-compose.yml](/docker-compose.yml) for the full example service.

Insecure `.localhost` domain:

```yml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
  - "traefik.http.services.whoami.loadbalancer.server.port=80"
```

Secure domain:

```yml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.whoami.entrypoints=websecure"
  - "traefik.http.routers.whoami.rule=Host(`whoami.${TRFK_ACME_DOMAIN}`)"
  - "traefik.http.services.whoami.loadbalancer.server.port=80"
```

Or via the `dynamic.yml` config file:

```yml
http:
  routers:
    whoami:
      entryPoints: ['websecure']
      rule: "Host(`whoami.{{ env "TRFK_ACME_DOMAIN" }}`)"
      service: whoami
  services:
    whoami:
      loadBalancer:
        servers:
          - url: "http://whoami"
```

See the [Traefik documentation](https://doc.traefik.io/traefik/providers/docker/) for more details.

* * *

[MIT License](/LICENSE) | Copyright © 2023 [David Bushell](https://dbushell.com)
