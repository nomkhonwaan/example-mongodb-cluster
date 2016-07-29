#!/binsh

sleep 10

mongo --host mongo-rc0svr1 <<EOF
  rs.initiate({
    "_id": "rc0",
    "version": 1,
    "members": [
      {
        "_id": 0,
        "host": "mongo-rc0svr1",
        "priority": 1
      },
      {
        "_id": 1,
        "host": "mongo-rc0svr2",
        "priority": 0.5,
        "votes": 1
      },
      {
        "_id": 2,
        "host": "mongo-rc0svr3",
        "priority": 0.5,
        "votes": 1
      }
    ]
  });
EOF

mongo --host mongos <<EOF
  sh.addShard("rc0/mongo-rc0svr1");
EOF

mongo --host mongos <<EOF
  use test;
  db.users.insert({
    "first_name": "Natcha",
    "last_name": "Luang - Aroonchai",
    "email": "natcha.lua@krungthai-axa.co.th",
  });
EOF
