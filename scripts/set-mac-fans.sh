#!/usr/bin/env bash
set -euo pipefail

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Elevating privileges with sudo..."
  exec sudo bash "$0" "$@"
fi

CONFIG_FILE="/etc/t2fand.conf"
PROFILE="${1:-balanced}"

case "$PROFILE" in
  balanced)
    LOW_TEMP=55
    HIGH_TEMP=85
    CURVE="linear"
    ;;
  cool)
    LOW_TEMP=50
    HIGH_TEMP=80
    CURVE="linear"
    ;;
  quiet)
    LOW_TEMP=65
    HIGH_TEMP=90
    CURVE="exponential"
    ;;
  *)
    echo "Usage: $0 [balanced|cool|quiet]" >&2
    exit 1
    ;;
esac

echo "Applying $PROFILE fan profile (low_temp=$LOW_TEMP, high_temp=$HIGH_TEMP, speed_curve=$CURVE)..."

cat <<EOF > "$CONFIG_FILE"
[Fan1]
low_temp=$LOW_TEMP
high_temp=$HIGH_TEMP
speed_curve=$CURVE
always_full_speed=false

[Fan2]
low_temp=$LOW_TEMP
high_temp=$HIGH_TEMP
speed_curve=$CURVE
always_full_speed=false
EOF

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
echo "Done! Profile applied."
