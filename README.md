# linux-0.11 development environment(linux-based)

> Code from [Linux-0.11](https://github.com/yuan-xy/Linux-0.11), with some
> changes to README.md, .gitignore and Makefiles, delete some file that i
> think are useless.

1. preparation

   * a linux distribution: debian and ubuntu are recommended
   * a virtual machine: qemu(recommend) or bochs
   * some tools: cscope, ctags, gcc-4.3(or 4.1,4.2,3.4), vim, bash, gdb, dd,
   qemu, xorg-dev, xserver-xorg-dev...

     ```bash
     $ apt-get install qemu cscope exuberant-ctags gcc-4.3 vim-full bash gdb \
                       build-essential hex graphviz xorg-dev xserver-xorg-dev \
                       vgabios libxpm-dev bochs bochs-x bochsbios bximage
     ```

   * a linux-0.11 hardware image file: hdc-0.11-example.img(already existed)

   and you'd better install tools/calltree, tools/tree2dotx yourself: just copy
   them to /usr/bin, of course, you'd compile calltree at first.

2. hack linux-0.11

   * get help from the main Makefile of linux-0.11 and star to hack it.

   ```bash
   cd linux-0.11
   make help               # get help
   make                    # compile
   make start              # start the kernel in qemu in gui environment
   make start-with-window  # start the kernel in qemu without gui
   make clean              # clean
   ```

