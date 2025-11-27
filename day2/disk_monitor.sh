#!/usr/bin/env bash
#
# disk_monitor.sh
# Simple disk usage monitor with optional cleanup of a defined directory.
# Usage examples:
#   ./disk_monitor.sh --threshold 85 --cleanup-dir /tmp/mycleanup --dry-run
#   ./disk_monitor.sh --threshold 90 --cleanup-dir /var/log/myapp
#
set -euo pipefail

# Defaults
THRESHOLD=85
CLEANUP_DIR=""
DRY_RUN=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCREENSHOT_DIR="$REPO_ROOT/day2/screenshots"
LOGFILE="$SCREENSHOT_DIR/disk_monitor_run.log"

# Ensure screenshots/log dir exists
mkdir -p "$SCREENSHOT_DIR"

usage() {
  cat <<EOF
Usage: $0 [--threshold N] [--cleanup-dir /path] [--dry-run] [--help]

Options:
  --threshold N       Alert threshold as percentage (default: $THRESHOLD)
  --cleanup-dir PATH  Directory where old files will be deleted when threshold exceeded
  --dry-run           Don't delete anything; only show what would be done
  --help              Show this help
EOF
  exit 1
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --threshold)
      THRESHOLD="$2"; shift 2;;
    --cleanup-dir)
      CLEANUP_DIR="$2"; shift 2;;
    --dry-run)
      DRY_RUN=true; shift;;
    -h|--help)
      usage;;
    *)
      echo "Unknown argument: $1" >&2
      usage;;
  esac
done

timestamp() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }

log() {
  # prints to stdout and appends to logfile
  echo "[$(timestamp)] $*" | tee -a "$LOGFILE"
}

echo "==== Disk Monitor Starting ====" | tee -a "$LOGFILE"
log "Script dir: $SCRIPT_DIR"
log "Repo root:  $REPO_ROOT"
log "Log file:   $LOGFILE"
log "Threshold:  ${THRESHOLD}%"
log "Cleanup dir:${CLEANUP_DIR:-(none)}"
log "Dry run:    ${DRY_RUN}"

# Print current df snapshot
log "Disk usage snapshot:"
df -h --output=source,fstype,size,used,avail,pcent,target | tee -a "$LOGFILE"
echo "" >> "$LOGFILE"

# Iterate mountpoints and check usage
# Use df's machine-readable output to avoid localization problems
while IFS= read -r line; do
  # Skip empty lines
  [[ -z "$line" ]] && continue

  # line format: /dev/xvda1 ext4 30G 12G 17G 42% /
  # Use awk to extract percent and mountpoint robustly
  percent=$(echo "$line" | awk '{print $(NF-1)}' | tr -d '%')
  mountpoint=$(echo "$line" | awk '{print $NF}')
  source_dev=$(echo "$line" | awk '{print $1}')

  # Skip pseudo filesystems
  case "$source_dev" in
    tmpfs|udev|overlay|squashfs) continue;;
  esac

  # Validate percent is numeric
  if ! [[ "$percent" =~ ^[0-9]+$ ]]; then
    log "Skipping mountpoint (non-numeric usage): $mountpoint (raw: $percent)"
    continue
  fi

  if (( percent >= THRESHOLD )); then
    log "ALERT: ${mountpoint} is at ${percent}% (threshold ${THRESHOLD}%)"

    if [[ -n "$CLEANUP_DIR" && -d "$CLEANUP_DIR" ]]; then
      log "Cleanup target exists: $CLEANUP_DIR"

      if [[ "$DRY_RUN" == "true" ]]; then
        log "[DRY-RUN] Listing files older than 7 days in $CLEANUP_DIR"
        find "$CLEANUP_DIR" -type f -mtime +7 -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | tee -a "$LOGFILE" || true
      else
        log "Deleting files older than 7 days in $CLEANUP_DIR"
        # list before delete
        find "$CLEANUP_DIR" -type f -mtime +7 -print | tee -a "$LOGFILE" || true
        # delete (careful)
        find "$CLEANUP_DIR" -type f -mtime +7 -exec rm -f -- {} + 2>>"$LOGFILE" || true
        log "Cleanup completed for $CLEANUP_DIR"
      fi
    else
      log "No cleanup-dir provided or directory not found. Skipping cleanup."
    fi

    # Optional: add hooks here to send notifications (Slack webhook, mailx, etc.)
    # Example (disabled): curl -X POST -H 'Content-type: application/json' --data '{"text":"Disk alert"}' https://hooks.slack.com/services/...
  fi
done < <(df --output=source,size,used,avail,pcent,target | tail -n +2)

log "==== Disk Monitor Completed ===="
echo "" >> "$LOGFILE"

