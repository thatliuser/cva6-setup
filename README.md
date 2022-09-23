# cva6-setup
A collection of [fish](https://fishshell.com/) scripts to download and configure the needed dependencies to:
- Compile the Verilator (software simulator) version of the [CVA6 RISC-V CPU](https://github.com/openhwgroup/cva6).
- Run the Linux kernel using the compiled simulator.

# Quickstart
- If you're on Arch Linux, run `pacman.fish` to install all dependencies.
- Set the environment variable `RISCV` to the desired directory for everything to be downloaded.
- Set the environment variable `JOBS` to the number of threads you'd like `make` to use when compiling. This should usually be the amount of cores that your CPU has. If you're not sure, just set it to 1.
- Run `setup.fish` to compile the CVA6 simulator.
- Run `run.fish` to run the resulting simulator, so it can demonstrate its capabilities.

# Dependencies
- [Fish](https://fishshell.com/)
- [Make](https://www.gnu.org/software/make/)
- [Git](https://git-scm.com/)
- [Curl](https://curl.se/)
- [Tar](https://www.gnu.org/software/tar/)
- [Verilator](https://www.verilator.org/)
- [Device Tree Compiler (dtc)](https://git.kernel.org/pub/scm/utils/dtc/dtc.git)
- A working internet connection

# Important notices
- This script was mostly made to run on my personal computer, which runs on `Arch Linux 5.19.10`. Other versions or distributions of Linux are not guaranteed to work as effectively, or even at all.
- I strongly dislike when software is installed without explicit notice onto my computer. So, all dependencies that are downloaded when the script runs will be put into a controlled directory, which will live under the environment variable `RISCV`. The script will force you to set this variable before running.
- The version of Verilator that is installed in `pacman.fish` is very specifically version `4.200`. This is because the CVA6 is very iffy about what version it is able to compile with, and the latest version does not compile it without some patches. I'm not certain that these patches actually fix the problem, so rolling back to an older version seems to be the safer bet.
- __I have not personally seen any output from the Linux kernel image running on the CVA6 simulator.__
    - __HOWEVER__,
        - The CVA6 is designed to have nearly identical output to [Spike](https://github.com/riscv-software-src/riscv-isa-sim), RISC-V's official ISA emulator.
        - A userspace "Hello World" program does run on the CVA6, but orders of magnitude slower than Spike.
        - Spike runs the chosen Linux image perfectly.
    - __SO__,
        - I am concluding that the CVA6 would _eventually_ boot the image. But I do not have the time, skill, or patience to debug the simulator's code, and verify that it actually works. I assume that would be a task to be tackled if I am accepted to this position.
