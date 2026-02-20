# 🚀 Week 2 – Linux System Monitoring, Networking & Web Services

👨‍💻 **Nanosoft Technology – DevOps Internship**

🖥 Environment: Ubuntu 22.04 LTS (Vagrant VM)

---

## 📘 Objective

The objective of Week 2 was to deepen system-level knowledge by focusing on:

- Package management (APT & DPKG)
- Kernel & OS information
- Process management
- Service management (systemctl)
- Networking commands
- Port monitoring
- Web server configuration (Nginx & Apache)
- Log monitoring & troubleshooting

This week built real-world troubleshooting and infrastructure-level debugging skills essential for DevOps engineering.

---

# 🧩 Task 1 – Package Management & System Updates

## 🔄 Update & Upgrade System

```bash
apt update
apt upgrade -y
```

### Verified:

- Repository sync
- Security updates applied
- Package upgrades completed

---

## 📦 Install & Remove Packages

### Install Git

```bash
apt install git
```

Verify:

```bash
dpkg -l | grep git
```

---

### Search & Inspect Packages

```bash
apt search jdk-17
dpkg -l | grep apt
```

---

### Remove Package

```bash
apt remove git
```

Verified removal using:

```bash
dpkg -l
```

---

## 🧠 Concepts Learned

- Difference between `apt` and `dpkg`
- Package installation lifecycle
- Automatic dependency handling
- Removing unused packages
- Linux package database inspection

---

# 🧩 Task 2 – System Monitoring & Process Management

---

## 🖥 System Information

```bash
uname -a
lsb_release -a
df -h
free -m
```

Learned:

- Kernel version
- Ubuntu release version
- Disk usage monitoring
- Memory usage tracking

---

## 📊 Real-Time Monitoring

### Using top

```bash
top
```

Observed:

- CPU usage
- Memory usage
- Running processes
- System load

---

### Using htop (Improved Monitoring)

```bash
htop
```

Learned:

- Interactive process filtering
- Sorting by CPU/memory
- Killing processes easily

---

## 🔎 Process Listing & Killing

```bash
ps aux
kill <PID>
pkill syslog
```

Observed:

- Process states (R, S, I, etc.)
- Process owner
- CPU & memory usage

---

## 🧠 Concepts Learned

- Linux process states
- Process IDs (PID)
- Killing vs gracefully stopping
- Foreground vs background processes
- System resource tracking

---

# 🧩 Task 3 – Networking & Connectivity

---

## 🌐 Network Configuration

```bash
ip addr
```

Learned:

- Interface names (enp0s3)
- IPv4 & IPv6 addresses
- Broadcast & subnet mask

---

## 📡 Connectivity Testing

```bash
ping -c 4 8.8.8.8
```

Verified:

- Internet connectivity
- Packet transmission
- Latency statistics

---

## 🔌 Port & Socket Monitoring

```bash
netstat -tuln
ss -tuln
```

Learned:

- Listening ports
- TCP vs UDP
- Local vs foreign addresses
- Service-port mapping

---

## 🌍 HTTP Testing

```bash
curl -i https://example.com
wget --server-response https://example.com
```

Verified:

- HTTP status codes (200 OK)
- Headers
- Content retrieval
- File download

---

## 🧠 Concepts Learned

- TCP & UDP basics
- Port listening states
- Service binding
- HTTP response inspection
- Command-line web testing

---

# 🧩 Task 4 – Nginx Web Server Management

---

## 📦 Install Nginx

```bash
apt install nginx -y
```

---

## ▶ Start & Enable Service

```bash
systemctl start nginx
systemctl enable nginx
```

---

## 📊 Check Service Status

```bash
systemctl status nginx
```

Observed:

- Active (running)
- Main PID
- Memory usage
- Worker processes

---

## ⏹ Stop Service

```bash
systemctl stop nginx
```

Verified service became:

```
inactive (dead)
```

---

## 🧠 Concepts Learned

- systemctl usage
- Service lifecycle (start, stop, enable)
- Service unit files
- Nginx architecture (master & worker processes)

---

# 🧩 Task 5 – Apache Installation & Log Monitoring

---

## 📦 Install Apache

```bash
apt install apache2 -y
```

---

## 🔍 Verify Installation

```bash
dpkg -l | grep apache2
systemctl status apache2
```

Observed:

- Apache running
- Service enabled
- Multiple worker processes

---

## 🔌 Check Listening Port

```bash
ss -tulnp | grep apache
```

Confirmed:

```
Port 8080 Listening
```

---

## 📜 Apache Logs

### View Logs

```bash
ls -lh /var/log/apache2/
```

### Monitor Logs in Real-Time

```bash
tail -f /var/log/apache2/access.log
tail -f /var/log/apache2/error.log
```

---

## 📂 Disk Usage Monitoring

```bash
du -sh /var/log/apache2/
du -sh /var/log
du -sh *
```

Learned:

- Log size tracking
- Disk consumption analysis
- Storage monitoring

---

## 🧠 Concepts Learned in Week 2

- Package management (APT & DPKG)
- Process monitoring
- System resource tracking
- Network diagnostics
- Port inspection
- HTTP testing tools
- Service management (systemctl)
- Web server deployment
- Log monitoring
- Infrastructure troubleshooting

---

# 📸 Snapshots

Below are screenshots from each task demonstrating execution and verification.

---

## 🖼 Task 1 – Package Management

![Task1-1](Task%201/1.png)
![Task1-2](Task%201/2.png)
![Task1-3](Task%201/3.png)
![Task1-4](Task%201/4.png)
![Task1-5](Task%201/5.png)
![Task1-6](Task%201/6.png)
![Task1-7](Task%201/7.png)

---

## 🖼 Task 2 – Monitoring & Processes

![Task2-1](Task%202/1.png)
![Task2-2](Task%202/2.png)
![Task2-3](Task%202/3.png)
![Task2-4](Task%202/4.png)
![Task2-5](Task%202/5.png)
![Task2-6](Task%202/6.png)
![Task2-7](Task%202/7.png)
![Task2-8](Task%202/8.png)
![Task2-9](Task%202/9.png)
![Task2-10](Task%202/10.png)

---

## 🖼 Task 3 & 4 – Networking & Nginx

![Task3-1](Task%203%20%26%204/1.png)
![Task3-2](Task%203%20%26%204/2.png)
![Task3-3](Task%203%20%26%204/3.png)
![Task3-4](Task%203%20%26%204/4.png)

---

## 🖼 Task 5 – Apache & Logs

![Task5-1](Task%205/1.png)
![Task5-2](Task%205/2.png)
![Task5-3](Task%205/3.png)
![Task5-4](Task%205/4.png)

---
