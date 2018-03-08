#!/bin/sh

apt-get update
apt-get install -y netcat 

while ! nc -z config0 27019
do
  sleep 1
done

while ! nc -z config1 27019
do
  sleep 1
done

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

while ! nc -z cluster0-shard0-0 27018
do
  sleep 1
done

while ! nc -z cluster0-shard0-1 27018
do
  sleep 1
done

while ! nc -z cluster0-shard0-2 27018
do
  sleep 1
done

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

while ! nc -z cluster1-shard0-0 27018
do
  sleep 1
done

while ! nc -z cluster1-shard0-1 27018
do
  sleep 1
done

while ! nc -z cluster1-shard0-2 27018
do
  sleep 1
done

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

while ! nc -z mongos 27017
do
  sleep 1
done

mongo --host mongos <<EOF
sh.addShard("cluster0-shard0/cluster0-shard0-0:27018");
sh.addShard("cluster1-shard0/cluster1-shard0-0:27018");
EOF

mongo --host mongos <<EOF
use test;
sh.enableSharding("test")

db.users.insert({ "hello0": "world!" });
db.users.insert({ "hello1": "world!" });
db.users.insert({ "hello2": "world!" });
db.users.insert({ "hello3": "world!" });
db.users.insert({ "hello4": "world!" });
db.users.insert({ "hello5": "world!" });
db.users.insert({ "hello6": "world!" });
db.users.insert({ "hello7": "world!" });
db.users.insert({ "hello8": "world!" });
db.users.insert({ "hello9": "world!" });
EOF
