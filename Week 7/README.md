# 🚀 Week 7 – Section 1

# 🐳 Docker CI/CD (Offline Deployment + Rollback)

👨‍💻 **Nanosoft Technology – DevOps Internship**

🐳 Environment: Jenkins + Docker + Target VM (192.168.56.111)

---

## 📘 Objective

The objective of this task was to implement a **production-style Docker CI/CD pipeline** using Jenkins that performs:

- Docker image build
- Commit-hash tagging
- Security scanning (Trivy)
- Offline image packaging (TAR)
- Secure transfer via SCP
- Remote deployment
- Health check validation
- Automatic rollback on failure

This simulates a **real enterprise environment where Docker Hub push is restricted**.

---

# 🧩 Task – Docker + CI/CD Pipeline Implementation

---

## 🔄 Stage 1 – Prepare App + Git Commit

- Captured latest commit hash
- Stored commit ID for image tagging
- Ensured reproducible builds

Pipeline Stage:

```
Prepare App + Git Commit
```

---

## 🏗 Stage 2 – Build Docker Image (Tag = Commit Hash)

```bash
docker build -t week7-demo:<commit-hash> .
```

✔ Image versioned using commit hash  
✔ Ensures traceable deployments

---

## 🔍 Stage 3 – Scan Image (Trivy)

```bash
trivy image week7-demo:<commit-hash>
```

Verified:

- Vulnerability scan completed
- No critical security issues blocking deployment

---

## 📦 Stage 4 – Package Image as TAR (Offline Push)

Instead of pushing to Docker Hub:

```bash
docker save week7-demo:<commit-hash> -o week7-demo-<commit>.tar.gz
```

✔ Enables air-gapped deployment  
✔ Secure internal infrastructure simulation

---

## 📤 Stage 5 – Upload TAR to Deployment VM (SCP)

```bash
scp week7-demo-<commit>.tar.gz user@192.168.56.111:/opt/deploy/
```

Verified:

- Secure transfer successful
- Target VM ready for image loading

---

## 🚀 Stage 6 – Deploy on Target + Health Check

On Target VM:

```bash
docker load -i week7-demo-<commit>.tar.gz
docker run -d -p 3000:3000 week7-demo:<commit>
```

Health check validation:

```bash
curl http://localhost:3000
```

Observed:

```
Health HTTP code: 200
DEPLOY OK: <commit>
```

✔ Successful deployment  
✔ Application reachable  
✔ Port 3000 exposed

---

## 🔁 Rollback Strategy (If Deployment Fails)

If health check fails:

```bash
docker run -d -p 3000:3000 week7-demo:<previous-commit>
```

✔ Automatic recovery  
✔ Version-controlled rollback  
✔ Zero downtime simulation

---

## 🧠 Concepts Learned

- CI/CD automation with Jenkins
- Docker image versioning strategy
- Security scanning inside pipeline
- Offline Docker deployment model
- SCP-based production deployment
- Health check validation
- Rollback mechanism design
- Production-grade deployment workflow

---

# 📸 Snapshots

Below are screenshots demonstrating successful pipeline execution and deployment verification.

---

## 🖼 Pipeline Overview

![Docker-CICD-1](snapshots/Docker%20CICD/1.png)

---

## 🖼 Upload TAR to Deployment VM (SCP Stage)

![Docker-CICD-2](snapshots/Docker%20CICD/2.png)

---

## 🖼 Deploy on Target + Health Check Success

![Docker-CICD-3](snapshots/Docker%20CICD/3.png)

---

# 🚀 Week 7 – Section 2

# 🐳 Docker Compose – Multi-Container Application

---

👨‍💻 **Nanosoft Technology – DevOps Internship**  
🐳 Environment: Docker Compose (Bridge Network + Named Volumes)

---

## 📘 Objective

The objective of this task was to design and deploy a **multi-container production-style application** using Docker Compose that includes:

- Backend APIs (Node + Java)
- Frontend client
- Nginx reverse proxy
- MySQL database
- MongoDB database
- Named volumes for persistence
- Custom bridge network
- Environment variable configuration
- Inter-container communication

This simulates a real microservices-based architecture.

---

# 🧩 Task – Multi-Container Architecture Using Docker Compose

