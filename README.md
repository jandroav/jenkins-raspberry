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
# Install Podman
Run the following commands:
```bash
# Raspbian 10
# First enable user namespaces as root user
echo 'kernel.unprivileged_userns_clone=1' | sudo tee -a /etc/sysctl.d/00-local-userns.conf
sudo systemctl restart procps

# Use buster-backports on Rasbian 10 for a newer libseccomp2
echo 'deb http://deb.debian.org/debian buster-backports main' | sudo tee -a /etc/apt/sources.list
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Raspbian_10/ /' | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Raspbian_10/Release.key | sudo apt-key add -

# Add missing keys for buster-backports manually
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138

sudo apt-get update
sudo apt-get -y -t buster-backports install libseccomp2
sudo apt-get -y install podman
# Restart dbus for rootless podman. Do this for every user using containers.
# This command only works without root. One way to do this is to login as the
# user via SSH, so DBUS_SESSION_BUS_ADDRESS will be set correctly.
systemctl --user restart dbus
```
# Install Buildah
Run the following commands:
```bash
# Raspbian 10
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Raspbian_10/ /' | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Raspbian_10/Release.key | sudo apt-key add -
sudo apt-get update -qq
sudo apt-get -qq -y install buildah
```
# Install other packages
```bash
# git
sudo apt-get install git
```
# Build Jenkins main instance image
//TODO