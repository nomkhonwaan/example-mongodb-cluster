#!/bin/bash

apt-get update
apt-get install -y netcat 

while ! nc -z cluster0-0 27017
do
  sleep 1
done

while ! nc -z cluster0-1 27017
do
  sleep 1
done

while ! nc -z cluster0-2 27017
do
  sleep 1
done

mongo --host cluster0-0 <<EOF
rs.initiate(
  {
    _id : "cluster0",
    members: [
      { _id : 0, host : "cluster0-0:27017" },
      { _id : 1, host : "cluster0-1:27017" },
      { _id : 2, host : "cluster0-2:27017" }
    ]
  }
)
EOF

mongo mongodb://cluster0-0,cluster0-1,cluster0-2 <<EOF
use test;

db.users.insert({ "hello": "world!" });
EOF