---

## 🏗 Application Stack

The application consists of:

| Service | Technology   | Purpose         |
| ------- | ------------ | --------------- |
| client  | Frontend App | UI Layer        |
| api     | Node.js API  | Backend Service |
| webapi  | Java API     | Backend Service |
| emartdb | MySQL 8.0    | Relational DB   |
| emongo  | MongoDB 4    | NoSQL DB        |
| nginx   | Nginx        | Reverse Proxy   |

---

## 📂 Project Structure

Observed in:

```bash
ls -la
```

Includes:

- Dockerfile
- docker-compose.yml
- .env
- client/
- nodeapi/
- javaapi/
- nginx/
- Named volume configuration

---

## 🌐 Custom Network Configuration

```yaml
networks:
  emart_net:
    driver: bridge
```

✔ All services connected to internal bridge network  
✔ Secure inter-service communication  
✔ Isolation from host network

---

## 💾 Named Volumes (Persistent Storage)

```yaml
volumes:
  mongo_data:
  mysql_data:
```

Used as:

```yaml
mongo_data:/data/db
mysql_data:/var/lib/mysql
```

✔ Database data persists after container restart  
✔ Production-grade storage handling

---

## 🔐 Environment Variables (.env)

Configured:

```env
MYSQL_ROOT_PASSWORD=****
MYSQL_DATABASE=books
MONGO_INITDB_DATABASE=****
```

Used inside docker-compose.yml:

```yaml
environment:
  - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
```

✔ Secure configuration management  
✔ No hardcoded credentials

---

## ▶ Build & Start Containers

```bash
docker compose up -d --build
```

Observed:

- Images built successfully
- Network created
- Volumes created
- Containers started

---

## 📊 Container Verification

```bash
docker compose ps
```

Verified:

- api → Running
- client → Running
- webapi → Running
- emartdb → Running
- emongo → Running
- nginx → Running

---

## 🗄 Database Verification (MySQL)

```bash
docker compose exec emartdb sh -c \
'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"'
```

Output confirmed:

- books
- information_schema
- mysql
- performance_schema
- sys

✔ Database successfully initialized  
✔ Environment variables applied

---

## 🌍 Application Access via Nginx

```bash
curl -I http://localhost
```

Response:

```
HTTP/1.1 200 OK
Server: nginx/1.29.4
```

✔ Reverse proxy working  
✔ Multi-container routing successful  
✔ Port 80 exposed

---

# 🧠 Concepts Learned

- Docker Compose orchestration
- Multi-container microservices design
- Bridge networking
- Named volumes & persistence
- Environment variable injection
- Service dependency handling
- Reverse proxy configuration
- Container-to-container communication

---

# 📸 Snapshots

---

## 🖼 Database Verification

![Compose-1](snapshots/Docker%20Compose%20%E2%80%93%20Multi-Container%20Application/1.png)

---

## 🖼 Project Structure

![Compose-2](snapshots/Docker%20Compose%20%E2%80%93%20Multi-Container%20Application/2.png)

---

## 🖼 Container Status (docker compose ps)

![Compose-3](snapshots/Docker%20Compose%20%E2%80%93%20Multi-Container%20Application/3.png)

---

## 🖼 docker-compose.yml Configuration

![Compose-4](snapshots/Docker%20Compose%20%E2%80%93%20Multi-Container%20Application/4.png)

---

# ✅ Outcome

Successfully deployed a **production-style multi-container architecture** using Docker Compose featuring:

✔ Backend services  
✔ Frontend service  
✔ Reverse proxy  
✔ MySQL & MongoDB  
✔ Named volumes  
✔ Custom bridge network  
✔ Environment configuration

This demonstrates real-world containerized microservices deployment.

---

# 🚀 Week 7 – Section 3

# 🐳 Docker Deep Dive (Networking, Isolation, Overlay, tcpdump)

---

👨‍💻 **Nanosoft Technology – DevOps Internship**  
🐳 Environment: Docker Networking (Bridge, Host, Overlay, Swarm)

---

## 📘 Objective

The objective of this task was to deeply understand Docker networking internals by:

