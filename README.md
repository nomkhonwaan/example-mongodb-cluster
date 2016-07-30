# Example MongoDB Cluster

This repository for Proof-of-Concept how to make MongoDB for fault tolerance system. I have 2 ways for doing likes that, one for easy setup and required little instances, one for complexity setup but easy to scale in a horizontal system. For more information read below.

Fault tolerance concept on this project means when some instance has been downed, the remaining instances should do an elections for new primary instance instead.

## Table of Contents

  - [Overview](#overview)
    - [Replica Cluster](#replica-cluster)
    - [Shard Cluster](#shard-cluster)
  - [Installation](#Installation)
  - [Running Instances](#running-instances)
  - [References](#references)

## Overview

The requirement for this project is making fault tolerance MongoDB server, but I found 2 difference ways that make for difference purpose.
  - [Replica Cluster](#replica-cluster)
  - [Shared Cluster](#shard-cluster)

### Replica Cluster

The _Replica Cluster_ is the best cluster for small purpose system and don't want to scale up in nearly future. This architecture is easier to setup and required minimum 3 instances for allowed 1 instance down.

```
Replica cluster diagram

           -----------
    -----> | primary | <-----
    |      -----------      |
    v                       v
---------               ---------
| slave |               | slave |
---------               ---------
```

In this concept when client want to _read_ data from cluster set, they can _read_ on any instance in side this set. But for _write_ (**must**) only on primary instance, so if you want to write on slave MongoDB allowed you to do that but is not good idea, see [rs.slaveOk](https://docs.mongodb.com/manual/reference/method/rs.slaveOk/) for transaction in slave instance.

Once some instance has been downed, and if it not primary, then nothing happen primary still primary and other slave will act like normally. But this allowed downed instance just 1, you can add more instances for increase allow downed instances.

Once the primary instance has been downed, the remaining slave will elections new instance to be come primary, this reversed for the slave instance that have _votes_ set only. In the replica set you can add maximum instance to 50 instances, but only 7 instances can _votes_ on elections. More information about [Replica Set Elections](https://docs.mongodb.com/manual/core/replica-set-elections/).

### Shard Cluster

The _Shard Cluster_ is the complex on for medium or large purpose system that you want to scale up easy in horizontal view, this concept required minimum 5 instances and allowed 1 instance of replica set down.

Shard cluster is the set of replica that managed routes by MongoDB router (`mongos`). Let think you have the replica set that contain many MongoDB instances inside, and you have more than one replica set e.g. rc0, rc1 you want to make it connected and split data to be stored in those replica set, you come to the right way! the shard cluster is designed for that purpose, for more information this link is clearly explain for me, [Sharding](https://docs.mongodb.com/manual/sharding/).

```
Shard cluster diagram

                -------------------
                | mongos (router) | <----------
                -------------------           |
                         ^                    v
                         |                ----------
             ------------|------------    | config |
             |           |           |    ----------
             v           v           v
          -------     -------     -------
          | rc0 |     | rc1 | ... | rcN |
          -------     -------     -------
             ^
             |
             v
        -----------
    --> | primary | <--
    |   -----------   |
    v                 v
---------         ---------
| slave |         | slave |
---------         ---------
```

In shard cluster you can plug more and more replica set to this set, in each replica set the allow downed instance(s) is up to instance members and the elections concept is same on above. For other instance (mongos, config) you can make it as replica set also.

## Installation

This project required Docker to run instance and high-speed internet for downloading Docker images.

```
$ git clone https://github.com/nomkhonwaan/example-mongo-cluster.git
```

## Running Instances

First you need to `cd` to what cluster type that you want to run, then using `docker-compose` command to start it like this.

```
$ docker-compose up 
```

Or you want to re-create all instances just put `--force-recreate` at tail. After done your test, use this command to destroy all Docker containers.

```
$ docker-compose down
```
 
## References
 - [Replica Set Elections](https://docs.mongodb.com/manual/core/replica-set-elections/)
 - [Sharding](https://docs.mongodb.com/manual/sharding/)
 - [docker-compose up](https://docs.docker.com/compose/reference/up/)
