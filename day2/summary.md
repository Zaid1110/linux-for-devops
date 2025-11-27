## Completed tasks:

- Practiced file ownership and permission models; experimented with chmod, chown, umask.
- Inspected and managed processes with ps, top, and systemctl.
- Performed package updates and installs with apt.
- Practiced disk inspection (df, du) and located large log files.
- Implemented disk_monitor.sh and tested with --dry-run to avoid accidental deletions.
- Added cron example for periodic checks.

## Key takeaways:
- File permissions prevent accidental access; know how to apply least privilege.
- Systemd/logs + journalctl are the first place to look for service problems.
- Disk space is a recurring production problem — automation and good log rotation policies matter.
- Always test destructive automation in --dry-run mode before enabling it in cron.
---
