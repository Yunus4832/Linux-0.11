#
# indicate the Hardware Image file
#
HDA_IMG = hdc-0.11.img
HDA_TEMPLATE = hdc-0.11-example.img

#
# if you want the ram-disk device, define this to be the
# size in blocks.
#
RAMDISK =  #-DRAMDISK=512

#
# This is a basic Makefile for setting the general configuration
#
include Makefile.header

LDFLAGS += -Ttext 0 -e startup_32
CFLAGS += $(RAMDISK) -Iinclude
CPP += -Iinclude

#
# ROOT_DEV specifies the default root-device when making the image.
# This can be either FLOPPY, /dev/xxxx or empty, in which case the
# default of /dev/hd6 is used by 'build'
#
ROOT_DEV = #FLOPPY

ARCHIVES = kernel/kernel.o mm/mm.o fs/fs.o
DRIVERS = kernel/blk_drv/blk_drv.a kernel/chr_drv/chr_drv.a
MATH = kernel/math/math.a
LIBS = lib/lib.a

all: $(HDA_IMG) Image

help:
	@echo "<<<<This is the basic help info of linux-0.11>>>"
	@echo ""
	@echo "Usage:"
	@echo "    make help -- get help"
	@echo "    make -- compile"
	@echo "    make start -- start the kernel in qemu without gui"
	@echo "    make start-with-window -- start the kernel in qemu in gui environment"
	@echo "    make clean -- clean"

#
# use `alt+2 quit` to quit qemu
#
start:
	@qemu-system-x86_64 -display curses -m 16M -boot a -fda Image -hda $(HDA_IMG)

#
# If using the SDL frontend of QEMU:
#   You can release focus using the Left Ctrl+ Left Alt. Notice you have to use the left keys!
# If using the GTK frontend of QEMU (default since QEMU 1.5):
#   Press Ctrl+ Alt+ G
#
start-with-window:
	@qemu-system-x86_64 -m 16M -boot a -fda Image -hda $(HDA_IMG)

clean:
	@rm -f Image
	@rm -f $(HDA_IMG)

dep:
	@sed '/\#\#\# Dependencies/q' < Makefile > tmp_make
	@(for i in init/*.c;do echo -n "init/";$(CPP) -M $$i;done) >> tmp_make
	@cp tmp_make Makefile
	@for i in fs kernel mm; do make dep -C $$i; done

.c.s:
	@$(CC) $(CFLAGS) -S -o $*.s $<
.s.o:
	@$(AS)  -o $*.o $<
.c.o:
	@$(CC) $(CFLAGS) -c -o $*.o $<

boot/head.o: boot/head.s
	@make head.o -C boot/

kernel/math/math.a:
	@make -C kernel/math

kernel/blk_drv/blk_drv.a:
	@make -C kernel/blk_drv

kernel/chr_drv/chr_drv.a:
	@make -C kernel/chr_drv

kernel/kernel.o:
	@make -C kernel

mm/mm.o:
	@make -C mm

fs/fs.o:
	@make -C fs

lib/lib.a:
	@make -C lib

boot/setup: boot/setup.s
	@make setup -C boot

boot/bootsect: boot/bootsect.s
	@make bootsect -C boot

tmp.s: boot/bootsect.s tools/system
	@(echo -n "SYSSIZE = (";ls -l tools/system | grep system \
		| cut -c25-31 | tr '\012' ' '; echo "+ 15 ) / 16") > tmp.s
	@cat boot/bootsect.s >> tmp.s

tools/system: boot/head.o init/main.o \
		$(ARCHIVES) $(DRIVERS) $(MATH) $(LIBS)
	@$(LD) $(LDFLAGS) boot/head.o init/main.o \
	$(ARCHIVES) \
	$(DRIVERS) \
	$(MATH) \
	$(LIBS) \
	-o tools/system
	@nm tools/system | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aU] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)'| sort > System.map 

Image: boot/bootsect boot/setup tools/system
	@cp -f tools/system system.tmp
	@$(STRIP) system.tmp
	@$(OBJCOPY) -O binary -R .note -R .comment system.tmp tools/kernel
	@tools/build.sh boot/bootsect boot/setup tools/kernel Image $(ROOT_DEV)
	@rm -f System.map system.tmp tmp_make core boot/bootsect boot/setup
	@rm -f tools/kernel
	@rm -f init/*.o tools/system boot/*.o
	@for i in mm fs kernel lib boot; do make clean -C $$i; done
	@sync

$(HDA_IMG): $(HDA_TEMPLATE)
	@echo "Restoring $(HDA_IMG) from $(HDA_TEMPLATE)..."
	@cp -f $< $@
	@sync

### Dependencies
init/main.o: init/main.c include/unistd.h include/sys/stat.h \
  include/sys/types.h include/sys/times.h include/sys/utsname.h \
  include/utime.h include/time.h include/linux/tty.h include/termios.h \
  include/linux/sched.h include/linux/head.h include/linux/fs.h \
  include/linux/mm.h include/signal.h include/asm/system.h \
  include/asm/io.h include/stddef.h include/stdarg.h include/fcntl.h

