# Portal Proxy

To streamline development against ArcGIS Enterprise, the Hub team utilizes a Docker container that runs nginx, configured as to proxy _some_ requests to an ArcGIS Enterprise instance, and read from a local mapped drive for others.

## What's in this repo

We've extracted the proxy out of the Hub application repo to streamline solving the current issues.

There are two configurations:

- /portal.hubdev -> portal.hubdev.arcgis.com - the Hub Team's default Enterprise instance
- /azure-k8s -> configuration to run against the k8s version, hosted on azure

### portal.hubdev

- Add `127.0.0.1 portal.hubdev.arcgis.com` to `/etc/hosts`
- `$ cd /portal.hubdev`
- `$ ./start.sh` runs docker-compose
- open `https://portal.hubdev.arcgis.com` in a browser
- it _should_ redirect to `https://portal.hubdev.arcgis.com/portal/home` and load the home app. Browse around the home app, everything should work
- open `https://portal.hubdev.arcgis.com/portal/apps/sites`
- this should open the "fake" sites app, which is just a html file in `./dist/sites/portal/apps/sites`

Current issue here is that nginx will return a 504 for _some_ requests that should go through to the portal instance. I suspect there is a load-balancer in the mix that's causing this issue - Aaron Pellman-Isaacs is looking into this

### azure-k8s

- Start VPN (required for this one)
- Add `127.0.0.1 aks.demo-gis.com` to `/etc/hosts`
- `cd /azure-k8s`
- `$ ./start.sh` runs docker-compose
- open `https://aks.demo-gis.com` in a browser
- it _should_ redirect to `https://aks.demo-gis.com/aks/home` and load the home app. Currently we get errors from nginx:

  > SSL_do_handshake() failed (SSL: error:14094416:SSL routines:ssl3_read_bytes:sslv3 alert certificate unknown:SSL alert number 46) while SSL handshaking,

- open `https://aks.demo-gis.com/aks/apps/sites`
- this should open the "fake" sites app, which is just a html file in `./dist/sites/portal/apps/sites`

This used to work just fine, but recently stopped. Unclear why.

## Developer Workflow:

This is the general developer workflow we've been using in the past...

- Hub developer adds an entry to their hosts file for the remote Enterprise instance they want to work against
- i.e `127.0.0.1 portal.hubdev.arcgis.com`
- Hub developer starts the related docker container
- `docker-compose -f container.yaml up -d --build --force-recreate --remove-orphans`
- Hub developer opens `https://portal.hubdev.arcgis.com/portal/home` and the home app loads because those requests are proxied through to the actual `portal.hubdev.arcgis.com` system
- Hub developer starts up the Hub app locally, in "portal mode",
- Hub developer opens `https://portal.hubdev.arcgis.com/portal/apps/sites` which loads the build output files from local disk
