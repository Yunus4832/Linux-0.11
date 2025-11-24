# linux-0.11 development environment(linux-based)

> Code from [Linux-0.11](https://github.com/yuan-xy/Linux-0.11), with some
> changes to README.md, .gitignore and Makefiles, delete some file that i
> think are useless.

1. preparation

   * a virtual machine: qemu(recommend) or bochs
   * some tools: gcc-4.6, vim, dd, qemu
   * a linux-0.11 hardware image file: hdc-0.11-example.img(already existed)

2. hack linux-0.11

   * get help from the main Makefile of linux-0.11 and star to hack it.

   ```bash
   cd linux-0.11
   make help                                # get help
   make                                     # compile
   make use-contrainer                      # compile use contrainer docker or podman (recommend)
   make start                               # start the kernel in qemu without gui
   make start-with-window                   # start the kernel in qemu in gui environment
   make rebuild-and-start                   # rebuild kernel and start the kernel in qemu without gui
   make rebuild-and-start-use-contrainer    # rebuild kernel and start the kernel in qemu without gui use contrainer
   make clean                               # clean
   ```

