#!/bin/sh

# Start up the portal.hubdev proxy
docker-compose -f container.yaml up -d --build --force-recreate --remove-orphans