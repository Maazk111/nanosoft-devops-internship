# 🚀 Week 3 – Storage Management, System Monitoring & Security Hardening

👨‍💻 **Nanosoft Technology – DevOps Internship**

🖥 Environment: Ubuntu 22.04 LTS (Vagrant VM & AWS EC2)

---

## 📘 Objective

The objective of Week 3 was to build hands-on expertise in:

* Process & port inspection
* System monitoring tools
* AWS EBS volume management
* Filesystem formatting & mounting
* Persistent storage configuration
* Environment variable management
* Firewall configuration using UFW

This week focused heavily on **real-world infrastructure operations and server security basics.**

---

# 🧩 Task 1 – Nginx Process & Port Inspection

---

## 🔎 Identify Running Processes

```bash
pgrep nginx
ps aux | grep nginx
```

Observed:

* Master process running as `root`
* Worker processes running as `www-data`

---

## ⏹ Stop Service

```bash
pkill nginx
systemctl status nginx
```

Verified service became:

```
inactive (dead)
```

---

## ▶ Restart Service

```bash
systemctl restart nginx
systemctl status nginx
```

Observed:

```
Active: active (running)
```

---

## 🔌 Check Listening Ports

```bash
ss -tulpn
ss -tuln | grep :80
```

Confirmed:

* Nginx listening on Port 80
* Apache running on Port 8080

---

## 🧠 Concepts Learned

* Process ownership (root vs www-data)
* systemctl service lifecycle
* Port binding verification
* TCP listening states

---

# 🧩 Task 2 – AWS EBS Volume & Persistent Mount

---

## 📦 Verify Attached Disk

```bash
lsblk
fdisk -l
```

Detected new disk:

```
/dev/xvdf
```

---

## 🛠 Format Disk

```bash
mkfs.ext4 /dev/xvdf
```

Filesystem successfully created.

---

## 📂 Mount Volume

```bash
mkdir /mnt/data
mount /dev/xvdf /mnt/data
df -h
```

Verified mount point.

---

## 🔑 Get UUID

```bash
blkid /dev/xvdf
```

Copied UUID for persistence.

---

## 📝 Configure fstab

Edited:

```bash
vim /etc/fstab
```

Added:

```bash
UUID=<UUID>  /mnt/data  ext4  defaults,nofail  0  2
```

---

## 🔄 Test Persistence

```bash
reboot
df -h
```

Volume auto-mounted after reboot ✅

---

## 🧪 Write Test File

```bash
echo "Hello from Maaz | DevOps Engineer" > test.txt
cat test.txt
```

Confirmed data stored on mounted EBS volume.

---

## 🧠 Concepts Learned

* EBS lifecycle
* Filesystem formatting
* Mount vs persistent mount
* UUID-based storage configuration
* Linux boot mount sequence

---

# 🧩 Task 3 – System Monitoring & Performance Analysis

---

## 🖥 Real-Time Monitoring

```bash
top
htop
```

Observed:

* CPU utilization
* Memory usage
* Running processes

---

## 📊 Memory & Load Monitoring

```bash
uptime
free -m
vmstat 1
```

Learned:

* Load average interpretation
* Swap usage
* CPU idle percentage
* Buffers & cache usage

---

## 💽 Disk I/O Analysis

```bash
iostat -xz 1
iotop
```

Observed:

* Disk read/write speed
* Await time
* Disk utilization %

---

## 📂 Filesystem & Logs

```bash
df -h
du -sh /var/log/*
```

Learned:

* Root filesystem usage
* Log size tracking
* Storage monitoring

---

## 🧠 Concepts Learned

* CPU idle vs usage
* Disk bottleneck detection
* I/O wait understanding
* Linux performance analysis tools
* Log size auditing

---

# 🧩 Task 4 – Environment Variables

---

## 🌍 Temporary Environment Variable

```bash
export PROJECT=DevOps
env | grep PROJECT
```

---

## 💾 Persistent Environment Variables

Edited `.bashrc`:

```bash
export APP_ENV=production
export DB_HOST=localhost
```

Reloaded:

```bash
source ~/.bashrc
```

Verified:

```bash
env | grep APP_ENV
env | grep DB_HOST
```

---

## 🧠 Concepts Learned

* Temporary vs persistent variables
* Shell initialization files
* Environment configuration management

---

# 🧩 Task 5 – UFW Firewall Configuration

---

## 🔥 Install & Configure UFW

```bash
apt install ufw -y
ufw allow ssh
ufw allow 80
ufw allow 443
ufw enable
```

---

## 📊 Verify Firewall Rules

```bash
ufw status verbose
```

Allowed:

* 22/tcp (SSH)
* 80 (HTTP)
* 443 (HTTPS)

---

## 🔌 Verify Open Ports

```bash
ss -tuln
ss -tuln | grep :80
```

---

## 🧪 Connectivity Test

```bash
nc -zv localhost 80
```

Connection successful ✅

---

## 🧠 Concepts Learned

* Basic firewall security
* Port-based access control
* TCP connectivity testing
* Securing Linux servers

---

# 🧠 Concepts Learned in Week 3

* Process & port inspection
* AWS EBS volume management
* Filesystem persistence via fstab
* Linux performance monitoring
* Disk I/O analysis
* Environment variable management
* Firewall configuration & server security

---

# 📸 Snapshots

Below are screenshots from each task demonstrating execution and verification.

---

## 🖼 Task 1 – Nginx Management

![Task1-1](Task%201/1.png)
![Task1-2](Task%201/2.png)
![Task1-3](Task%201/3.png)

---

## 🖼 Task 2 – EBS Volume & Mount

![Task2-1](Task%202/1.png)
![Task2-2](Task%202/2.png)
![Task2-3](Task%202/3.png)
![Task2-4](Task%202/4.png)
![Task2-5](Task%202/5.png)
![Task2-6](Task%202/6.png)

---

## 🖼 Task 3 – Monitoring & Performance

![Task3-1](Task%203/1.png)
![Task3-2](Task%203/2.png)
![Task3-3](Task%203/3.png)
![Task3-4](Task%203/4.png)
![Task3-5](Task%203/5.png)
![Task3-6](Task%203/6.png)
![Task3-7](Task%203/7.png)
![Task3-8](Task%203/8.png)
![Task3-9](Task%203/9.png)
![Task3-10](Task%203/10.png)
![Task3-11](Task%203/11.png)
![Task3-12](Task%203/12.png)

---

## 🖼 Task 4 & 5 – Environment & Firewall

![Task4-1](Task%204%20%26%205/1.png)
![Task4-2](Task%204%20%26%205/2.png)
![Task4-3](Task%204%20%26%205/3.png)
![Task4-4](Task%204%20%26%205/4.png)
![Task4-5](Task%204%20%26%205/5.png)
![Task4-6](Task%204%20%26%205/6.png)
![Task4-7](Task%204%20%26%205/7.png)

---