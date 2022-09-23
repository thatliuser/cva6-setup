#!/bin/fish

source lib/deps.fish
source lib/log.fish

function main
    if ! app_exists pacman
        error "Pacman wasn't found! Cannot proceed."
        exit 1
    end
    set root (
                if app_exists sudo
                    echo "sudo"
                else if app_exists doas
                    echo "doas"
                else
                    error "No root escalation app found! Cannot proceed."
                    exit 1
                end
            )
    for dep in (deps)
        if app_exists "$dep"
            warn "Dependency $dep exists. Skipping installation."
        else if test "$dep" != verilator
            log "Installing dependency $dep..."
            $root pacman -Syu $dep
        else
            log "Installing verilator (old version 4.200)"
            set verilator verilator-4.200-1-x86_64.pkg.tar.zst
            # Curl should be installed at this point so we should be fine.
            curl --remote-name https://archive.archlinux.org/packages/v/verilator/$verilator
            $root pacman -U $verilator
            rm $verilator
        end
    end
end

main
