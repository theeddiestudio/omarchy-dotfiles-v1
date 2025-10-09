function fadir
    # Use unquoted tilde for expansion
    set FAN_CONFIG ~/.config/predator/saved\ profiles/current.json

    # Ensure the config file exists
    if not test -f "$FAN_CONFIG"
        echo 1
        return 0
    end

    set -l current_direction
    set -l new_direction 1

    if type -q jq
        set current_direction (jq -r '.direction // 0' "$FAN_CONFIG")
    else
        set current_direction (grep -oP '"direction"\s*:\s*\K[^,]+' "$FAN_CONFIG" | tr -d ' ' | tr -d '\n')
    end

    set current_direction (string trim $current_direction)
    set current_direction (string replace -r '[^0-9]' '' $current_direction)

    if test "$current_direction" -eq 1
        set new_direction 2
    else if test "$current_direction" -eq 2
        set new_direction 1
    else
        set new_direction 1
    end

    echo $new_direction
end

function fad
    set_color cyan
    echo ---------------------------------

    if test (count $argv) -eq 0
        set -l new_dir (fadir)
        echo "Toggling Direction to $new_dir"
        /opt/turbo-fan/facer_rgb.py -d $new_dir -save current
    else if test (count $argv) -eq 1
        if test $argv[1] = -h; or test $argv[1] = --help
            echo "Usage1: fad - this will toggle the direction"
            echo "Usage2: fad [Direction - 1 for RTL and 2 for LTR]"
            echo ---------------------------------
            return 0
        end
        echo "Changing Direction to $argv[1]"
        /opt/turbo-fan/facer_rgb.py -d $argv[1] -save current
    else
        set_color red
        echo "Invalid Input......."
        set_color cyan
        fad -h
        return 1
    end
    echo ---------------------------------
end
