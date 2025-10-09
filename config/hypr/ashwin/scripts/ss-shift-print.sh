mkdir -p "$(xdg-user-dir PICTURES)/screenshots/selection"
screenshot_path="$(xdg-user-dir PICTURES)/screenshots/selection/$(date +'%Y%m%d_%Hh%Mm%Ss').png"

grim -l 0 -c -g "$(slurp)" - > "$screenshot_path"

if [ -f "$screenshot_path" ]; then
    copyq write image/png - < "$screenshot_path"
    copyq select 0
fi