- Creating multiple custom bridge networks
- Testing isolation between networks
- Fixing connectivity manually
- Demonstrating host network behavior
- Simulating overlay networks (Swarm mode)
- Capturing real traffic using tcpdump
- Analyzing ICMP packets from captured pcap

This task focused on **real packet-level understanding of Docker networking**.

---

# 🧩 Task 1 – Create Custom Bridge Networks

---

## 🔹 Create Networks

```bash
docker network create mybridge1
docker network create mybridge2
```

Verify:

```bash
docker network ls
```

Observed:

- mybridge1 (bridge)
- mybridge2 (bridge)
- host
- overlay networks (Swarm)

---

# 🧩 Task 2 – Network Isolation Test

---

## 🔹 Run Containers on Different Networks

```bash
docker run -d --name c1 --network mybridge1 alpine sleep 1d
docker run -d --name c2 --network mybridge2 alpine sleep 1d
```

IP Allocation:

- c1 → 172.18.0.2
- c2 → 172.19.0.2

---

## 🔹 Ping Test (Expected Failure)

```bash
docker exec c1 ping -c 2 <c2-ip>
```

Result:

```
Ping exit code: 1 (expected non-zero)
```

✔ Containers on different bridge networks cannot communicate  
✔ Network isolation confirmed

---

# 🧩 Task 3 – Fix Connectivity Manually

---

## 🔹 Connect c2 to mybridge1

```bash
docker network connect mybridge1 c2
```

New IP assigned:

- c2 on mybridge1 → 172.18.0.3

---

## 🔹 Ping Test After Fix

```bash
docker exec c1 ping -c 2 172.18.0.3
```

Result:

```
0% packet loss
```

✔ Connectivity restored  
✔ Multi-network attachment demonstrated

---

# 🧩 Task 4 – Host Network Mode Demo

---

## 🔹 Run Container Using Host Network

```bash
docker run -d --name hostweb --network host python:3.11-alpine \
sh -c "python -m http.server 8080"
```

Test:

```bash
curl http://127.0.0.1:8080
```

✔ Direct host binding  
✔ No container network isolation  
✔ Shares host networking stack

---

# 🧩 Task 5 – Overlay Network (Swarm Mode)

---

## 🔹 Create Swarm Services

```bash
docker service create --name s1 --replicas 2 alpine sleep 1000
docker service create --name s2 --replicas 2 alpine sleep 1000
```

Verify:

```bash
docker service ps s1
docker service ps s2
```

---

## 🔹 Overlay Communication Test

```bash
docker run --rm --network myoverlay1 alpine \
sh -c "ping -c 2 s1 && ping -c 2 s2"
```

Observed:

```
0% packet loss
```

✔ Overlay networking works across replicas  
✔ Service discovery functioning

---

# 🧩 Task 6 – Capture Traffic with tcpdump

---

## 🔹 Capture ICMP Traffic

```bash
docker exec c1 ping -c 4 c2
```

Traffic captured:

```
/home/vagrant/week7-networking/results/icmp_capture.pcap
```

---

## 🔹 Inspect pcap File

```bash
tcpdump -r icmp_capture.pcap
```

Observed:

```
ICMP echo request
ICMP echo reply
```

✔ Packet-level verification  
✔ Bridge interface capture successful

---

# 🧠 Concepts Learned

- Docker bridge networking
- Network namespace isolation
- Multi-network container attachment
- Host networking behavior
- Swarm overlay networking
- Service discovery in Swarm
- Packet capture using tcpdump
- ICMP traffic analysis
- Linux bridge interfaces
- Container networking internals

---

# 📸 Snapshots

All images stored under:

```
Week 7/images/
```

---

## 🖼 Network Isolation Test

![DeepDive-1](snapshots/Docker%20Deep%20Dive/1.png)

---

## 🖼 Connectivity Fix

![DeepDive-2](snapshots/Docker%20Deep%20Dive/2.png)

---

## 🖼 Host Network Demo

![DeepDive-3](snapshots/Docker%20Deep%20Dive/3.png)

---

## 🖼 Swarm Overlay Networking

![DeepDive-4](snapshots/Docker%20Deep%20Dive/4.png)

---

## 🖼 tcpdump Capture

![DeepDive-5](snapshots/Docker%20Deep%20Dive/5.png)

---

