how u booting and stuff works nomrally: http://prntscr.com/enydsy
in this situation : http://prntscr.com/enyfgn

to be able to program fpga ON RUN, you need to have "Xilinx version of linux kernel" +configured with Xilinx Device Configuration - ON. then:
  * ls /dev/*  . . . xdevxfg . . .
  * cat bitstream.bit > /dev/xdevxfg
  * cat /sys/class/xdevcfg/xdevcfg/device/prog_done

Another option with Xilinx Specific version Uboot:
  * fatload mmc 0 0x10000000 bitstream.bit # that will load it into ram
  * fpga loadb 0 0x10000000 0x3213412 # second one is size. to load from RAM to FPGA



Toolchain install:
  bitbake core-image-minimal -c populate_sdk
  ./tmp/deploy/sdk/poky-glibc-x86_64-core-image-minimal-cortexa9hf-neon-toolchain-2.2.1.sh

Toolchain usage:
  source /opt/poky/2.2.1/environment-setup-cortexa9-vfp-neon*
  echo $CROSS_COMPILE
  $CC --version
  $CC draw.c -o app.out
  file app.out

to remove other two toolchains:
  vim conf/local.conf
  TCLIBC ?="musl" ##or "glibc" or "uclibc" (just comment other two)




customizing linux
  vim conf/local.conf
  INHIBIT_PACKAGE_STRIP = "1" #stripping symbols from executables
  EXTRA_IMAGE_FEATURES = .. # extra debugging stuff
  CORE_IMAGE_EXTRA_INSTALL = .. #extra specific packages
and then simply bitbake core-image-minimal and it will do all those shits


Modifying device trees
    * easiest option is to replace generated device tree with yours (you have to use device tree compiler)
      cd  /home/tsotne/ownCloud/git/yocto/build/tmp/work/zedboard_zynq7-poky-linux-gnueabi/linux-xlnx/4.6-xilinx-v2016.3+gitAUTOINC+0e4e407149-r0/linux-zedboard_zynq7-standard-build/scripts/dtc
      dtc -I dts -O dtb -o /home/tsotne/ownCloud/git/yocto/new_devicetree.dtb   <file path of dts file you want to compile>

    * or modify provided device tree like described below (this was not described in video, and have not tested, maybe it gets new device trees from remote sources?)
      cd /home/tsotne/ownCloud/git/yocto/build/tmp/work-shared/zedboard-zynq7/kernel-source/
      cd arch/arm/boot/dts/
      cp zynq-zc702.dts zynq-zc702.dts_original
      vim zynq-zc702.dts
        //modify as you wish

    * other long term solution will be to modify bitmake to include correct device tree. (not described in video)


Include bitstream:
  * i think i have to put bitstream in this location (have not tested):
    tmp/deploy/images/zedboard-zynq7/
About kernel version:
    you can change it in conf/local.conf
      PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"
      PREFERRED_VERSION_linux-yocto ?="4.8%"
    and then build the core-image-minimal, but it will be on your local pc.


to show which kernel are we using
    bitbake -s | grep u-boot


you can change bootloader
    PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"
