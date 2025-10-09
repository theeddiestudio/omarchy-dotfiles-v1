function fac
    set_color cyan
    echo ---------------------------------

    if test (count $argv) -eq 0
        set_color red
        echo "Invalid Input......."
        set_color cyan
        fac -h
        return 1
    end
    if test (count $argv) -eq 1
        if test $argv[1] = -h; or test $argv[1] = --help
            echo "Usage: fac [Modes - See the github for modes and zones]"
            echo ---------------------------------
            return 0
        end
    end
    echo "Setting the Keyboard Backlight as per given options..."
    /opt/turbo-fan/facer_rgb.py $argv -save current
    echo ---------------------------------
end
