# 🚀 Week 5 – Messaging Systems & Distributed Databases

👨‍💻 **Nanosoft Technology – DevOps Internship**

🖥 Environment: Ubuntu 22.04 LTS (VM) & Windows

---

## 📘 Objective

The objective of Week 5 was to implement distributed backend infrastructure components including:

- RabbitMQ installation & clustering (Ubuntu + Windows)
- MongoDB replica set configuration (Ubuntu + Windows)
- Redis installation with authentication
- Redis multi-node cluster simulation using different ports
- Cross-platform service verification and clustering concepts

This week focused on distributed systems, clustering, high availability concepts, and authentication mechanisms.

---

# 🧩 Task 1 – Installation of RabbitMQ

---

## 📦 Install RabbitMQ on Ubuntu

```bash
apt update
apt install rabbitmq-server -y
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
```

Verified service:

```bash
systemctl status rabbitmq-server
```

---

## 🖥 Install RabbitMQ on Windows

- Installed Erlang (required dependency)
- Installed RabbitMQ Server
- Enabled management plugin:

```bash
rabbitmq-plugins enable rabbitmq_management
```

Accessed management UI via:

```
http://localhost:15672
```

---

## 🔗 Create RabbitMQ Cluster

Clustered nodes by configuring:

```bash
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@<node>
rabbitmqctl start_app
rabbitmqctl cluster_status
```

Verified:

- Nodes visible in cluster
- Running cluster status
- Management UI showing cluster information

---

## 🧠 Concepts Learned

- AMQP protocol basics
- RabbitMQ architecture
- Erlang dependency
- Node naming & cluster joining
- Management UI usage
- Distributed message broker concepts

---

# 🧩 Task 2 – Installation of MongoDB

---

## 🖥 Install MongoDB on Ubuntu (Replica Set Setup)

Installed MongoDB and started service:

```bash
systemctl start mongod
systemctl enable mongod
```

Accessed Mongo shell:

```bash
mongosh
```

Initialized replica set:

```bash
rs.initiate()
rs.status()
```

Simulated multi-node cluster using different ports.

---

## 🖥 Install MongoDB 7.0.2 on Windows

Verified version:

```bash
mongosh --version
```

Configured replica set similarly on Windows.

Verified:

```bash
rs.status()
```

Observed:

- PRIMARY
- SECONDARY
- Health status
- Replica set state

---

## 🧠 Concepts Learned

- NoSQL architecture
- Replica set configuration
- Primary vs Secondary nodes
- Data replication
- Cluster simulation using ports
- Cross-platform MongoDB setup

---

# 🧩 Task 3 – Installation of Redis

---

## 📦 Install Redis on Ubuntu & Windows

Installed Redis service and started it.

Verified:

```bash
redis-cli ping
```

---

## 🔐 Configure Authentication Key

Updated redis configuration:

```bash
requirepass <REDACTED>
```

Tested authentication:

```bash
redis-cli
PING
AUTH <REDACTED>
PING
```

Observed:

- NOAUTH error without password
- PONG after authentication

---

## 🔗 Create Redis Cluster (Multi-Port Simulation)

Created Redis cluster using:

```bash
redis-cli --cluster create \
127.0.0.1:7001 \
127.0.0.1:7002 \
127.0.0.1:7003 \
--cluster-replicas 0
```

Verified cluster:

```bash
cluster info
```

Confirmed:

```
cluster_state:ok
```

Checked listening ports:

```bash
netstat -ano | findstr 700
```

---

## 🧠 Concepts Learned

- In-memory data storage
- Redis node configuration
- Cluster simulation using ports
- Authentication security
- Cluster state verification
- Multi-node simulation techniques

---

# 🧠 Concepts Learned in Week 5

- Distributed system architecture
- Message brokers (RabbitMQ)
- Replica sets (MongoDB)
- In-memory caching (Redis)
- Cluster configuration
- Service authentication
- Cross-platform setup (Linux + Windows)
- Multi-node simulation using ports
- High availability fundamentals

---

# 📸 Snapshots

Below are screenshots demonstrating installation, configuration, and verification.

---

## 🖼 Task 1 – RabbitMQ

![RabbitMQ-1](Week 5/images/1.png)
![RabbitMQ-2](Week 5/images/2.png)
![RabbitMQ-3](Week 5/images/3.png)
![RabbitMQ-4](Week 5/images/4.png)
![RabbitMQ-5](Week 5/images/5.png)
![RabbitMQ-6](Week 5/images/6.png)

---

## 🖼 Task 2 – MongoDB

![MongoDB-1](Week 5/images/7.png)
![MongoDB-2](Week 5/images/8.png)
![MongoDB-3](Week 5/images/9.png)
![MongoDB-4](Week 5/images/10.png)
![MongoDB-5](Week 5/images/11.png)

---

## 🖼 Task 3 – Redis

![Redis-1](Week 5/images/12.png)
![Redis-2](Week 5/images/13.png)
![Redis-3](Week 5/images/14.png)
![Redis-4](Week 5/images/15.png)
![Redis-5](Week 5/images/16.png)
![Redis-6](Week 5/images/17.png)
![Redis-7](Week 5/images/18.png)
![Redis-8](Week 5/images/19.png)
![Redis-9](Week 5/images/20.png)

---
