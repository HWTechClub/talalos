echo extracting
# We make the mount directory and mount the ISO to it
mkdir $MOUNT $EXTRACT
mount -o loop $ORIG_FILE $MOUNT
# Now we copy the ISO contents to our extract directory
rsync --exclude=/casper/filesystem.squashfs -a ${MOUNT}/ $EXTRACT
# The filesystem is in a read-only compressed filesystem which we need to extract
unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root $CHROOT
# We can now unmount and delete that directory
umount $MOUNT
rm -rf $MOUNT
