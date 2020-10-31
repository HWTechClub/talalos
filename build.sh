#!/bin/sh
set -e

# We define the global variables
BASEDIR=$(pwd) # this is the base working directory, in case we need to go back to it
MOUNT="mnt" # this is the mount directory for the ISO file
EXTRACT="extract-cd" # this is where the ISO will be extracted to
CHROOT="edit" # this is where the root partition (squashfs) will be extracted to
ORIG_FILE="xubuntu-20.04.1-desktop-amd64.iso" # this is the file we will be customising
DIST_NAME="TalalOS"
DIST_FILE="$DIST_NAME-$(date +%Y%m%d).iso" # this is the final file

# We make sure that the ISO file exists before we continue
if [ ! -f $ORIG_FILE ]; then
	echo "The file ${ORIG_FILE} doesn't exist. Be sure to download it first."
	exit
fi

# We clean up the files from previous runs
rm -rf $CHROOT $EXTRACT $MOUNT

# Now we run the scripts
. ./scripts/extract.sh
. ./scripts/customise.sh
. ./scripts/build.sh
