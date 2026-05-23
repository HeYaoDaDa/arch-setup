#!/bin/bash
# ~/arch-setup/run.sh - One-click config for current host
set -e

cd "$(dirname "$0")"

# Detect current hostname
# When run inside arch-chroot, uname -n returns 'archiso' instead of the target hostname.
# Fall back to /etc/hostname if that happens.
HOST=$(uname -n)
if [ "$HOST" = "archiso" ] && [ -f /etc/hostname ]; then
    HOST=$(cat /etc/hostname)
fi

# Check if host is in inventory
if ! grep -q "$HOST" inventory.yml 2>/dev/null; then
    echo "[ERROR] Host '$HOST' not found in inventory.yml"
    echo "       Add it or run: ansible-playbook ... -l desktop-arch-i712700"
    exit 1
fi

echo "[INFO] Configuring: $HOST"
echo ""

# --- Network readiness check ---
echo "[CHECK] Testing network connectivity..."
if ! ping -c 1 -W 3 archlinux.org &>/dev/null; then
    echo ""
    echo "[ERROR] Network is not ready!"
    echo ""

    if echo "$HOST" | grep -qi "laptop"; then
        SSID=$(grep -oP 'wifi_ssid:\s*\K.*' "host_vars/${HOST}/vars.yml" 2>/dev/null || echo "<your-wifi-ssid>")
        IFACE=$(grep -oP 'network_interface:\s*\K.*' "host_vars/${HOST}/vars.yml" 2>/dev/null || echo "wlan0")
        echo "       Laptop '$HOST' detected - connect WiFi first:"
        echo "       iwctl --passphrase '<password>' station $IFACE connect $SSID"
    else
        echo "       Check wired connection (cable / DHCP)."
    fi

    echo ""
    echo "       After network is up, re-run: ./run.sh"
    exit 1
fi
echo "[OK] Network is ready"
echo ""

# vault password: env var > interactive prompt
VAULT_TMP=""
cleanup() {
    [ -n "$VAULT_TMP" ] && rm -f "$VAULT_TMP"
}
trap cleanup EXIT

if [ -n "$VAULT_PASS" ]; then
    VAULT_TMP=$(mktemp)
    echo "$VAULT_PASS" > "$VAULT_TMP"
    VAULT_OPT="--vault-password-file $VAULT_TMP"
else
    VAULT_OPT="--ask-vault-pass"
fi

# Check if sudo is passwordless (skip -K if yes)
BECOME_OPT="-K"
if sudo -n true 2>/dev/null; then
    BECOME_OPT=""
fi

# Execute
ansible-playbook playbooks/setup.yml \
  -l "$HOST" \
  $VAULT_OPT \
  $BECOME_OPT "$@"

echo ""
echo "[OK] $HOST configured successfully!"
