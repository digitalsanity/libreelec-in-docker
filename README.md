# libreelec-in-docker

Launch and play LibreELEC/Kodi (rockpro64/rock64 and Debian/Ubuntu host currently) via docker from your desktop.  Xorg will close but your services will continue.  Shutdown computer from Kodi to return to Xorg.  Your settings are stored in $HOME/libreelec-share/

- This pulls the latest nightly release and builds a docker container from the rootfs, allowing you to launch LibreELEC from most any debian/ubuntu host -- as long as the kernel rockchip version matches.  (4.4.171 tested, with arm64 kernel and armhf userspace)

# Steps

1. cd to this directory.
2. ./install.sh (not with sudo; if a folder pops up during install, close/ignore it; takes 10-15 minutes to complete)
3. Launch LibreELEC from desktop application launcher (Media/Games/Video)

Run ./install.sh again at any time to update LibreELEC to the latest version.  Your settings/files/add-ons will be retained in $HOME/libreelec-share/

# Debugging steps

1. cd to this directory.
2. ./build-prepare.sh - Install Docker and dependencies.
3. ./build-rootfs.sh - Grab and build rootfs.  There will be some rsync errors/warnings - it's OK.
4. Optional: Review docker/rootfs and build-docker-from-rootfs.sh for files that will be removed.  Review docker/startup.sh for how the image is booted.
5. ./build-docker-from-rootfs.sh - Build docker from docker/rootfs.
6. Launch LibreELEC or /usr/local/bin/libreelec-boot-stopx.sh from desktop, or close your desktop and launch /usr/local/bin/libreelec-boot.sh from tty1.

# Working/tested

- ROCKPro64 (RK3399)
  - https://github.com/ayufan-rock64/linux-build/releases 0.8.0rc5 or newer, mate armhf/bionic LXDE arm64 releases tested.  Must be on -1163 kernel or newer.  Audio issues currently.
  - https://github.com/mrfixit2001/debian_desktop/releases - Second Release or newer.

# Should work

- ROCK64 (RK3328)
  - https://github.com/ayufan-rock64/linux-build/releases 0.8.0rc5 or newer, mate armhf/bionic LXDE arm64 releases.  Must be on -1163 kernel or newer.

# Other notes

- There will be issues.  Currently this is only for RockPro64 and pulls a specific release.

Regards,
- Jason Fisher
- jason dot fisher at gmail dot com
