function fab
    set_color cyan
    echo ---------------------------------

    if test (count $argv) -ne 1
        set_color red
        echo "Invalid Input......."
        set_color cyan
        fab -h
        return 1
    end
    if test (count $argv) -eq 1
        if test $argv[1] = -h; or test $argv[1] = --help
            echo "Usage: fab [Brightness Percentage]"
            echo ---------------------------------
            return 0
        end
    end
    echo "Setting the brightness to $argv"
    /opt/turbo-fan/facer_rgb.py -b $argv -save current
    echo ---------------------------------
end
