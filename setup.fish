#!/bin/fish

source lib/deps.fish
source lib/log.fish

function make_dir --description "Creates a directory unless it already exists"
    set dir "$argv[1]"
    if ! test -e "$dir"
        log "Creating directory $dir"
        mkdir --parents "$dir"
    end
end

function clone_github --description "Clones a GitHub repository into the right directory."
    set user "$argv[1]"
    set repo "$argv[2]"
    set commit "$argv[3]"

    log "Cloning GitHub repository $user/$repo"
    git clone --recurse-submodules "https://github.com/$user/$repo" "$RISCV/$repo"

    if test "$commit" != ""
        set root (pwd)
        # Commit specified; switch to the right commit.
        cd "$RISCV/$repo"
        log "Switching to commit $commit"
        git checkout $commit
        cd "$root"
    end
end

function main
    # If we ever need to get back to the script directory. (which we do!)
    set root (pwd)
    if ! set -q RISCV
        error "You haven't set your preferred path for downloading dependencies!"
        error "Please set the environment variable RISCV and run this script again."
        exit 1
    end

    if ! set -q JOBS
        error "You haven't set your preferred number of threads for `make`!"
        error "Please set the environment variable JOBS and run this script again."
        exit 1
    end

    # Check dependencies.
    set deps (deps)
    for dep in $deps
        if ! app_exists "$dep"
            error "You don't have a required dependency: $dep!"
            error "Please make sure you have all dependencies before proceeding: $deps"
            error "You can use `pacman.fish` to install all dependencies if you are on Arch Linux."
            exit 1
        end
    end

    # Make the directory for dependencies if it doesn't exist.
    make_dir $RISCV

    ## Official RISC-V ISA simulator (Spike) and other libraries we need.
    clone_github riscv riscv-isa-sim 35d50bc40e59ea1d5566fbd3d9226023821b1bb6

    log "Configuring ISA simulator"
    cd "$RISCV/riscv-isa-sim"
    make_dir build
    cd build
    ../configure --prefix="$RISCV"

    # This could be better; this step takes a WHILE
    # and we don't actually need everything here.
    # Could definitely be cut down to save time, but
    # I don't have enough time to investigate optimization!
    log "Building ISA simulator"
    make --jobs="$JOBS" install

    ## The RISC-V proxy kernel and Berkeley boot loader. Useful
    ## for running on our simulator later!
    clone_github riscv riscv-pk

    log "Configuring proxy kernel"
    cd "$RISCV/riscv-pk"
    make_dir build
    cd build
    PATH="$RISCV/bin:$PATH" ../configure --prefix="$RISCV" --host=riscv64-unknown-elf

    log "Building proxy kernel"
    PATH="$RISCV/bin:$PATH" make --jobs="$JOBS" install

    ## The RISC-V GCC toolchain we need to compile a userspace "Hello World" program.
    log "Downloading RISC-V compiler toolchain"
    set gcc riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14
    curl --output-dir "$RISCV" --remote-name \
        "https://static.dev.sifive.com/dev-tools/$gcc.tar.gz"

    log "Extracting RISC-V compiler toolchain"
    tar --get --gzip --directory "$RISCV" -f "$RISCV/$gcc.tar.gz"
    cp --recursive $RISCV/$gcc/* "$RISCV"
    rm --recursive --force "$RISCV/$gcc"
    rm --force "$RISCV/$gcc.tar.gz"

    ## The userspace "Hello World" program itself.
    log "Compiling userspace \"Hello World\" program"
    "$RISCV/bin/riscv64-unknown-elf-gcc" "$root/misc/hello.c" --output "$RISCV/hello"

    ## The Linux kernel image for the simulator (and Spike!)
    log "Downloading Linux kernel image"
    # We need to follow GitHub's redirect.
    curl --output-dir "$RISCV" --remote-name --location \
        https://github.com/openhwgroup/cva6-sdk/releases/download/v0.3.0/bbl

    ## The CPU itself.
    clone_github openhwgroup cva6

    log "Patching CVA6 simulator"
    cd "$RISCV/cva6"
    # Comments out some code that stops the simulator
    # after hitting some instruction (that shows up in the Hello World program)
    # or after it simulates too many cycles. Not very good if you want to simulate
    # the entire Linux kernel!
    git apply "$root/misc/cva6.patch"

    log "Compiling CVA6 simulator"
    NUM_JOBS=$JOBS make verilate

    log "Done! You can now run `run.fish` to demonstrate the simulator's capabilities!"
end

main
