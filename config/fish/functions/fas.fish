function fas
    set_color cyan
    echo ---------------------------------

    if test (count $argv) -eq 1
        if test $argv[1] = -h; or test $argv[1] = --help
            echo "There are three ways of using this command."
            echo "Usage1: fas [Speed]"
            echo "Usage2: fas [Mode] [Speed]"
            echo "Usage3: fas [Mode] [Speed] [Brightness]"
            echo "Usage4: fas [Mode] [Speed] [Brightness] [Direction]"
            echo ---------------------------------
            return 0
        end
        echo "Setting Speed to $argv[1]"
        /opt/turbo-fan/facer_rgb.py -s $argv[1] -save current
    else if test (count $argv) -eq 2
        echo "Setting Mode to $argv[1] and Speed to $argv[2]"
        /opt/turbo-fan/facer_rgb.py -m $argv[1] -s $argv[2] -save current
    else if test (count $argv) -eq 3
        echo "Setting Mode to $argv[1], Speed to $argv[2] and Brightness to $argv[3]"
        /opt/turbo-fan/facer_rgb.py -m $argv[1] -s $argv[2] -b $argv[3] -save current
    else if test (count $argv) -eq 4
        echo "Setting Mode to $argv[1], Speed to $argv[2], Brightness to $argv[3] and Direction to $argv[4]"
        /opt/turbo-fan/facer_rgb.py -m $argv[1] -s $argv[2] -b $argv[3] -d $argv[4] -save current
    else
        set_color red
        echo "Invalid Input......."
        set_color cyan
        fas -h
        return 1
    end
    echo ---------------------------------
end
