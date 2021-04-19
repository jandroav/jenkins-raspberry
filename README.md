# jenkins-raspberry
This is a project to explain how to run Jenkins on an old raspberry pi using:
* Raspberry Pi OS
* Podman
* Buildah

The initial idea was to build everything over kubernetes but k3s has certain problems with Raspberry Pi 3 models so the new architecture will be:
* Jenkins main instance running with Podman in a Raspberry Pi 3 model B
* Jenkins agents running over a k3s cluster built from several Raspberry Pi 4
## Hardware you need
* At least one Raspberry Pi 3 model B
* SD card (32 Gb or more)
* Power supply (5.1V)
* Micro-usb cable
* Ethernet cable
# Prepare your Raspberry Pi 3
We are going to set yp our unit in a headless way: without monitor and keyboard:
1. Insert a microSD card into your computer
2. Download, install and run [Raspberry Pi Imager](https://www.raspberrypi.org/software/)
3. Select "Raspberry Pi OS Other" and Raspberry Pi OS Lite (32-bit) from the OS menu
4. Click Choose SD card and select your card from the menu
5. Click Write. This process will take several minutes as Raspberry Pi Imager downloads Raspberry Pi OS and burns it to your microSD card

Now we need to enable ssh access to be able to connect and configure our unit. You only need to create an empty file called ssh like:
```bash
touch /Volumes/boot/ssh
```
6. Insert the SD carg into the Raspberry and plug your Raspberry Pi directly to a wired network, you should be able to access it by its name (raspberrypi or raspberrypi.local) without changing any other files, or by its local ip
```bash
ssh pi@raspberrypi.local
```
Initial password is `raspberry`

7. Change default password:
```bash
passwd pi
```
8. You can set passwordless access following [this](https://www.raspberrypi.org/documentation/remote-access/ssh/passwordless.md)
9. Adjust GPU memory to 16Mb and expand file system using the command line tool:
```bash
sudo raspi-config
```
* Performance Options -> GPU memory -> set to 16Mb
* Advanced Options -> Expand file system
10. Reboot yor Pi
11. Once rebooted do an update and upgrade:
```bash
sudo apt-get update && sudo apt-get upgrade
```
# Install Podman, Buildah and runc
Run the following commands:
```bash
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/Debian_10/Release.key | apt-key add - && \
echo "deb http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list && \
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_10 /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list && \
export DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install -t buster-backports -y --no-install-recommends \
libseccomp-dev && \
apt-get install -y --no-install-recommends \
buildah \
podman \
runc && \
rm -rf /var/lib/apt/lists/*
```
# Install other packages
```bash
# git
sudo apt-get install git
```
# Build Jenkins main instance image
//TODO