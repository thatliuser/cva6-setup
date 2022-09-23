#!/bin/fish

function deps --description "Prints all required dependencies."
    # Fish being a dependency here is kind of dumb, but it's still... a dependency.
    for dep in fish make git curl tar dtc verilator
        echo "$dep"
    end
end

function app_exists --description "Checks if an app exists. Usable in an if condition."
    return (type --query "$argv[1]")
end
