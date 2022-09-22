#!/bin/fish

function log --description "Logs some status in yellow text."
    set_color yellow
    echo "[LOG]: $argv[1]"
    set_color normal
end

function error --description "Logs an error in red text."
    set_color red
    echo "[ERROR]: $argv[1]" >&2
    set_color normal
end

function check_deps --description "Checks if all the needed executables exist"
    set deps pacman make git
    for dep in $deps
        if ! type --query $dep
            error "You don't have $dep!"
            error "Please make sure you have all binaries required: ($deps)"
            exit 1
        end
    end
end

function check_riscv --description "Checks if RISCV environment variable is set"
    if ! set -q RISCV
        error "You haven't set your preferred path for downloading dependencies!"
        error "Please set the environment variable RISCV and run this script again."
        exit 1
    end
end

function main
    check_riscv
    check_deps

    # Make the directory for dependencies if it doesn't exist.
    if ! test -e $RISCV
        mkdir --parents $RISCV
        log "Created directory for dependencies ($RISCV)"
    end
end

main
