# 🚀 Nanosoft Technology DevOps Internship — 7 Week DevOps Lab Series
## 📊 Internship Roadmap Overview

![Internship Board](./Tasks.png)
## 📘 Internship Overview

This repository documents my **7-Week DevOps Internship at Nanosoft Technology**, covering core Linux fundamentals, virtualization, databases, CI/CD, containerization, Docker security, networking, volumes, and production-ready Docker practices.

Each week was implemented in a **hands-on lab environment using Vagrant, Linux, Docker, and automation scripts**, simulating real-world DevOps infrastructure and production scenarios.

The journey reflects a structured transition from:

> 🖥️ Linux Basics → 🏗️ Virtual Machines → 🛠️ DevOps Tooling → 🐳 Docker → 🔐 Secure & Production Containers

---

## 💡 Practical Experience Gained

- Linux administration & system management
- Virtual machine provisioning using Vagrant
- LAMP stack deployment
- MongoDB, Redis, and RabbitMQ installation
- Jenkins CI/CD pipeline setup
- Docker multi-container applications
- Docker networking deep dive
- Secure container practices
- Docker volumes & backup strategies
- Production-ready Dockerfile optimization
- Container monitoring & logging
- Resource limiting & runtime security

---

## 🧱 Architecture Summary

| 🧩 Week    | 🎯 Focus Area          | 🛠️ Core Technologies                                   | 📁 Folder |
| ---------- | ---------------------- | ------------------------------------------------------ | --------- |
| **Week 1** | Linux Fundamentals     | Bash • Permissions • Editors • File System             | `Week 1`  |
| **Week 2** | System & Networking    | Package Mgmt • Disk • Memory • Networking              | `Week 2`  |
| **Week 3** | Process & Storage      | Monitoring • Environment Variables • Firewall          | `Week 3`  |
| **Week 4** | Virtualization & LAMP  | Vagrant • Apache • MySQL • WordPress                   | `Week 4`  |
| **Week 5** | Databases & Queues     | MongoDB • Redis • RabbitMQ                             | `Week 5`  |
| **Week 6** | CI/CD & Web Deployment | Jenkins • Windows + Ubuntu Deployment                  | `Week 6`  |
| **Week 7** | Docker Mastery         | Dockerfile • Compose • Networking • Security • Volumes | `Week 7`  |

---

# 🧩 Week Highlights

---

## 🟢 Week 1 — Linux Fundamentals

- Basic Linux commands
- File permissions & ownership
- vi / nano editors
- Directory structure understanding
- Shell navigation & scripting basics

📌 Foundation for all DevOps operations.

---

## 🟢 Week 2 — System & Networking

- Package management (apt/yum)
- System information commands
- Disk & memory management
- Networking basics
- IP, DNS, ping, netstat
- Firewall introduction

📌 Understanding how systems communicate and manage resources.

---

## 🟢 Week 3 — Process & Storage Management

- Process management (`ps`, `top`, `htop`)
- CPU & memory monitoring
- Mounting storage devices
- Environment variables
- Networking & firewall configuration

📌 System-level operational awareness.

---

## 🟢 Week 4 — Virtualization & LAMP Stack

- Vagrant VM provisioning
- Apache installation
- MySQL setup
- PHP configuration
- WordPress deployment
- Virtual hosts (VHOST)

📌 Full-stack web server deployment from scratch.

---

## 🟢 Week 5 — Database & Messaging Systems

- MongoDB installation & configuration
- Redis setup
- RabbitMQ installation
- Service verification
- Systemd service management

📌 Backend infrastructure understanding.

---

## 🟢 Week 6 — CI/CD & Web Deployment

- Jenkins setup
- Build pipeline creation
- Multi-platform deployment (Windows + Ubuntu)
- Application build → stop → rebuild → restart
- Port configuration & service validation

📌 Automated deployment workflow.

---

# 🟢 Week 7 — Docker Deep Dive

---

## 1️⃣ Production-Ready Dockerfile

- Multi-stage builds
- Image size optimization
- Removing unnecessary dependencies
- Layer reduction
- Before vs After comparison

📊 Reduced image size significantly:

- API: 1.69GB → 221MB
- WebAPI: 1.01GB → 407MB

---

## 2️⃣ Docker Compose — Multi Container App

- MySQL
- MongoDB
- Nginx
- API
- WebAPI
- Client

Verified via:

```bash
docker compose ps
curl -I http://localhost
```

---

## 3️⃣ Docker Networking Deep Dive

- Bridge networks
- Custom networks
- Inter-container communication
- Inspecting networks
- IP allocation analysis

---

## 4️⃣ Secure Docker Containers

Implemented:

- `--read-only`
- `--tmpfs /tmp`
- `--memory=64m`
- Docker resource limiting
- docker stats monitoring

Verified security using:

```bash
docker run --rm --read-only alpine sh -c "touch /testfile"
```

Output:

```
Read-only file system
```

---

## 5️⃣ Docker Volumes & Backup

- Named volumes
- Volume inspection
- Database backup (.sql + .tar.gz)
- Remote backup transfer
- Restore verification
- Data persistence testing

Verified using SQL query:

```sql
SELECT * FROM students ORDER BY id;
```

---

## 6️⃣ Docker Logs & Monitoring

- Container logs inspection
- docker logs
- docker stats
- CPU & memory tracking

---

## 7️⃣ Docker + CI/CD

- Build image
- Tag image
- Run container
- Validate service
- Restart container with updated build

---

## 🆕 Additional Learning & Responsibilities

- Production debugging mindset
- Disk space troubleshooting
- Log analysis
- Container cleanup
- Image optimization strategies
- System resource tuning
- Security-first container deployment

---

## 🧠 Skills & Technologies Demonstrated

| Category       | Stack                        |
| -------------- | ---------------------------- |
| Linux          | Bash • Systemd • Networking  |
| Virtualization | Vagrant                      |
| Databases      | MySQL • MongoDB • Redis      |
| Messaging      | RabbitMQ                     |
| CI/CD          | Jenkins                      |
| Containers     | Docker • Docker Compose      |
| Security       | Read-only FS • Memory Limits |
| Monitoring     | docker stats • logs          |

---

## ⚙️ General Setup Workflow

```bash
# Start VM
vagrant up

# Enter VM
vagrant ssh

# Run containers
docker compose up -d

# Check running containers
docker ps

# Monitor stats
docker stats --no-stream

# Cleanup
docker compose down
vagrant destroy -f
```

---

## 🧾 Reflection

This 7-week DevOps internship provided a structured and progressive learning journey from Linux fundamentals to production-ready container deployment.

It strengthened my:

- Infrastructure automation mindset
- Container optimization techniques
- Security-first deployment approach
- CI/CD pipeline understanding
- System-level troubleshooting skills

Each week built upon the previous one transforming theoretical knowledge into practical, production-like implementation.

---