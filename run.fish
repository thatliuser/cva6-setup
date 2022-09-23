#!/bin/fish

source lib/log.fish

## This section is extremely overengineered. Sorry about that.
function demos --description "Maps all demos to their binary paths."
    for pair in \
        "linux=linux" \
        "bbl=riscv64-unknown-elf/bin/bbl" \
        "hello=riscv64-unknown-elf/bin/pk hello"
        echo "$pair"
    end
end

function drivers --description "Maps all drivers to their binary paths."
    for pair in \
        "cva=cva6/work-ver/Variane_testharness" \
        "spike=bin/spike"
        echo "$pair"
    end
end

function get_key --description "Gets the key in a pair."
    echo "$argv[1]" | read --delimiter "=" key val
    echo "$key"
end

function get_val --description "Gets the value in a pair."
    echo "$argv[1]" | read --delimiter "=" key val
    echo "$val"
end

function unsetup --description "Tells the user to run `setup.fish`, and come back after."
    error "This probably means you haven't run `setup.fish` yet."
    error "Please run the setup, then come back to run any demos!"
    exit 1
end

function bad_usage --description "Prints the proper usage of this script."
    error "Usage: $(basename (status filename)) [driver] [demo]"
    set demos (
        for pair in (demos)
            echo "$(get_key $pair)"
        end
    )
    set drivers (
        for pair in (drivers)
            echo "$(get_key $pair)"
        end
    )
    error "Available drivers are: $drivers"
    error "Available demos are: $demos"
    exit 1
end

function main
    if ! set -q RISCV
        error "The environment variable RISCV isn't set!"
        unsetup
    end

    if ! test -e "$RISCV"
        error "Your output directory doesn't exist!"
        unsetup
    end

    if test (count $argv) -ne 2
        bad_usage
    end

    set driver (
            for pair in (drivers)
                if test "$argv[1]" = (get_key "$pair")
                    echo "$(get_val $pair)"
                end
            end
        )
    set demo (
            for pair in (demos)
                if test "$argv[2]" = (get_key "$pair")
                    echo "$(get_val $pair)"
                end
            end
        )

    if test "$driver" = "" | test "$demo" = ""
        error "Couldn't find a matching driver and/or demo!"
        bad_usage
    end

    log "NOTE: The CVA driver is very, very slow compared to Spike."
    log "Be patient when running it!"
    log "Also, keep in mind that the linux demo isn't proven to work on CVA."
    log "Running command $(basename $driver) $demo`..."

    set args "$driver" (string split " " "$demo")
    # All the arguments are relative paths from RISCV, so make them absolute!
    "$RISCV/"$args
end

main $argv
