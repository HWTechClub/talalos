echo customising
export PROOT_NO_SECCOMP=1
echo "Entering chroot environment. Do ^D to exit."
proot \
	-r ${PWD}/${CHROOT}/ \
	-w / \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-0 \
	/bin/bash
proot \
	-r ${PWD}/${CHROOT}/ \
	-w / \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-0 \
	/bin/bash <<EOF
export HOME=/root
export LC_ALL=C
echo "nameserver 8.8.8.8" > /etc/resolv.conf

apt update
#apt upgrade -y --allow-downgrades

apt install -y bluebird-gtk-theme obsidian-icon-theme ffmpeg

apt purge -y apport pidgin apport transmission-gtk gigolo gnome-sudoku blueman \
catfish simple-scan sgt-launcher thunderbird gucharmap xfburn snapd \
speech-dispatcher yelp modemmanager hplip gnome-menus gnome-keyring \
gnome-font-viewer gimp fwupd espeak bluez aspell apparmor bolt colord dc \
anacron avahi-utils bc brltty cron build-essential \
cheese-common gnome-mines gnome-software onboard

apt purge -y fonts-tlwg-laksaman fonts-lao fonts-tlwg-purisa fonts-thai-tlwg fonts-gubbi fonts-indic fonts-beng-extra fonts-tlwg-purisa-ttf fonts-tlwg-norasi fonts-deva fonts-smc-gayathri fonts-guru-extra fonts-tlwg-typewriter-ttf fonts-samyak-deva fonts-telu-extra fonts-smc fonts-tlwg-typist fonts-gargi fonts-smc-karumbi fonts-tlwg-norasi-ttf fonts-kalapi fonts-navilu fonts-smc-chilanka fonts-orya fonts-tlwg-kinnari fonts-pagul fonts-tlwg-mono fonts-kacst-one fonts-knda fonts-smc-meera fonts-smc-raghumalayalamsans fonts-tibetan-machine fonts-sahadeva fonts-tlwg-typewriter fonts-smc-keraleeyam fonts-lohit-deva fonts-smc-suruma fonts-tlwg-garuda fonts-sil-abyssinica fonts-taml fonts-tlwg-kinnari-ttf fonts-samyak-taml fonts-tlwg-waree fonts-tlwg-typo fonts-lklug-sinhala fonts-telu fonts-lohit-orya fonts-tlwg-sawasdee fonts-tlwg-umpush fonts-lohit-knda fonts-smc-rachana fonts-tlwg-loma fonts-smc-manjari fonts-dejavu-core fonts-gujr fonts-guru fonts-smc-uroob fonts-samyak-gujr fonts-tlwg-waree-ttf fonts-nakula fonts-lohit-beng-bengali fonts-tlwg-garuda-ttf fonts-orya-extra fonts-tlwg-sawasdee-ttf fonts-mlym fonts-lohit-taml fonts-tlwg-typo-ttf fonts-beng fonts-samyak-mlym fonts-tlwg-loma-ttf fonts-khmeros-core fonts-smc-dyuthi fonts-lohit-telu fonts-tlwg-mono-ttf fonts-kacst fonts-gujr-extra fonts-tlwg-typist-ttf fonts-sil-padauk fonts-smc-anjalioldlipi fonts-lohit-beng-assamese fonts-lohit-gujr fonts-lohit-guru fonts-tlwg-umpush-ttf fonts-tlwg-laksaman-ttf fonts-sarai fonts-lohit-mlym fonts-lohit-taml-classical



# TODO: You might want to install/purge packages here, or add your PPA.
# You might want to remove the plymouth branded boot screen too.


apt autoremove --purge -y
apt clean

update-initramfs -u
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
