proot \
	-R ${PWD}/${CHROOT}/ \
	-w / \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-b /etc/resolv.conf \
	-0 \
	/bin/bash <<EOF

export HOME=/root
export LC_ALL=C

apt update
apt upgrade -y --allow-downgrades

apt install -y virtualbox-guest-dkms virtualbox-guest-utils python3 default-jre build-essential git figlet imagemagick ubuntu-make

# Install tiv from source 
git clone https://github.com/stefanhaustein/TerminalImageViewer.git
cd TerminalImageViewer/src/main/cpp
make
sudo make install

# TODO: You might want to install/purge packages here, or add your PPA.
# You might want to remove the plymouth branded boot screen too.


apt autoremove --purge -y

EOF

sed -i -e 's/Xubuntu/'$DIST_NAME'/g' $EXTRACT/isolinux/txt.cfg
sed -i -e 's/Xubuntu/'$DIST_NAME'/g' $EXTRACT/boot/grub/grub.cfg
sed -i -e 's/Xubuntu/'$DIST_NAME'/g' $EXTRACT/boot/grub/loopback.cfg
sed -i -e 's/Xubuntu 20.04.1 LTS "Focal Fossa"/'$DIST_NAME'/g' $EXTRACT/README.diskdefines
sed -i -e 's/Xubuntu/'$DIST_NAME'/g' $EXTRACT/boot/grub/grub.cfg
rm $EXTRACT/.disk/release_notes_url
echo -n "$DIST_NAME  - Release amd64 (`date +%Y%m%d`)" > $EXTRACT/.disk/info
echo '$DIST_NAME \n \l' > $CHROOT/etc/issue
echo '$DIST_NAME' > $CHROOT/etc/issue.net
echo > $CHROOT/etc/legal

# The lsb-release file
cat <<EOF> $CHROOT/etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=$(date +%Y%m%d)
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="$DIST_NAME"
EOF

# The os-release file
cat <<EOF> $CHROOT/etc/os-release
NAME="$DIST_NAME"
VERSION="$(date +%Y%m%d)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="$DIST_NAME"
VERSION_ID="$(date +%Y%m%d)"
HOME_URL=""
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
EOF

cp -fr $PWD/data/* $CHROOT/
