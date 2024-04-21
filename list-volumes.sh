#!/bin/sh

volumes=$(docker volume ls  --format '{{.Name}}')

for volume in $volumes
do
  echo $volume
  docker ps -a --filter volume="$volume"  --format '{{.Names}}' | sed 's/^/  /'
done