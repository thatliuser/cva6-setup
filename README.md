# cva6-setup
A [fish](https://fishshell.com/) script to download and configure the needed dependencies to:
- Compile the Verilator (software) version of the [CVA6 RISC-V CPU](https://github.com/openhwgroup/cva6)
- Run the Linux kernel using the created simulator

# Dependencies
- [Fish](https://fishshell.com/)
- [Pacman](https://archlinux.org/pacman/)
- [Make](https://www.gnu.org/software/make/)
- [Git](https://git-scm.com/)
- A working internet connection

# Important notices
- This script was mostly made to run on my personal computer, which runs on `Arch Linux 5.19.9`. Other versions or distributions of Linux are not guaranteed to work as effectively, or even at all.
- Personally, I strongly dislike when software is installed without my express consent onto my computer. For this reason, all of the dependencies that are downloaded when the script runs will either ask for your permission to install them (when installing through pacman), or will be put into a controlled directory, which will live under the environment variable `RISCV`.
- While I have verified that the kernel downloaded runs with RISC-V's official ISA emulator, [Spike](https://github.com/riscv-software-src/riscv-isa-sim), the Verilator CVA6 is far too slow to boot it, and I have not personally seen any output from the Linux kernel image from the CVA6. However, I have run a Hello World program on the CVA6 by following the instructions on the its repository, which can verified by invoking it. You can do this by passing a parameter to the shell script: __FILL THIS IN LATER__.
