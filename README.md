This project simulates a real-world network environment using virtual machines in VMware.

An Ubuntu VM is configured as a router, performing NAT (Network Address Translation) and routing traffic between an isolated LAN Segment network and the internet. A Windows 10 VM acts as a client and accesses the internet through this virtual router.

Network Architecture 
```
Internet
   │
[ Ubuntu Router ]
   │ (LAN Segment)
[ Windows 10 Client ]
```

Technologies Used

* Ubuntu (Netplan)
* VMware Workstation
* iptables
* LAN Segment Networking
* Windows 10


Features

* Linux-based router configuration
* NAT (Network Address Translation)
* Isolated virtual network (LAN Segment)
* Manual IP configuration
* Traffic forwarding between interfaces


Setup Guide

1. VMware Configuration

Ubuntu VM:

* Adapter 1: NAT (Internet access)
* Adapter 2: LAN Segment (e.g., `rede-lab`)

Windows VM:

* Adapter 1: LAN Segment (`rede-lab`)

2. Configure Ubuntu Network

Edit Netplan:

```bash
sudo nano /etc/netplan/01-netcfg.yaml
```

Example:

```yaml
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: true
    ens37:
      dhcp4: no
      addresses:
        - 192.168.100.1/24
```

Apply configuration:

```bash
sudo netplan apply
```

---

3. Enable IP Forwarding

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

To make it persistent:

```bash
sudo nano /etc/sysctl.conf
```

Add:

```
net.ipv4.ip_forward=1
```

Apply:

```bash
sudo sysctl -p
```

4. Configure NAT (iptables)

```bash
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
```

```bash
sudo iptables -A FORWARD -i ens33 -o ens37 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ens37 -o ens33 -j ACCEPT
```

5. Configure Windows Client

Set IPv4 manually:

* IP Address: 192.168.100.10
* Subnet Mask: 255.255.255.0
* Default Gateway: 192.168.100.1
* DNS Server: 8.8.8.8

---

Testing

Run the following commands on Windows:

```cmd
ping 192.168.100.1
ping 8.8.8.8
ping google.com
```

