#!/bin/sh

# Start up the aks.demo-gis.com proxy
docker-compose -f container.yaml up -d --build --force-recreate --remove-orphans