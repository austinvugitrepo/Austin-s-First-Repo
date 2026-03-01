**Offline Remote Access Setup Guide**

*SSH over Direct Ethernet — OpenBSD Client \+ Linux Mint Server*

# **Overview**

This guide documents how to SSH into a Linux Mint server (GPD Pocket 1\) from an OpenBSD client (ThinkPad X220) using a direct Ethernet cable — no router, no internet required. Both machines use USB Ethernet dongles since neither has a working built-in Ethernet port.

# **Hardware Used**

| Device | Role | Dongle |
| :---- | :---- | :---- |
| ThinkPad X220 (OpenBSD) | Client | Pine64 Hub (axen0 driver) |
| GPD Pocket 1 (Linux Mint) | Server | j5create 10G Dual 4K (usbeth0) |
| Regular Ethernet patch cable | Connection | Auto MDI-X — no crossover needed |

# **IP Address Plan**

| Machine | Interface | Static IP |
| :---- | :---- | :---- |
| OpenBSD Client (ThinkPad X220) | axen0 | 10.0.0.1 |
| Linux Mint Server (GPD Pocket 1\) | usbeth0 | 10.0.0.2 |

# **Linux Mint Server Setup**

## **Step 1 — Lock the Interface Name with udev**

Prevents the dongle from getting a different name when replugged into a different USB port.

sudo nano /etc/udev/rules.d/70-persistent-net.rules

Paste the following (using your dongle's actual MAC address):

SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?\*", ATTR{address}=="00:00:00:00:03:a6", NAME="usbeth0"

sudo udevadm control \--reload-rules

Unplug and replug the dongle, then verify:

ip a

✅  You should now see usbeth0 instead of the long enx... name.

## **Step 2 — Configure Static IP via NetworkManager**

sudo nano /etc/NetworkManager/system-connections/direct-eth.nmconnection

Paste:

\[connection\]

id=direct-eth

type=ethernet

interface-name=usbeth0

\[ipv4\]

method=manual

addresses=10.0.0.2/24

sudo chmod 600 /etc/NetworkManager/system-connections/direct-eth.nmconnection

sudo nmcli connection reload

sudo nmcli connection up direct-eth

Enable autoconnect so it activates every time the dongle is plugged in:

sudo nmcli connection modify direct-eth connection.autoconnect yes

Verify:

ip a show usbeth0

✅  You should see 10.0.0.2 assigned to usbeth0.

# **OpenBSD Client Setup**

## **Step 1 — Configure Static IP**

doas sh \-c 'echo "inet 10.0.0.1 255.255.255.0 NONE" \> /etc/hostname.axen0'

doas sh /etc/netstart axen0

Verify:

ifconfig axen0

✅  You should see 10.0.0.1 assigned to axen0.

## **Step 2 — Enable hotplugd for Persistence**

OpenBSD does not automatically re-apply interface configs when a USB device is replugged. hotplugd handles this.

doas mkdir \-p /etc/hotplug

doas nano /etc/hotplug/attach

Paste:

\#\!/bin/sh

DEVCLASS=$1

DEVNAME=$2

case $DEVCLASS in

    3\) \# network devices

        sh /etc/netstart $DEVNAME

        ;;

esac

doas chmod 0755 /etc/hotplug/attach

doas rcctl enable hotplugd

doas rcctl start hotplugd

✅  Now the static IP will persist automatically every time you replug the dongle.

# **Using the Setup**

Plug the Ethernet cable between both dongles, then from your OpenBSD client:

ping 10.0.0.2

ssh austin@10.0.0.2

| Scenario | WiFi | Ethernet Link |
| :---- | :---- | :---- |
| Cable unplugged | Works normally | Interface inactive |
| Cable plugged in | Still works normally | 10.0.0.x activates |
| Both active at once | Works | Works — no conflict |

# **Important Notes**

* Do all configuration while you still have SSH access over the network.

* Both interfaces (WiFi and Ethernet) work simultaneously — no need to disconnect from the internet.

* Use the same dongle in the same machine every time to keep interface names stable.

* A regular patch cable works fine — Auto MDI-X is standard on all Gigabit Ethernet hardware including these dongles.

* The 10.0.0.x range was chosen deliberately to be clearly distinct from the regular 192.168.1.x WiFi network.