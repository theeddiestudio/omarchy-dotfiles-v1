mkdir -p "$(xdg-user-dir PICTURES)/screenshots"
screenshot_path="$(xdg-user-dir PICTURES)/screenshots/$(date +'%Y%m%d_%Hh%Mm%Ss').png"

grim -l 0 -c - > "$screenshot_path"

if [ -f "$screenshot_path" ]; then
    copyq write image/png - < "$screenshot_path"
    copyq select 0
fi
