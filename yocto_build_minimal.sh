origin="/home/tsotne/ownCloud/git/yocto"
mkdir -p $origin && cd $origin

#mostly u need to install this
sudo apt install cpp gcc g++ chrpath
  #official install prerequisites, since most of them are installed in linux mint 18 we only need whats above.
    #sudo apt install gawk make wget tar bzip2 gzip python unzip perl patch diffutils diffstat git cpp gcc gcc-c++ glibc-devel texinfo chrpath ccache perl-Data-Dumper perl-Text-ParseWords perl-Thread-Queue SDL-devel xterm


#clone repos
git clone -b morty git://git.yoctoproject.org/poky.git
git clone -b morty git://github.com/Xilinx/meta-xilinx


# setup stuff for builds
source poky/oe-init-build-env
  #moves into directory : $origin/build


#TODO or manually: add /home/tsotne/ownCloud/git/yocto/meta-xilinx  in conf/bblayers.conf


#TODO manually: replace with this: MACHINE ?= "zedboard-zynq7" in conf/local.conf. to check possible machines type : ls meta-xilinx/conf/machine/




#build linux in video takes 37 minutes on 8 core, 100gb ethernet.
bitbake core-image-minimal



#important files:
  #boot.bin --primary bootloader
  #core-image-minimal-zedboard-zynq7.* --file system files
  #modules-zedboard-zynq7.tgz --tarball of kernel modules
  #u-boot-dtb.img  --uboot image file
  #u-boot.elf --uboot executable
  #uEnv.txt --environment setting
  #uImage --kernel image with uboot header
  #zedboard-zynq7.dtb --device tree
ls tmp/deploy/images/zedboard-zynq7/


# prerequisites for wic: builds three packages
bitbake dosfstools-native mtools-native parted-native


#builds SD card image, prints image location in terminal
wic create sdimage-bootpart -e core-image-minimal


#put that image to SD card. sd(d) was in my case. vide -(23:42)
sudo dd if=/var/tmp/wic/build/sdimage-bootpart-201703241446-mmcblk.direct of=/dev/sdd bs=4k
  #from that:
    #root partition is: 6.9 mb used from 13.5
    #boot partition is: 4.2 mb used from 12.5
    #rest of the sd card is unallocated
  #in my case it did not work until i formatted the sd card partitions. might be coincidence.
  #login username of linux (uses uart) is: root (password is not required)


#totally, yocto folder takes 22.9 GB
