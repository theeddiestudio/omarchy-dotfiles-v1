function nbs
    set -l argCount (count $argv)
    set_color cyan

    echo ---------------------------------
    if test $argCount -eq 2
        echo "Setting the Speed of $argv[1] for Fan $argv[2]"
        sudo nbfc set -s $argv[1] -f $argv[2]
    else if test $argCount -eq 1
        if test $argv[1] = -h; or test $argv[1] = --help
            echo "Usage: nbs <Speed Percentage> [Optional - Fan Index]"
            echo ---------------------------------
            return 0
        end
        echo "Setting the Speed of $argv[1] for all Fans"
        sudo nbfc set -s $argv[1]
    else
        set_color red
        echo "Invalid Input......."
        set_color cyan
        nbs -h
        return 1
    end
    echo ---------------------------------
end