## 🖼 pcap Analysis

![DeepDive-6](snapshots/Docker%20Deep%20Dive/6.png)

---

# ✅ Outcome

Successfully demonstrated:

✔ Network isolation  
✔ Manual connectivity control  
✔ Host vs Bridge comparison  
✔ Overlay networking via Swarm  
✔ Real packet capture & inspection

This section proves deep understanding of Docker networking at infrastructure level.

---

# 🚀 Week 7 – Section 4

# 📊 Docker Logs & Monitoring (Grafana + Loki + Promtail)

👨‍💻 **Nanosoft Technology – DevOps Internship**

🐳 Environment: Docker Logging, Loki Stack, Log Rotation

---

## 📘 Objective

The objective of this task was to:

- Understand Docker logging drivers
- Configure log rotation (json-file driver)
- Deploy Loki log aggregation stack
- Integrate Promtail to ship container logs
- Visualize logs in Grafana
- Verify logs locally and inside Loki
- Inspect container log paths manually

This task focused on **centralized logging and observability in Docker environments**.

---

# 🧩 Task 1 – Verify Docker Logging Driver

---

## 🔹 Check Current Logging Driver

```bash
docker info | grep -A5 "Logging Driver"
```

Observed:

```
Logging Driver: json-file
```

✔ Docker uses `json-file` by default
✔ Logs stored under `/var/lib/docker/containers/...`

---

# 🧩 Task 2 – Configure Log Rotation

---

## 🔹 Configure daemon.json

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "5m",
    "max-file": "3"
  }
}
```

This ensures:

- Each log file max 5MB
- Only 3 rotated files kept
- Prevents disk exhaustion

After configuration:

```bash
sudo systemctl restart docker
```

✔ Log rotation enabled

---

# 🧩 Task 3 – Deploy Loki Stack

Services started:

- grafana
- loki
- promtail
- test log containers (log-app, rotate-test)

Verify:

```bash
docker ps
```

Observed:

- Grafana → 3000
- Loki → 3100
- Promtail running
- log-app generating logs

---

# 🧩 Task 4 – Verify Logs Locally

---

## 🔹 App Generating Logs

Example:

```
INFO Hello from log-app line=7
INFO Hello from log-app line=8
...
```

Logs verified using:

```bash
docker logs log-app
```

✔ Logs generated successfully
✔ Stored locally using json-file

---

# 🧩 Task 5 – Inspect Container Log File Path

---

```bash
docker inspect rotate-test --format '{{.LogPath}}'
```

Observed:

```
/var/lib/docker/containers/<container-id>/<container-id>-json.log
```

✔ Confirmed physical log storage location

---

# 🧩 Task 6 – Access Grafana

---

Grafana URL:

```
http://localhost:3000
```

Default credentials:

```
admin / admin
```

✔ Grafana login successful

---

# 🧩 Task 7 – Query Logs in Loki

---

Inside Grafana → Explore → Loki

Query used:

```
{job="docker"}
```

Observed:

- Logs visible from containers
- Log volume graph displayed
- Query inspector stats visible

Example Stats:

- Total request time: 426 ms
- Lines processed/sec: 34712
- Total bytes processed: 3.05 MB

✔ Centralized logging working
✔ Loki receiving logs from Promtail

---

# 🧠 Architecture Flow

```
Docker Containers
        ↓
json-file logs
        ↓
Promtail
        ↓
Loki
        ↓
