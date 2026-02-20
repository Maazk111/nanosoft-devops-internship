# 🚀 Week 1 – Linux Fundamentals & System Administration

👨‍💻 **Nanosoft Technology – DevOps Internship**  
🖥 Environment: Ubuntu VM (Vagrant)

---

## 📘 Objective

The objective of Week 1 was to build a strong foundation in Linux fundamentals, including:

- File and directory management
- User and group administration
- File permissions
- System monitoring commands
- Text editors (Nano & Vim)
- Basic shell scripting

This week established the core system-level knowledge required for DevOps and system administration.

---

# 🧩 Task 1 – Linux Basic Commands & File Operations

## 📂 Directory Navigation

```bash
cd /etc/
pwd
cd ~
cd /
ls -l
```

### Concepts Covered:

- Filesystem hierarchy (`/`, `/etc`, `/home`)
- Absolute vs relative paths
- Root vs normal user

---

## 📁 Directory & File Management

### Create and Remove Directory

```bash
mkdir task1
cd task1
pwd
cd ..
rmdir task1
```

---

### Create Multiple Files (Brace Expansion)

```bash
mkdir devops
cd devops
touch aws{1..3}.txt
```

Created:

```
aws1.txt
aws2.txt
aws3.txt
```

---

## ✍ Writing & Reading File Content

```bash
echo "Hello I am Muhammad Maaz Khan" > aws1.txt
echo "it my first task in Nanosoft technology" >> aws1.txt
echo "DevOps Intern" >> aws1.txt
cat aws1.txt
```

### Learned:

- `>` (overwrite)
- `>>` (append)
- `cat` for reading files

---

## 📦 Copy, Move & Remove Files

```bash
cp aws1.txt ~/
mv aws1.txt ~/snap/
rm aws1.txt
```

---

## 📜 System Utilities

```bash
history
man ls
clear
```

---

# 👥 Task 2 – User & Group Management

## 👤 Creating Users

```bash
useradd ansible
useradd jenkins
useradd terraform
```

Verify:

```bash
cat /etc/passwd | tail -10
```

---

## 👥 Creating Groups

```bash
groupadd devops
cat /etc/group | tail -5
```

---

## 🔗 Modifying Group Membership

### Add Secondary Group

```bash
usermod -aG devops ansible
id ansible
```

### Change Primary Group

```bash
usermod -g devops jenkins
id jenkins
```

---

## 🔐 Password Configuration

```bash
passwd ansible
su - ansible
whoami
```

---

## 🏠 Home Directory Setup

```bash
mkdir /home/ansible
chown ansible:ansible /home/ansible
```

---

## ❌ User & Group Deletion

```bash
userdel jenkins
userdel -r ansible
groupdel jenkins
```

Verified using:

```bash
cat /etc/passwd
cat /etc/group
```

---

## 📝 Text Editor Practice (Nano)

```bash
nano editors.txt
cat editors.txt
cat -n editors.txt
```

### Concepts Covered:

- File editing
- Saving & exiting
- Line numbering
- Text modification

---

# 🗂 Task 3 – Project Structure, Permissions & Shell Scripting

## 📁 Create Project Directory Structure

```bash
mkdir -p /home/Maaz/projects/week1
cd /home/Maaz/projects/week1
```

---

## 📄 Create Files

```bash
touch file{1..3}.txt
```

Add content:

```bash
echo "DevOps Engineer" > file1.txt
echo "Software Engineer" > file2.txt
echo "SQA Engineer" > file3.txt
```

---

## 🔐 File Permissions

```bash
chmod 600 file1.txt
chmod 600 *
ls -ltr
```

### Permission Meaning:

```
600 = rw-------
Only owner can read & write
```

---

## 📊 System Monitoring Commands

```bash
date
uptime
whoami
df -h
free -m
```

These commands provide:

- Current date & time
- System uptime & load
- Logged-in user
- Disk usage
- Memory usage

---

# 🖥 Shell Script Creation

Created `task.sh`:

```bash
#!/bin/bash

echo "Todays Date is $(date)"
echo "The Logged In user is : $(whoami)"
echo "Disk usage is : $(df -h)"
echo "Uptime is $(uptime)"
echo "free Ram Space is $(free -m)"
```

Make executable:

```bash
chmod 700 task.sh
```

Run:

```bash
./task.sh
```

---

## 🔎 Output Verified

Script successfully displayed:

- Date
- Logged-in user
- Disk usage
- System uptime
- Memory usage

---

# 🧠 Key Concepts Learned in Week 1

- Linux filesystem hierarchy
- Root vs non-root users
- File permissions & ownership
- User & group administration
- Primary vs secondary groups
- Home directory management
- Command history & manual pages
- System resource monitoring
- Bash scripting fundamentals
- Script execution & permissions

---

# 📸 Snapshots

Below are screenshots from each task demonstrating execution and output.

## 🖼 Task 1 – Basic Commands

![Task1-1](Task 1/1.png)
![Task1-2](Task 1/2.png)
![Task1-3](Task 1/3.png)
![Task1-4](Task 1/4.png)
![Task1-5](Task 1/5.png)
![Task1-6](Task 1/6.png)
![Task1-7](Task 1/7.png)
![Task1-8](Task 1/8.png)

---

## 🖼 Task 2 – User & Group Management

![Task2-1](Task 2/1.png)
![Task2-2](Task 2/2.png)
![Task2-3](Task 2/3.png)
![Task2-4](Task 2/4.png)
![Task2-5](Task 2/5.png)
![Task2-6](Task 2/6.png)
![Task2-7](Task 2/7.png)
![Task2-8](Task 2/8.png)
![Task2-9](Task 2/9.png)
![Task2-10](Task 2/10.png)

---

## 🖼 Task 3 – Shell Script & Permissions

![Task3-1](Task 3/1.png)
![Task3-2](Task 3/2.png)
![Task3-3](Task 3/3.png)
![Task3-4](Task 3/4.png)

---
