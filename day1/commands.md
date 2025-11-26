# Day 1 Commands — Linux for DevOps

This file documents all commands I practiced on Day 1, along with simple explanations.

---

## 📂 Navigation Commands
- pwd         # show current directory
- ls -lah     # list files with permissions, size, and hidden files
- cd /etc     # move to /etc
- cd /var/log # move to log directory


---

## 👤 User & Group Management
- whoami                           # show current user
- sudo adduser devopsuser          # create a new user
- sudo passwd devopsuser           # set password
- sudo usermod -aG sudo devopsuser # give sudo access
- id devopsuser                    # check user groups


---

## 🔐 Permissions
- ouch testfile.txt        # create file
- ls -l testfile.txt       # check file permissions
- chmod 600 testfile.txt   # owner read/write
- chmod 744 testfile.txt   # owner rwx, others read


---

## 📜 Log Files
- cd /var/log
- sudo tail -n 20 syslog
- sudo tail -n 20 auth.log


---

## 🛠 Service Management
- sudo systemctl status ssh
- sudo systemctl restart ssh
- sudo systemctl status ufw


---

## 🌐 Networking Tools
- ip a # view network interfaces
- ip route # view routing table
- ping google.com
- curl http://google.com
- nslookup google.com


---

## 🧪 Script Execution
- chmod +x system_health.sh
- ./system_health.sh


This completes the list of all commands practiced on Day 1.

