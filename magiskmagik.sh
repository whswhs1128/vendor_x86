#!/bin/bash
set -e
# determine the GPD Win patches folder location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# patch bootable/newinstaller
# cd "bootable/newinstaller"
# git am < "$DIR/Use-magisk-init.patch"
#i="$DIR/Use-magisk-init.patch"
#a=`grep "Date: " $i`
#b=`echo ${a#"Date: "}`
#c=`git log --pretty=format:%aD | grep "$b"`

#if [[ "$c" == "" ]] ; then
#  git am -3 $i >& /dev/null
#  if [[ $? == 0 ]]; then
#	echo "        Applying          $i"
#  else
#	echo "        Conflicts          $i"
#	git am --abort >& /dev/null
#	conflict="y"
#  fi
#else
#  echo "        Already applied         $i"
#fi

#cd ../..
#echo "Patching Complete"

# bundle MagiskManager into the system
cd "out/target/product/x86_64/system/app"
rm -rf MagiskManager
mkdir MagiskManager
cd MagiskManager
cp -f "$DIR/magisk/MagiskManager.apk" .
# mkdir tmp
# cd tmp
# unzip ../MagiskManager.apk
# mv lib ..
# cd ..
# rm -rf tmp
cd ..
echo "MagiskManager copied"

cd ../../../../../..

# delete all files we wish to rebuild
rm -rf out/target/product/x86_64/*.iso
echo "Removed ISO"
rm -rf out/target/product/x86_64/system.sfs
echo "Removed system.sfs"
rm -rf out/target/product/x86_64/system.img
echo "Removed system.img"
# rm -rf out/target/product/x86_64/ramdisk.img
# echo "Removed ramdisk"
# rm -rf out/target/product/x86_64/initrd.img
# echo "Removed initrd"
rm -rf out/target/product/x86_64/obj/PACKAGING/systemimage_intermediates/system.img
echo "Removed system images"

# copy the magisk init binary into the ramdisk
# we need to go this roundabout way because android-x86 has three ramdisks...
# but we must only patch the android-x86 live system one, otherwise we bootloop!
# cd "out/target/product/x86_64"
# rm -rf magisk
# mkdir magisk
# cd magisk
# gzip -cd ../ramdisk.img | cpio -i
# cp "$DIR/magisk/init" .
# find . | cpio -o -H newc | gzip > ../ramdisk.img
# cd ..
# rm -rf magisk
# cd ../../../..
#cd "bootable/newinstaller/initrd/bin"
#cp "$DIR/magisk/init" .
#cd ../../../..
echo "Moved init"

# workaround until I figure out what's wrong with the code above
# cp "$DIR/magisk/ramdisk.img" "out/target/product/x86_64"
rm -rf out/target/product/x86_64/system/magisk
mkdir out/target/product/x86_64/system/magisk
cp "out/target/product/x86_64/ramdisk.img" "out/target/product/x86_64/system/magisk"

# setup the aosp build environment
# . build/envsetup.sh

# pick our lunch
# lunch android_x86_64-userdebug

# rebuild the image
# m -j4 iso_img
