## File & Permission Commands

- sudo chown ubuntu:ubuntu /path/to/file     # change owner
- sudo chown -R ubuntu:ubuntu /path/to/dir   # recursive owner change
- chmod 644 file.txt                         # owner rw, group r, others r
- chmod 750 script.sh                        # owner rwx, group rx, others none
- umask                                      # default permission mask


## Process Management

- ps aux | grep nginx                        # list processes related to nginx
- top                                        # interactive process viewer
- htop (if installed)                        # richer top
- pstree                                     # process tree
- kill PID                                   # send SIGTERM
- kill -9 PID                                # send SIGKILL (force)
- sudo systemctl status <service>            # check systemd service status
- sudo systemctl restart <service>           # restart a service
- sudo systemctl daemon-reload               # reload unit files

## Package Management (Ubuntu)

- sudo apt update
- sudo apt upgrade -y
- sudo apt install -y nginx git curl vim
- Disk Commands
- df -h                                      # disk usage human readable
- du -sh /var/log/* | sort -h                # size of folders, sorted
- ls -lSh /var/log | head -n 20              # biggest log files
- find /var/log -type f -mtime +30           # find logs older than 30 days
- Logs & Troubleshooting
- sudo journalctl -u nginx.service -n 200 --since "1 hour ago"
- sudo tail -n 200 /var/log/syslog
- sudo tail -f /var/log/syslog               # live log tailing

## Networking quick checks

- ss -tulpn                                  # listening sockets
- netstat -tulpn                             # same as above (older systems)
- Useful utilities
- nc -zv host 22                             # check port connectivity
- strace -p PID                              # trace system calls of a running process

---
