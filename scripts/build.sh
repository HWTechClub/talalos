# we have to update the manifest file to contain the latest list of packages.
echo building
chmod +w $EXTRACT/casper/filesystem.manifest
proot \
	-R ${PWD}/${CHROOT}/ \
	-w / \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-0 \
	dpkg-query -W --showformat='${Package} ${Version}\n' > $EXTRACT/casper/filesystem.manifest
cp $EXTRACT/casper/filesystem.manifest $EXTRACT/casper/filesystem.manifest-desktop
# we have to make a new squashfs compressed filesystem based on the changes we did
# -comp xz
mksquashfs $CHROOT $EXTRACT/casper/filesystem.squashfs -b 1048576 -comp xz -Xdict-size 100%
# we put the size of the filesystem for casper
printf $(du -sx --block-size=1 edit | cut -f1) > $EXTRACT/casper/filesystem.size
# we also have to update the md5sum list of the files
cd $EXTRACT
rm md5sum.txt
find -type f -print0 | xargs -0 md5sum | grep -v isolinux/boot.cat > md5sum.txt
# now build the ISO
xorriso -as mkisofs \
	-r -V "$DIST_NAME amd64" \
	--protective-msdos-label \
	-b isolinux/isolinux.bin \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	--grub2-boot-info --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
	--efi-boot "boot/grub/efi.img" -efi-boot-part --efi-boot-image \
	-o ../$DIST_FILE .
cd $BASEDIR