Grafana
```

This demonstrates a production-grade log aggregation pipeline.

---

# 📸 Snapshots

## 🖼 Loki Query in Grafana

![Logs-1](snapshots/Docker%20Logs%20%26%20Monitoring/1.png)

---

## 🖼 Docker Logging Driver Verification

![Logs-2](snapshots/Docker%20Logs%20%26%20Monitoring/2.png)

---

## 🖼 Grafana Login Page

![Logs-3](snapshots/Docker%20Logs%20%26%20Monitoring/3.png)

---

## 🖼 Running Containers

![Logs-4](snapshots/Docker%20Logs%20%26%20Monitoring/4.png)

---

## 🖼 Inspect Log Path

![Logs-5](snapshots/Docker%20Logs%20%26%20Monitoring/5.png)

---

# ✅ Outcome

Successfully implemented:

✔ Docker log rotation
✔ Centralized logging with Loki
✔ Log shipping with Promtail
✔ Log visualization in

# 🚀 Week 7 – Section 5

# 🐳 Docker Swarm Lab (Multi-Node Cluster)

👨‍💻 **Nanosoft Technology – DevOps Internship**

🐳 Environment: 1 Manager + 2 Worker Nodes (Vagrant-based Swarm Cluster)

---

## 📘 Objective

The objective of this lab was to:

- Initialize a Docker Swarm cluster
- Join multiple worker nodes
- Deploy replicated services
- Verify task distribution across nodes
- Perform rolling updates
- Observe node failure handling
- Understand Swarm orchestration behavior

This task focused on **container orchestration using native Docker Swarm**.

---

# 🧩 Task 1 – Initialize Swarm (Manager Node)

---

## 🔹 On Manager

```bash
docker swarm init --advertise-addr 192.168.56.10
```

Observed:

- Swarm initialized
- Manager node became Leader
- Join token generated

✔ Cluster created successfully

---

# 🧩 Task 2 – Join Worker Nodes

---

## 🔹 On worker1

```bash
docker swarm join --token <TOKEN> 192.168.56.10:2377
```

Result:

```
This node joined a swarm as a worker.
```

---

## 🔹 On worker2

```bash
docker swarm join --token <TOKEN> 192.168.56.10:2377
```

✔ Both workers successfully joined cluster

---

## 🔹 Verify Nodes (Manager)

```bash
docker node ls
```

Observed:

- manager → Leader
- worker1 → Ready
- worker2 → Ready

✔ Multi-node cluster operational

---

# 🧩 Task 3 – Deploy Replicated Service

---

## 🔹 Create Nginx Service

```bash
docker service create \
  --name web \
  --replicas 3 \
  -p 8080:80 \
  nginx
```

Observed:

```
overall progress: 3 out of 3 tasks
verify: Service converged
```

✔ 3 replicas running
✔ Published port 8080

---

## 🔹 Verify Service

```bash
docker service ls
```

Result:

```
web   replicated   3/3   nginx:latest   *:8080->80/tcp
```

---

## 🔹 Inspect Task Placement

```bash
docker service ps web
```

Observed:

- web.1 → worker1
- web.2 → worker2
- web.3 → manager

✔ Swarm distributed tasks automatically

---

## 🔹 Access Service

```bash
curl http://localhost:8080
```

Returned:

```
Welcome to nginx!
```

✔ Routing mesh working
✔ Service reachable from manager

---

# 🧩 Task 4 – Rolling Update

---

## 🔹 Update Image Version

```bash
docker service update \
  --image nginx:1.25 \
  --update-delay 5s \
  web
