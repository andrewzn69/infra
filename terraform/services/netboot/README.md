# netboot

Provisions a netboot.xyz PXE boot server on a Proxmox LXC container (Debian 13)

## what it does

1. Creates a Debian LXC container on Proxmox
2. Runs an Ansible playbook that sets up:
  - netboot.xyz - the PXE menu system, served via Apache (80)
  - tftpd-hpa - TFTP server serving the iPXE binary (69)
  - ghproxy - Apache CGI script that proxies GitHub asset downloads over HTTP
  - custom iPXE binary - snponly.efi with embedded boot script

# why ghproxy?

iPXE cannot complete HTTPS connections to GitHub (for whatever reason, idk). When selecting
an OS in the netboot.xyz menu, it would try to download assets directly from GitHub
releases. This would fail with something like "network unreachable" or "permission denied" in iPXE.

ghproxy is an Apache CGI script running on the container that fetches from GitHub
on iPXE's behalf over plain HTTP. netboot.xyz is configured via `user_overrides.yml`
to use `live_endpoint: http://{{ boot_domain }}/cgi-bin/ghproxy` instead of hitting GitHub directly.

## why custom iPXE binary?

The prebuilt `netboot.xyz-snponly.efi` chains to `boot.netboot.xyz` (CDN).
To be able to use the local server and ghproxy, the binary must embed a boot script that
chains to the local server instead:

```sh
#!ipxe
dhcp
chain http://{{ boot_domain }}/menu.ipxe
```

The binary is built with `netboot.xyz-snponly.efi` (SNP only network driver mode) instead of the default (`netboot.xyz.efi`),
which fixes keyboard input on some motherboards (confirmed on my MSI B450-A PRO MAX).
