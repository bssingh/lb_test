#!/usr/bin/env bash
echo "------------ Stopping all containers ---------"
docker container list > /dev/null 2>&1
for i in `docker container list | cut -f1 -d " "`; do docker container stop $i > /dev/null 2>&1; done
docker container list > /dev/null 2>&1
docker container prune --force > /dev/null 2>&1
