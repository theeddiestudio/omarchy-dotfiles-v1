#!/bin/bash

ARGS="$1"
CLASS="$2"
if [[ -z "$4" ]]; then
    PROFILE="$2"
else
    PROFILE="$4"
fi
if [[ "$3" == "--no-url" ]]; then
    URL="--restore-last-session"
else
    URL="$3"
fi
echo $PROFILE
echo $ARGS

if [ -z "$CLASS" ]]; then
    echo "Usage: $0 <class_name> <url> [profile_name]"
    exit 1
fi

WINADDR=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$CLASS\") | .address")
echo $WINADDR

if [ -n "$WINADDR" ]; then
    echo "Window exists: $WINADDR"

    CURRENT_WS=$(hyprctl activeworkspace | grep "workspace ID" | grep -oP '(?<=workspace ID )\d+')
    #WIN_WS=$(hyprctl -j clients | jq -r ".[] | select(.class==\"$CLASS\") | .workspace.id")

    # Focus and move to the current workspace
    hyprctl dispatch focuswindow address:"$WINADDR"
    hyprctl dispatch movetoworkspace $CURRENT_WS
else
    echo "Window not found, launching Firefox..."

    # Launch Firefox webapp in kiosk mode
    hyprctl dispatch exec "env MOZ_ENABLE_WAYLAND=1 firefox -P \"$PROFILE\" $ARGS --name=\"$CLASS\" \"$URL\""

    while [[ -z "$WINADDR" ]]; do
      WINADDR=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$CLASS\") | .address")
      sleep 0.7
    done

    # Smoothly disable fullscreen and center window
    if [ -n "$WINADDR" ]; then
        hyprctl dispatch fullscreenstate 0 0 address:$WINADDR
        hyprctl dispatch resizewindowpixel exact 1280 800 address:$WINADDR
        hyprctl dispatch centerwindow address:$WINADDR
        echo "🪄 Unfullscreened and centered: $CLASS ($WINADDR)"
    else
        echo "⚠️  No window found for class: $CLASS"
    fi
fi
