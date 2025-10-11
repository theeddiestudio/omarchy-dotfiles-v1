function rm
    argparse -x d,h,r,empty-trash,restore-all \
        d/perma \
        h/help \
        'r/restore=' \
        empty-trash \
        restore-all \
        -- $argv
    or begin
        # argparse handles the error and returns 1 if conflicting flags are used.
        rm -h
        return 1# pass 1 as the return code
    end

    # Set the trash directory. It's good practice to ensure it exists.
    set TRASH_DIR $HOME/.trash_can
    set LOG_FILE "$TRASH_DIR/trash_logs.csv"

    # --- HANDLE --empty-trash ---
    if set -q _flag_empty_trash
        if test (count $argv) -ne 0
            echo "Inavlid Usage"
            rm -h
            return 1
        end
        if not test -d "$TRASH_DIR"
            echo "Trash can '$TRASH_DIR' does not exist."
            return 0
        end
        echo "WARNING: Permanently deleting the entire trash can and all its contents."
        read -P "Are you sure you want to proceed? (yes/No): " confirmation

        if test (string lower "$confirmation") = yes; or test (string lower "$confirmation") = y
            # Use the system's rm to delete the trash directory recursively and forcefully
            /usr/bin/rm -rf "$TRASH_DIR"
            echo "Trash can permanently deleted."
        else
            echo "Deletion cancelled."
            return $status
        end
        return 0
    end

    # --- PERMANENT DELETE LOGIC ---
    if set -q _flag_d
        # If the -d flag is present, use the real /usr/bin/rm
        /usr/bin/rm -rf $argv
        return $status
    end

    if set -q _flag_h
        echo "this is help"
        return 0
    end

    # Create the trash directory if it doesn't exist
    if not test -d "$TRASH_DIR"
        mkdir -p "$TRASH_DIR"
    end

    if not test -f "$LOG_FILE"
        echo "Identifier,Original_Path,Deletion_Time" >"$LOG_FILE"
    end

    # Check if any arguments were provided
    if count $argv >/dev/null
        for item in $argv
            if test -e "$item"
                set original_abs_path (path resolve "$item")
                set filename (path basename "$item")
                set timestamp (date '+%Y-%m-%d-%H%M%S')
                # for the trash log and trash folder prevent copying
                if test "$original_abs_path" = (path resolve "$LOG_FILE"); or test "$original_abs_path" = (path resolve "$TRASH_DIR")
                    set_color -o red
                    echo "Cannot delete trash. Use --empty-trash instead."
                    set_color normal
                    continue # Skip this item and move to the next one
                end

                if test -e "$TRASH_DIR/$filename"
                    set filename (basename "$item")"_"$timestamp
                end
                echo "Moving '$item' to '$TRASH_DIR/$filename'"
                mv "$item" "$TRASH_DIR/$filename"

                # Log the event to log file
                printf "%s,%s,%s\n" "$filename" "$original_abs_path" "$timestamp" >>"$LOG_FILE"
            end
        end
    else
        # If no arguments, show usage info (optional)
        echo "Usage: rm <file/directory>..."
    end
end
