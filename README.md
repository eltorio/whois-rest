# WHOIS-REST

This is a simple Go service that exposes a REST API at the URL `/whois`. It queries the `whois.cymru.com` server (or another server specified by the `WHOIS_SERVER` environment variable) using the WHOIS protocol on port 43. The `/whois` endpoint accepts a `host` parameter to specify the host to be queried.  
By default the server listen on port 8080 (or another port specified by the `HTTP_PORT` environment variable)

## Requirements

- Go 1.16 or later

## Building

To build the service, run:

```bash
go build -o main .
```

## Docker image
`docker pull highcanfly/whois-rest`

## Kubernetes
```bash
helm repo add highcanfly https://helm-repo.highcanfly.club/
helm repo update
helm upgrade --install --create-namespace --namespace whois-rest highcanfly/whois-rest
```