```

Observed:

- Tasks replaced one-by-one
- Old containers shutdown
- New version deployed

✔ Zero downtime rolling update successful

---

# 🧩 Task 5 – Node Failure Simulation

---

## 🔹 Stop worker1 VM

```bash
vagrant halt worker1
```

---

## 🔹 Verify Node Status

```bash
docker node ls
```

Observed:

- worker1 → Down
- worker2 → Ready
- manager → Leader

✔ Swarm detected node failure

---

## 🔹 Verify Service Tasks

```bash
docker service ps web
```

Observed:

- Failed tasks re-scheduled
- Service maintained desired replicas

✔ Self-healing behavior confirmed

---

# 🧠 Key Concepts Learned

- Swarm Manager vs Worker roles
- Leader election
- Service replication
- Routing mesh
- Rolling updates
- Self-healing containers
- Node availability states
- Distributed orchestration

---

# 📸 Snapshots

## 🖼 Swarm Init

![Swarm-1](snapshots/Docker%20Swarm/1.png)

---

## 🖼 Worker Join

![Swarm-2](snapshots/Docker%20Swarm/2.png)

---

## 🖼 Node List

![Swarm-3](snapshots/Docker%20Swarm/3.png)

---

## 🖼 Service Deployment

![Swarm-4](snapshots/Docker%20Swarm/4.png)

---

## 🖼 Service Tasks Distribution

![Swarm-5](snapshots/Docker%20Swarm/5.png)

---

## 🖼 Rolling Update

![Swarm-6](snapshots/Docker%20Swarm/6.png)

---

## 🖼 VM Simulation

![Swarm-7](snapshots/Docker%20Swarm/7.png)

---

## 🖼 Node Down Detection

![Swarm-8](snapshots/Docker%20Swarm/8.png)

---

# ✅ Outcome

Successfully demonstrated:

✔ Multi-node Swarm cluster
✔ Replicated service deployment
✔ Automatic load distribution
✔ Rolling updates with zero downtime
✔ Self-healing after

# 🚀 Week 7 – Section 6

# 🐳 Docker Volumes & Backup (PostgreSQL Data Protection Lab)

👨‍💻 **Nanosoft Technology – DevOps Internship**

🐳 Environment: Docker + PostgreSQL + Named Volumes + Remote Backup Server

---

## 📘 Objective

The objective of this lab was to:

- Create and inspect Docker named volumes
- Store PostgreSQL data inside volumes
- Perform database dump backup
- Compress and upload backup to remote server
- Restore database from backup
- Verify data integrity after restore
- Understand persistent storage in containers

This task focused on **data durability and disaster recovery in containerized environments**.

---

# 🧩 Task 1 – Verify Docker Volume

---

## 🔹 List Docker Volumes

```bash
docker volume ls | grep pgdata_week7
```

Observed:

```
local   pgdata_week7
```

✔ Named volume created successfully

---

## 🔹 Inspect Volume Mount

```bash
docker inspect pgdb --format '{{ json .Mounts }}' | jq
```

Observed:

```json
{
  "Type": "volume",
  "Name": "pgdata_week7",
  "Source": "/var/lib/docker/volumes/pgdata_week7/_data",
  "Destination": "/var/lib/postgresql/data",
  "Driver": "local",
  "RW": true
}
```

✔ PostgreSQL data stored inside Docker-managed volume
✔ Data persisted outside container filesystem

---

# 🧩 Task 2 – Database Backup

---

## 🔹 Generate Database Dump

```bash
docker exec pgdb pg_dump -U week7user week7db > week7db.sql
```

✔ SQL dump created

---

## 🔹 Compress Backup

```bash
tar -czf week7db_2026-01-20_09-56-22.tar.gz week7db.sql
```

Backup created:

```
week7db_2026-01-20_09-56-22.tar.gz
```

---

## 🔹 Upload to Remote Backup Server

```bash
scp week7db_2026-01-20_09-56-22.tar.gz backup-server:/opt/remote-backups/
```

Verified on backup server:

```
/opt/remote-backups/week7db_2026-01-20_09-56-22.tar.gz
```

✔ Remote backup stored successfully

---

# 🧩 Task 3 – Restore Process

---

## 🔹 Pull Backup

```bash
scp backup-server:/opt/remote-backups/week7db_2026-01-20_09-56-22.tar.gz .
```

---

## 🔹 Extract Backup

```bash
tar -xzf week7db_2026-01-20_09-56-22.tar.gz
```

---

## 🔹 Recreate Database

```bash
docker exec -e PGPASSWORD=week7pass pgdb \
psql -U week7user -d week7db -c "DROP DATABASE week7db;"
```

Recreate:

```bash
createdb week7db
```

---

## 🔹 Import SQL Dump

```bash
docker exec -e PGPASSWORD=week7pass pgdb \
psql -U week7user -d week7db < week7db.sql
```

✔ Database restored successfully

---

# 🧩 Task 4 – Restore Verification

---

## 🔹 Verify Data

```bash
docker exec -e PGPASSWORD=week7pass pgdb \
psql -U week7user -d week7db \
-c "SELECT * FROM students ORDER BY id;"
```

Observed:

```
1 | Mohsin      | mohsin.khan@example.com
2 | Sarah Ahmed | sarah.ahmed@example.com
3 | Hassan Raza | hassan.raza@example.com
```

✔ 3 rows restored
✔ Data integrity confirmed

---

# 🧠 Key Concepts Learned

- Docker named volumes
- Volume mount points
- Data persistence outside container lifecycle
- Database dump & restore process
- Remote backup storage
- Disaster recovery workflow
- Separation of data & container

---

# 📸 Snapshots

## 🖼 Volume Inspection

![Volume-1](snapshots/Docker%20Volumes%20%26%20Backup/1.png)

---

## 🖼 Backup Files Created

![Volume-2](snapshots/Docker%20Volumes%20%26%20Backup/2.png)

---

## 🖼 Remote Backup Server

![Volume-3](snapshots/Docker%20Volumes%20%26%20Backup/3.png)

---

## 🖼 Restore Verification

![Volume-4](snapshots/Docker%20Volumes%20%26%20Backup/4.png)

---

## 🖼 Results Directory

![Volume-5](snapshots/Docker%20Volumes%20%26%20Backup/5.png)

---

## 🖼 Final Data Check

![Volume-6](snapshots/Docker%20Volumes%20%26%20Backup/6.png)

---

# ✅ Outcome

Successfully demonstrated:

✔ Persistent storage using Docker volumes
✔ Safe database backup & compression
✔ Remote backup upload
✔ Full restore workflow
✔ Data verification after restore

This proves strong understanding of **container data management and backup strategy** — a critical DevOps skill.

---

# 🚀 Week 7 – Section 7

🐳 Production-Ready Dockerfile & Image Optimization

👨‍💻 **Nanosoft Technology – DevOps Internship**

🖥 Environment: Ubuntu 22.04 LTS (Vagrant VM)
🐳 Tools: Docker, Docker Compose

---

## 📘 Objective

The objective of this task was to:

- Optimize Docker images for production use
- Reduce image sizes (before vs after comparison)
- Remove unnecessary build-time dependencies
- Implement efficient Dockerfile practices
- Deploy full multi-service stack using Docker Compose
- Verify application availability via Nginx

This task focused on **real-world container optimization and production deployment readiness.**

---

# 🧩 Task 1 – Analyze Existing Images

---

## 🔍 List Current Images

```bash
docker images | grep emartapp
```

### Observed:

- `emartapp-api:latest` → ~229MB
- `emartapp-client:latest` → ~247MB
- `emartapp-webapi:latest` → ~407MB

Verified images are built and available locally.

---

## 🧠 Concepts Learned

- Docker image layers
- How image size affects performance
- Importance of minimal base images
- Layer caching behavior

---

# 🧩 Task 2 – Before vs After Image Optimization

---

## 📦 WebAPI (Java Service)

```bash
docker images | grep emartapp-webapi
```

### Observed:

- `emartapp-webapi:before` → **1.01GB**
- `emartapp-webapi:after` → **407MB**

✔ Significant size reduction achieved.

---

## 📦 API (Node Service)

```bash
docker images | grep emartapp-api
```

### Observed:

- `emartapp-api:before` → **1.69GB**
- `emartapp-api:after` → **221MB**

✔ Removed unnecessary build dependencies.
✔ Optimized runtime container.

---

## 🧠 Concepts Learned

- Multi-stage builds
- Separating build image from runtime image
- Reducing attack surface
- Smaller images = faster pull & deploy
- Production Dockerfile best practices

---

# 🧩 Task 3 – Deploy Full Application Stack

---

## ▶ Start Docker Compose Stack

```bash
docker compose up -d
```

---

## 📊 Verify Running Containers

```bash
docker compose ps
```

### Observed Services:

- api → Port 5000
- client → Port 4200
- webapi → Port 9000
- mysql → Port 3306
- mongo → Port 27017
- nginx → Port 80

All services status: **Up**

---

## 🌐 Application Health Check

```bash
curl -I http://localhost
```

### Response:

```
HTTP/1.1 200 OK
Server: nginx/1.29.4
```

✔ Application accessible via Nginx
✔ Reverse proxy functioning correctly

---

## 🧠 Concepts Learned

- Docker Compose service orchestration
- Port binding
- Service networking (default bridge network)
- Nginx reverse proxy validation
- Full stack deployment testing

---

# 🧠 Overall Concepts Learned in This Section

- Production-ready Dockerfile design
- Image size optimization strategies
- Before vs After comparison methodology
- Multi-container deployment
- Runtime verification
- DevOps deployment workflow

---

# 📸 Snapshots

Below are screenshots demonstrating image optimization and stack verification.

---

## 🖼 Image Listing (Latest)

![PR-1](snapshots/Production-Ready%20Dockerfile/1.png)

---

## 🖼 Docker Compose Running Stack

![PR-2](snapshots/Production-Ready%20Dockerfile/2.png)

---

## 🖼 WebAPI Before vs After

![PR-3](snapshots/Production-Ready%20Dockerfile/3.png)

---

## 🖼 API Before vs After

![PR-4](snapshots/Production-Ready%20Dockerfile/4.png)

---

# 🚀 Week 7 – Section 8

# 🐳 Secure Docker Containers

👨‍💻 **Nanosoft Technology – DevOps Internship**

🖥 Environment: Ubuntu 22.04 LTS (Vagrant VM)
🐳 Tools: Docker

---

## 📘 Objective

The objective of this task was to strengthen container security by:

- Running containers with **read-only filesystem**
- Using **tmpfs mounts** for temporary writable storage
- Applying **memory limits**
- Monitoring container resource usage
- Understanding container isolation & runtime restrictions

This lab focused on implementing **basic container hardening techniques** used in production environments.

---

# 🧩 Task 1 – Run Container with Read-Only Filesystem

---

## ▶ Run Alpine in Read-Only Mode

```bash
docker run --rm --read-only alpine sh -c "touch /testfile"
```

### Observed:

```
touch: /testfile: Read-only file system
```

✔ Container filesystem is protected
✔ No file modifications allowed

---

## 🧠 Concepts Learned

- `--read-only` flag prevents file writes
- Protects container from runtime tampering
- Useful for immutable production containers

---

# 🧩 Task 2 – Allow Temporary Writable Storage (tmpfs)

---

## ▶ Run with tmpfs Mount

```bash
docker run --rm \
  --read-only \
  --tmpfs /tmp \
  alpine sh -c "touch /tmp/test && echo tmp-ok"
