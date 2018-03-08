#!/bin/sh

set -e 

sleep 10

mongo --host config0 --port 27019 <<EOF
rs.initiate(
{
    _id: "config",
    configsvr: true,
    members: [
    { _id : 0, host : "config0:27019" },
    { _id : 1, host : "config1:27019" }
    ]
}
)
EOF

sleep 10

mongo --host cluster0-shard0-0 --port 27018 <<EOF
rs.initiate(
{
    _id : "cluster0-shard0",
    members: [
    { _id : 0, host : "cluster0-shard0-0:27018" },
    { _id : 1, host : "cluster0-shard0-1:27018" },
    { _id : 2, host : "cluster0-shard0-2:27018" }
    ]
}
)
EOF

sleep 10

mongo --host cluster1-shard0-0 --port 27018 <<EOF
rs.initiate(
{
    _id : "cluster1-shard0",
    members: [
    { _id : 0, host : "cluster1-shard0-0:27018" },
    { _id : 1, host : "cluster1-shard0-1:27018" },
    { _id : 2, host : "cluster1-shard0-2:27018" }
    ]
}
)
EOF

sleep 30

mongo --host mongos <<EOF
sh.addShard("cluster0-shard0/cluster0-shard0-0:27018");
sh.addShard("cluster1-shard0/cluster1-shard0-0:27018");
EOF

echo "mongo mongodb://localhost:27017/test"