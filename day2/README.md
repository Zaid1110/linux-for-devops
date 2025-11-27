# Day 2 — File & Process Management, Package Management, Service Troubleshooting

This folder contains Day 2 work focused on practical Linux tasks used daily by DevOps engineers:
- file and directory permissions (deeper)
- process management and inspection
- package management (apt)
- service troubleshooting (systemctl + logs)
- a mini automation project: `disk_monitor.sh` (automated disk usage monitor + alert/cleanup behavior)

The goal is to practice commands for diagnosing overloaded servers, automating remedial actions and safely testing those actions on an EC2/VM instance.

## What is included

- `commands.md` — all Day 2 commands with short explanations and expected outputs.
- `summary.md` — quick notes on what I learned and next steps.
- `disk_monitor.sh` — the Day 2 mini project: disk monitoring and automated cleanup/alert script.
- `screenshots/` — (add your evidence here after running scripts on an instance).

## Mini Project (Disk Monitor) — short description

Disk usage is a common production issue. This script:
- checks disk usage for each mounted filesystem,
- logs current usage,
- if a filesystem crosses a safety threshold (e.g. 85%), it:
  - rotates or deletes files in a specified temp folder (configurable),
  - writes a structured event to a log file,
  - (optional) sends an alert via `mail` or outputs to console.

The script is intentionally simple to demonstrate the automation concept; in a production environment the same pattern is implemented with monitoring tools (Prometheus/CloudWatch) + remediation runbooks or Lambda functions.

## How to run (on Ubuntu EC2 / Ubuntu 22.04)

1. Make script executable:
```bash
chmod +x disk_monitor.sh

2. Run manually to test:
./disk_monitor.sh --threshold 85 --dry-run

3. To enable periodic checks, add to cron (example runs every 10 minutes):
(crontab -l 2>/dev/null; echo "*/10 * * * * /linux-for-devops/day2/disk_monitor.sh --threshold 85 >> /linux-for-devops/day2/screenshots/disk_monitor.log 2>&1") | crontab -



NOTE: The script supports --dry-run so it lists actions without deleting files. Use dry-run while testing.

---

