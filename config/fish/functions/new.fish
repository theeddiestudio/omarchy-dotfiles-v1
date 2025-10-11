function new
    argparse d/delete -- $argv
    echo $argv

    if set -q _flag_d
        echo "flag set"
        echo $argv
    end
end
