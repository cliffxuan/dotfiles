#!/usr/bin/env bash
set -euo pipefail

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Elevating privileges with sudo..."
  exec sudo bash "$0" "$@"
fi

CONFIG_FILE="/etc/t2fand.conf"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: $CONFIG_FILE does not exist." >&2
  exit 1
fi

echo "Cleaning stray lines from $CONFIG_FILE..."
sed -i '/EOF/,$d' "$CONFIG_FILE"

echo "Restarting t2fanrd service..."
systemctl restart t2fanrd

echo ""
echo "=== t2fanrd Service Status ==="
systemctl status t2fanrd.service --no-pager || true

echo ""
echo "=== Current Thermal & Fan Status ==="
if command -v sensors >/dev/null 2>&1; then
  sensors | grep -E "Package id 0|fan[12]|edge" || true
fi

echo ""
echo "Done! Fans should decelerate to ~2,000-2,500 RPM shortly."
