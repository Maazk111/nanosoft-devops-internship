# 🚀 Week 4 – LAMP Stack & WordPress Multi-VM Deployment

👨‍💻 **Nanosoft Technology – DevOps Internship**

🖥 Environment: Ubuntu 22.04 LTS (Vagrant Multi-Machine Setup)

---

## 📘 Objective

The objective of Week 4 was to implement a complete **multi-VM LAMP architecture** with:

* Multi-machine Vagrant configuration
* Apache Virtual Host configuration
* WordPress deployment on multiple instances
* PHP multi-version configuration (7.4 & 8.2)
* Local DNS simulation via `/etc/hosts`
* WordPress migration using a Bash automation script

This week focused on real-world web infrastructure deployment and automation.

---

# 🧩 Task 1 – Creation of Virtual Machines

---

## 🖥 Multi-Machine Setup

Created two Ubuntu VMs using Vagrant:

* `wp1`
* `wp2`

Verified machine status:

```bash
vagrant status
```

Verified private IP configuration:

```bash
vagrant ssh wp1 -c "hostname -I"
vagrant ssh wp2 -c "hostname -I"
```

Private IPs:

* wp1 → 192.168.56.10
* wp2 → 192.168.56.11

---

## 🧠 Concepts Learned

* Vagrant multi-machine architecture
* Private networking configuration
* Service verification across multiple VMs

---

# 🧩 Task 2 – Setup LAMP Stack

---

## 📦 Install Apache, MySQL & PHP

On both VMs:

```bash
apt update
apt install apache2 mysql-server php libapache2-mod-php -y
```

Verified services:

```bash
systemctl status apache2
systemctl status mysql
```

Confirmed Apache by loading default Ubuntu page in browser.

---

## 🧠 Concepts Learned

* LAMP stack architecture
* Service lifecycle management
* Web server verification
* Database service configuration

---

# 🧩 Task 3 – WordPress Installation on Both VMs

---

## 📥 WordPress Setup

Steps performed:

1. Created MySQL database
2. Created DB user with privileges
3. Downloaded WordPress
4. Configured `wp-config.php`
5. Set file permissions
6. Restarted Apache

Successfully accessed WordPress setup and dashboard.

---

## 🌐 WordPress Instances Created

On wp1:

* site1_wp1.local
* site2_wp1.local

On wp2:

* site1_wp2.local
* site2_wp2.local

Each site running independently.

---

## 🧠 Concepts Learned

* Database-driven application deployment
* WordPress configuration structure
* File permissions & ownership
* Multi-instance hosting

---

# 🧩 Task 4 – Apache Virtual Hosts (VHOST)

---

## 🌐 Create Virtual Host Files

Location:

```
/etc/apache2/sites-available/
```

Each VHOST configured with:

* ServerName
* DocumentRoot
* Directory permissions

Enabled sites:

```bash
a2ensite site1.conf
a2ensite site2.conf
systemctl reload apache2
```

---

## 🧾 Local DNS Mapping

Configured `/etc/hosts` on host machine:

```bash
192.168.56.10 site1_wp1.local
192.168.56.10 site2_wp1.local
192.168.56.11 site1_wp2.local
192.168.56.11 site2_wp2.local
```

This enabled domain-based access instead of IP-based access.

---

## 🧠 Concepts Learned

* Apache VHOST architecture
* Domain routing using hosts file
* Multi-site hosting on single server
* Apache site enable/disable workflow

---

# 🧩 Task 5 – PHP Version Configuration

---

Installed two PHP versions:

* PHP 7.4
* PHP 8.2

Configured VHOSTs to use specific PHP versions.

Verified using:

```bash
php -v
```

Also confirmed using `phpinfo()` in browser.

Successfully isolated:

* site1 → PHP 7.4
* site2 → PHP 8.2

---

## 🧠 Concepts Learned

* Multi-PHP environment management
* Version isolation per VHOST
* Compatibility handling in web hosting

---

# 🧩 Task 6 – WordPress Migration Automation Script

---

## 🔁 Migration Script Workflow

Created a Bash script to migrate WordPress database from wp1 to wp2.

### Steps:

### 1️⃣ Export Database

```bash
mysqldump wp_site1 > /tmp/site1.sql
```

---

### 2️⃣ Transfer Dump

Used Vagrant upload to move SQL file.

---

### 3️⃣ Import Database on wp2

```bash
mysql wp_site1 < /tmp/site1.sql
```

---

### 4️⃣ Verification

Confirmed migration completed successfully.

Script output:

```
Migration completed successfully
```

---

## 🧠 Concepts Learned

* mysqldump usage
* Database export & import
* Automation using Bash
* Cross-VM data migration
* Infrastructure scripting

---

# 🧠 Concepts Learned in Week 4

* Multi-machine Vagrant deployment
* LAMP stack architecture
* WordPress multi-instance hosting
* Apache Virtual Hosts
* Local DNS configuration
* PHP multi-version setup
* Database migration
* Infrastructure automation
* Real-world web hosting fundamentals

---

# 📸 Snapshots

Below are screenshots demonstrating configuration and verification.

---

## 🖼 Task 1 – VM Setup

![Task1-1](Week 4/images/1.png)
![Task1-2](Week 4/images/2.png)
![Task1-3](Week 4/images/3.png)

---

## 🖼 Task 2 – LAMP Setup

![Task2-1](Week 4/images/4.png)

---

## 🖼 Task 3 – WordPress Installation

![Task3-1](Week 4/images/5.png)
![Task3-2](Week 4/images/6.png)
![Task3-3](Week 4/images/7.png)
![Task3-4](Week 4/images/8.png)
![Task3-5](Week 4/images/9.png)
![Task3-6](Week 4/images/10.png)
![Task3-7](Week 4/images/11.png)

---

## 🖼 Task 4 – Virtual Hosts & DNS Mapping

![Task4-1](Week 4/images/12.png)

---

## 🖼 Task 5 – Migration Script

![Task5-1](Week 4/images/13.png)
![Task5-2](Week 4/images/14.png)

---

## 🖼 Task 6 – PHP Version Verification

![Task6-1](Week 4/images/15.png)
![Task6-2](Week 4/images/16.png)

---

