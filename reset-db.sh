#! /bin/bash

docker ps -a | grep turl-db
if [[ $? -eq 0 ]]; then
  docker stop turl-db && docker rm turl-db
fi
docker run --name turl-db -p 5432:5432 -e POSTGRES_PASSWORD=sekret -d postgres

for i in {1..5}; do
  echo -n "."
  sleep 1
done
echo

docker cp bootstrap.sql turl-db:/tmp/bootstrap.sql
docker exec turl-db psql -U postgres -f /tmp/bootstrap.sql
