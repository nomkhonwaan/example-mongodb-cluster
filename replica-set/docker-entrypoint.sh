#!/bin/bash


sleep 10

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

echo "mongo mongodb://localhost:27017,localhost:27018,localhost:27019/test"