# 🐋 Docker 🐁 Traefik 🦄 .Localhost

Use Traefik to proxy Docker containers for `*.localhost` development. Assuming `*.localhost` domains resolve to the loopback interface.

## Usage

Create a bridge network named `traefik`:

```sh
docker network create traefik
```

Start the Traefik container (this repo):

```sh
docker-compose up -d
```

Visit the dashboard:

```
http://traefik.localhost
```

### Discovery

Traefik will automatically discover containers in the `traefik` network that use labels. See [docker-compose.yml](/docker-compose.yml) for the full example service.

```yml
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
    - "traefik.http.services.whoami.loadbalancer.server.port=80"
```

Or via the `dynamic.toml` config file:

```toml
[http.routers.whoami]
  rule = "Host(`whoami.localhost`)"
  service = "whoami"

[http.services]
  [http.services.whoami.loadBalancer]
    [[http.services.whoami.loadBalancer.servers]]
      url = "http://whoami"
```

See the [Traefik documentation](https://doc.traefik.io/traefik/providers/docker/) for more details.

* * *

[MIT License](/LICENSE) | Copyright © 2021 [David Bushell](https://dbushell.com) | [@dbushell](https://twitter.com/dbushell)
