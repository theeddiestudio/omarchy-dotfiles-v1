function nba
    set_color cyan
    echo ---------------------------------
    if test (count $argv) -gt 1
        set_color red
        echo "Invalid Input......."
        set_color cyan
        nba -h
        return 1
    else if test (count $argv) -eq 1
        if test $argv[1] = -h; or test $argv[1] = --help
            echo "Usage: nba [Optional - Fan Index]"
            echo ---------------------------------
            return 0
        end
        echo "Setting the Fan $argv[1] to Auto Mode"
        sudo nbfc set -a -f $argv
    else
        echo "Setting all the Fans to Auto Mode"
        sudo nbfc set -a $argv
    end
    echo ---------------------------------
end
