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
  ./tmp/deploy/sdk/poky-glibc-*

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
    easiest option is to replace generated device tree with yours (you have to use device tree compiler)
    long term solution will be to modify bitmake to include correct device tree. (not described)


About kernel version:
    you can change it in conf/local.conf
      PREFERRED_PROVIDER_virtual/kernel ?= "linux-yocto"
      PREFERRED_VERSION_linux-yocto ?="4.8%"
    and then build the core-image-minimal, but it will be on your local pc.


to show which kernel are we using
    bitbake -s | grep u-boot


you can change bootloader
    PREFERRED_PROVIDER_virtual/bootloader ?= "u-boot"
