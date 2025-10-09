function faz
    set_color cyan
    echo ---------------------------------

    # === HELP SECTION ===
    if test (count $argv) -eq 1
        if test $argv[1] = -h; or test $argv[1] = --help
            echo "Usage:"
            echo "  faz [Color]                     → Set all zones (1–4) to same color"
            echo "  faz [Color1] [Color2]           → Set zones 1–2 = Color1, zones 3–4 = Color2"
            echo "  faz [Color1] [Color2] [Color3]  → Set zone 1 = Color1, 2–3 = Color2, 4 = Color3"
            echo "  faz -z [ZoneID] -c [Color]      → Set a specific zone manually"
            echo
            echo "Colors can be provided in HEX (000000–FFFFFF) or as names:"
            echo "  w/white → White (#FFFFFF)"
            echo "  r/red   → Red (#FF0000)"
            echo "  g/green → Green (#00FF00)"
            echo "  b/blue  → Blue (#0000FF)"
            echo "  c/cyan  → Cyan (#00FFFF)"
            echo "  y/yellow→ Yellow (#FFFF00)"
            echo "  p/purple→ Purple (#800080)"
            echo "  o/orange→ Orange (#FFA500)"
            echo
            echo "Examples:"
            echo "  faz red                 → All zones red"
            echo "  faz red blue            → Zones 1–2 red, 3–4 blue"
            echo "  faz red blue green      → 1=red, 2–3=blue, 4=green"
            echo "  faz -z 2 -c #00FF00     → Only zone 2 green"
            echo ---------------------------------
            return 0
        end
    end

    # === COLOR MAP FUNCTION ===
    function color_to_rgb
        set input (string lower $argv[1])

        switch $input
            case w white
                echo "255 255 255"
            case r red
                echo "255 0 0"
            case g green
                echo "0 255 0"
            case b blue
                echo "0 0 255"
            case c cyan
                echo "0 255 255"
            case y yellow
                echo "255 255 0"
            case p purple
                echo "128 0 128"
            case o orange
                echo "255 165 0"
            case '*'
                # Handle hex like 00FF00 or 0F0 shorthand
                set hex (string replace -a "#" "" $input)
                if test (string length $hex) -eq 3
                    set r (string sub -s 1 -l 1 $hex)
                    set g (string sub -s 2 -l 1 $hex)
                    set b (string sub -s 3 -l 1 $hex)
                    set r "$r$r"
                    set g "$g$g"
                    set b "$b$b"
                else if test (string length $hex) -ne 6
                    echo ERR
                    return
                else
                    set r (string sub -s 1 -l 2 $hex)
                    set g (string sub -s 3 -l 2 $hex)
                    set b (string sub -s 5 -l 2 $hex)
                end
                echo (math "0x$r") (math "0x$g") (math "0x$b")
        end
    end

    # === ZONE/COLOR PARSER ===
    if test (count $argv) -eq 0
        set_color red
        echo "Error: No arguments provided!"
        set_color cyan
        echo "Try 'faz -h' for help."
        echo ---------------------------------
        return 1
    end

    if test $argv[1] = -z
        if test (count $argv) -lt 4; or test $argv[3] != -c
            set_color red
            echo "Invalid syntax. Use: faz -z [ZoneID] -c [Color]"
            set_color cyan
            echo ---------------------------------
            return 1
        end
        set zone $argv[2]
        set color (color_to_rgb $argv[4])
        if test -z "$color"; or test "$color" = "ERR"
            set_color red
            echo "Invalid color input '$argv[4]'. Try hex (e.g. FF0000) or a named color like red, g, w, etc."
            set_color cyan
            echo ---------------------------------
        return 1
        end

        set cR (echo $color | awk '{print $1}')
        set cG (echo $color | awk '{print $2}')
        set cB (echo $color | awk '{print $3}')
        echo "Setting Zone $zone → RGB($cR,$cG,$cB)"
        /opt/turbo-fan/facer_rgb.py -m 0 -z $zone -cR $cR -cG $cG -cB $cB -save current
        echo ---------------------------------
        return 0
    end

    # === AUTO MODE ===
    switch (count $argv)
        case 1
            set color1 (color_to_rgb $argv[1])
            if test "$color1" = ERR
                set_color red
                echo "Invalid color input."
                set_color cyan
                echo ---------------------------------
                return 1
            end
            for zone in 1 2 3 4
                set cR (echo $color1 | awk '{print $1}')
                set cG (echo $color1 | awk '{print $2}')
                set cB (echo $color1 | awk '{print $3}')
                echo "Setting Zone $zone → RGB($cR,$cG,$cB)"
                /opt/turbo-fan/facer_rgb.py -m 0 -z $zone -cR $cR -cG $cG -cB $cB -save current
            end

        case 2
            set color1 (color_to_rgb $argv[1])
            set color2 (color_to_rgb $argv[2])
            if test "$color1" = ERR -o "$color2" = ERR
                set_color red
                echo "Invalid color input."
                set_color cyan
                echo ---------------------------------
                return 1
            end
            for zone in 1 2
                set cR (echo $color1 | awk '{print $1}')
                set cG (echo $color1 | awk '{print $2}')
                set cB (echo $color1 | awk '{print $3}')
                echo "Setting Zone $zone → RGB($cR,$cG,$cB)"
                /opt/turbo-fan/facer_rgb.py -m 0 -z $zone -cR $cR -cG $cG -cB $cB -save current
            end
            for zone in 3 4
                set cR (echo $color2 | awk '{print $1}')
                set cG (echo $color2 | awk '{print $2}')
                set cB (echo $color2 | awk '{print $3}')
                echo "Setting Zone $zone → RGB($cR,$cG,$cB)"
                /opt/turbo-fan/facer_rgb.py -m 0 -z $zone -cR $cR -cG $cG -cB $cB -save current
            end

        case 3
            set color1 (color_to_rgb $argv[1])
            set color2 (color_to_rgb $argv[2])
            set color3 (color_to_rgb $argv[3])
            if test "$color1" = ERR -o "$color2" = ERR -o "$color3" = ERR
                set_color red
                echo "Invalid color input."
                set_color cyan
                echo ---------------------------------
                return 1
            end
            # zone 1
            set cR (echo $color1 | awk '{print $1}')
            set cG (echo $color1 | awk '{print $2}')
            set cB (echo $color1 | awk '{print $3}')
            echo "Setting Zone 1 → RGB($cR,$cG,$cB)"
            /opt/turbo-fan/facer_rgb.py -m 0 -z 1 -cR $cR -cG $cG -cB $cB -save current
            # zones 2–3
            for zone in 2 3
                set cR (echo $color2 | awk '{print $1}')
                set cG (echo $color2 | awk '{print $2}')
                set cB (echo $color2 | awk '{print $3}')
                echo "Setting Zone $zone → RGB($cR,$cG,$cB)"
                /opt/turbo-fan/facer_rgb.py -m 0 -z $zone -cR $cR -cG $cG -cB $cB -save current
            end
            # zone 4
            set cR (echo $color3 | awk '{print $1}')
            set cG (echo $color3 | awk '{print $2}')
            set cB (echo $color3 | awk '{print $3}')
            echo "Setting Zone 4 → RGB($cR,$cG,$cB)"
            /opt/turbo-fan/facer_rgb.py -m 0 -z 4 -cR $cR -cG $cG -cB $cB -save current

        case '*'
            set_color red
            echo "Invalid number of arguments!"
            set_color cyan
            echo "Try 'faz -h' for help."
            echo ---------------------------------
            return 1
    end

    echo ---------------------------------
end