```

### Observed:

```
tmp-ok
```

✔ `/tmp` writable
✔ Rest of filesystem remains read-only

---

## 🧠 Concepts Learned

- `--tmpfs` creates in-memory filesystem
- Data removed when container stops
- Improves security & performance
- Prevents disk persistence

---

# 🧩 Task 3 – Limit Container Memory

---

## ▶ Run Container with Memory Restriction

```bash
docker run --rm --memory=64m alpine sh -c "echo Memory limited"
```

### Observed:

```
Memory limited
```

✔ Container memory capped at 64MB

---

## 🧠 Concepts Learned

- `--memory` restricts RAM usage
- Prevents resource exhaustion
- Essential for multi-tenant environments
- Protects host stability

---

# 🧩 Task 4 – Monitor Container Resource Usage

---

## 📊 View Container Stats

```bash
docker stats --no-stream
```

### Observed Columns:

- CPU %
- MEM USAGE / LIMIT
- MEM %
- NET I/O
- BLOCK I/O
- PIDS

Example:

```
bridgeweb   12.14MiB / 2.899GiB   0.41%
hostweb     14.87MiB / 2.899GiB   0.50%
```

✔ Real-time resource monitoring
✔ Verified memory constraints applied

---

## 🧠 Concepts Learned

- Monitoring runtime metrics
- Memory vs CPU usage
- Network I/O tracking
- Block I/O statistics
- Container process count (PIDS)

---

# 🧠 Overall Concepts Learned in Secure Containers

- Immutable container design
- Filesystem protection
- Temporary writable layers
- Memory isolation
- Resource governance
- Runtime monitoring
- Basic container hardening

---

# 📸 Snapshots

Below are screenshots demonstrating container security and monitoring.

---

## 🖼 Read-Only Filesystem Test

![Secure-1](snapshots/Secure%20Docker%20Containers/1.png)

---

## 🖼 tmpfs Writable Test

![Secure-2](snapshots/Secure%20Docker%20Containers/2.png)

---

## 🖼 Docker Stats Monitoring

![Secure-3](snapshots/Secure%20Docker%20Containers/3.png)

---

# ✅ Outcome

Successfully implemented:

✔ Read-only container filesystem
✔ Temporary in-memory writable directory
✔ Memory resource limitation
✔ Runtime container monitoring

This demonstrates foundational **Docker security best practices** required for production-grade deployments.

---
