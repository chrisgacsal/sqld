#!/usr/bin/env bash

docker stop iku-turso-fdb
docker run --rm -p4500:4500 -d --name iku-turso-fdb foundationdb/foundationdb:7.1.25
echo "iku-turso-fdb container running in the background"

IKU_TURSO_ENDPOINT=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' iku-turso-fdb)
IKU_TURSO_FDB_CLUSTER_CONF=$(dirname "$0")/fdb.cluster
echo "docker:docker@${IKU_TURSO_ENDPOINT}:4500" > $IKU_TURSO_FDB_CLUSTER_CONF
cat $IKU_TURSO_FDB_CLUSTER_CONF

docker exec -it iku-turso-fdb fdbcli --exec "configure new single ssd"