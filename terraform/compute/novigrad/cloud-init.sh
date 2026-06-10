#!/usr/bin/env bash
set -euo pipefail

# oke bootstrap - must run first for node registration
if [[ ! -f /var/run/oke-init.done ]]; then
  curl --fail -H "Authorization: Bearer Oracle" -L0 \
    http://169.254.169.254/opc/v2/instance/metadata/oke_init_script \
    | base64 --decode > /var/run/oke-init.sh
  bash /var/run/oke-init.sh
  touch /var/run/oke-init.done
fi

# expand root fs
/usr/libexec/oci-growfs -y

# format and mount data volume
if ! blkid /dev/sdb &>/dev/null; then
  mkfs.xfs /dev/sdb
fi

mkdir -p /var/mnt/data
data_uuid=$(blkid -s UUID -o value /dev/sdb)
grep -q "$data_uuid" /etc/fstab || echo "UUID=$${data_uuid} /var/mnt/data xfs defaults 0 2" >> /etc/fstab
mount -a

# install tailscale
dnf config-manager --add-repo https://pkgs.tailscale.com/stable/oracle/8/tailscale.repo
dnf install -y tailscale

# enable ip forwarding - required for subnet routing
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.d/tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.d/tailscale.conf
sysctl -p /etc/sysctl.d/tailscale.conf

# start tailscaled
systemctl enable --now tailscaled

# join tailnet and advertise endpoint subnet
tailscale up \
  --authkey="${auth_key}" \
  --advertise-routes="${endpoint_subnet_cidr}" \
  --accept-routes \
  --accept-dns=false
