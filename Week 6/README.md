# 🚀 Week 6 – Jenkins CI/CD Deployment on Ubuntu & Windows

👨‍💻 **Nanosoft Technology – DevOps Internship**

🖥 Environment:

- Ubuntu 22.04 LTS (Vagrant VM)
- Windows 10
- Jenkins (Local Installation)
- Static Web Application (Parallax Template)

---

## 📘 Objective

The objective of Week 6 was to implement CI/CD fundamentals by:

- Installing Jenkins on Ubuntu & Windows
- Creating build jobs
- Stopping, modifying & restarting builds
- Deploying a static web application
- Hosting application on **Port 3000**
- Automating deployment using Jenkins
- Validating deployment via browser & console

This week introduced real-world CI/CD automation concepts essential for DevOps engineering.

---

# 🧩 Task 1 – Jenkins Setup & Build Lifecycle

---

## 📦 Jenkins Installation (Ubuntu)

### Verify Jenkins Service

```bash
sudo systemctl status jenkins
```

Observed:

- Jenkins service active (running)
- Java process active
- Listening on port 8080

---

## 📦 Jenkins Installation (Windows)

- Installed Jenkins service
- Verified from Windows Services panel
- Accessed Jenkins dashboard:

```
http://localhost:8080
```

---

## ▶ Create Jenkins Job

Created Job:

```
local-tooplate-deploy
```

### Trigger Build

- Clicked **Build Now**
- Verified console output

Console Output:

```
Started by user DevOps-Intern
[Pipeline] Start of Pipeline
[Pipeline] End of Pipeline
Finished: SUCCESS
```

---

## 🔁 Stop → Modify → Restart Build

- Executed multiple builds (#11, #27 etc.)
- Restarted from stage
- Modified configuration
- Re-ran pipeline successfully

Verified:

- Build lifecycle management
- Re-triggering pipeline
- Successful execution after changes

---

## 🧠 Concepts Learned

- Jenkins service architecture
- CI/CD pipeline basics
- Build lifecycle
- Restart from stage
- Pipeline console debugging
- Build success/failure validation

---

# 🧩 Task 2 – Deploy Static Web Application (Port 3000)

---

## 🌐 Application Used

Template:

```
Parallax Depth Template
```

Files Included:

- index.html
- CSS & JS assets
- Static content files

---

## 🖥 Ubuntu Deployment

### Run Static Server

```bash
python3 -m http.server 3000 --bind 0.0.0.0
```

Verified:

- Server started successfully
- Port 3000 active
- Browser accessible

---

### Verify Service & Port

```bash
ss -tuln | grep 3000
```

Confirmed:

```
LISTEN 0.0.0.0:3000
```

---

## 📂 Production-Style Release Deployment (Ubuntu)

Implemented release-based structure:

```
/var/www/html/
    ├── current -> releases/10
    ├── releases/
          ├── 9
          ├── 10
          ├── 11
```

Learned:

- Symbolic links
- Versioned releases
- Production deployment pattern

---

## 🖥 Windows Deployment

- Jenkins deployed files to project directory
- Static server running on port 3000
- Browser accessed:

```
http://localhost:3000
```

Website rendered successfully.

---

## 🔎 Jenkins Console Verification

Observed in Console Output:

```
BUILD STEP: COPY FILES
BUILD STEP: DEPLOY
Website: http://localhost:3000
Finished: SUCCESS
```

Confirmed:

- Files copied successfully
- Deployment successful
- No errors in pipeline

---

## 🧠 Concepts Learned

- Static web deployment
- Port binding
- Cross-platform deployment
- CI/CD automation flow
- Symbolic linking for releases
- File copy automation via Jenkins
- Browser validation of deployment

---

# 🧩 Task 3 – Build Validation & Multi-Platform Testing

---

## 🌍 Browser Validation (Ubuntu & Windows)

Verified website loads:

```
Parallax Depth
Immersive Multi-layer Scrolling Experience
```

Tested on:

- Ubuntu VM
- Windows host machine

---

## 🔄 Multiple Build Iterations

- Executed several builds
- Verified new release directories created
- Confirmed deployment path updated
- Validated symbolic link switching

---

## 🧠 Concepts Learned

- Continuous Deployment flow
- Release versioning
- Deployment consistency
- CI/CD monitoring
- Infrastructure validation

---

# 🧠 Concepts Learned in Week 6

- Jenkins installation & configuration
- CI/CD fundamentals
- Build lifecycle control
- Pipeline execution
- Static web deployment
- Port 3000 hosting
- Ubuntu vs Windows deployment differences
- Release-based deployment model
- Symbolic link usage
- Build verification & debugging

---

# 📸 Snapshots

Below are screenshots from each task demonstrating execution and verification.

---

## 🖼 Jenkins Setup & Builds

![1](Week 6/images/1.png)
![2](Week 6/images/2.png)
![3](Week 6/images/3.png)
![4](Week 6/images/4.png)
![5](Week 6/images/5.png)
![6](Week 6/images/6.png)

---

## 🖼 Deployment on Ubuntu

![7](Week 6/images/7.png)
![8](Week 6/images/8.png)
![9](Week 6/images/9.png)
![10](Week 6/images/10.png)
![11](Week 6/images/11.png)
![12](Week 6/images/12.png)

---

## 🖼 Windows Deployment & Validation

![13](Week 6/images/13.png)
![14](Week 6/images/14.png)
![15](Week 6/images/15.png)
![16](Week 6/images/16.png)
![17](Week 6/images/17.png)
![18](Week 6/images/18.png)

---
