#!/bin/fish

function log --description "Logs a status in green text."
    set_color green
    echo "[LOG]: $argv[1]"
    set_color normal
end

function warn --description "Logs a warning in yellow text."
    set_color yellow
    echo "[WARN]: $argv[1]" >&2
    set_color normal
end

function error --description "Logs an error in red text."
    set_color red
    echo "[ERROR]: $argv[1]" >&2
    set_color normal
end
