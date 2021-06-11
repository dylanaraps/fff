#!/usr/bin/env bash
#
# fff - fucking fast file-manager.

get_os() {
    # Figure out the current operating system to set some specific variables.
    # '$OSTYPE' typically stores the name of the OS kernel.
    case $OSTYPE in
        # Mac OS X / macOS.
        darwin*)
            opener=open
            file_flags=bIL
        ;;

        haiku)
            opener=open

            [[ -z $FFF_TRASH_CMD ]] &&
                FFF_TRASH_CMD=trash

            [[ $FFF_TRASH_CMD == trash ]] && {
                FFF_TRASH=$(finddir -v "$PWD" B_TRASH_DIRECTORY)
                mkdir -p "$FFF_TRASH"
            }
        ;;
    esac
}

setup_terminal() {
    # Setup the terminal for the TUI.
    # '\e[?1049h': Use alternative screen buffer.
    # '\e[?7l':    Disable line wrapping.
    # '\e[?25l':   Hide the cursor.
    # '\e[2J':     Clear the screen.
    # '\e[1;Nr':   Limit scrolling to scrolling area.
    #              Also sets cursor to (0,0).
    printf '\e[?1049h\e[?7l\e[?25l\e[2J\e[1;%sr' "$max_items"

    # Hide echoing of user input
    stty -echo
}

reset_terminal() {
    # Reset the terminal to a useable state (undo all changes).
    # '\e[?7h':   Re-enable line wrapping.
    # '\e[?25h':  Unhide the cursor.
    # '\e[2J':    Clear the terminal.
    # '\e[;r':    Set the scroll region to its default value.
    #             Also sets cursor to (0,0).
    # '\e[?1049l: Restore main screen buffer.
    printf '\e[?7h\e[?25h\e[2J\e[;r\e[?1049l'

    # Show user input.
    stty echo
}

clear_screen() {
    # Only clear the scrolling window (dir item list).
    # '\e[%sH':    Move cursor to bottom of scroll area.
    # '\e[9999C':  Move cursor to right edge of the terminal.
    # '\e[1J':     Clear screen to top left corner (from cursor up).
    # '\e[2J':     Clear screen fully (if using tmux) (fixes clear issues).
    # '\e[1;%sr':  Clearing the screen resets the scroll region(?). Re-set it.
    #              Also sets cursor to (0,0).
    printf '\e[%sH\e[9999C\e[1J%b\e[1;%sr' \
           "$((LINES-2))" "${TMUX:+\e[2J}" "$max_items"
}

setup_options() {
    # Some options require some setup.
    # This function is called once on open to parse
    # select options so the operation isn't repeated
    # multiple times in the code.

    # Format for normal files.
    [[ $FFF_FILE_FORMAT == *%f* ]] && {
        file_pre=${FFF_FILE_FORMAT/'%f'*}
        file_post=${FFF_FILE_FORMAT/*'%f'}
    }

    # Format for marked files.
    # Use affixes provided by the user or use defaults, if necessary.
    if [[ $FFF_MARK_FORMAT == *%f* ]]; then
        mark_pre=${FFF_MARK_FORMAT/'%f'*}
        mark_post=${FFF_MARK_FORMAT/*'%f'}
    else
        mark_pre=" "
        mark_post="*"
    fi

    # Find supported 'file' arguments.
    file -I &>/dev/null || : "${file_flags:=biL}"
}

get_term_size() {
    # Get terminal size ('stty' is POSIX and always available).
    # This can't be done reliably across all bash versions in pure bash.
    read -r LINES COLUMNS < <(stty size)

    # Max list items that fit in the scroll area.
    ((max_items=LINES-3))
}

get_ls_colors() {
    # Parse the LS_COLORS variable and declare each file type
    # as a separate variable.
    # Format: ':.ext=0;0:*.jpg=0;0;0:*png=0;0;0;0:'
    [[ -z $LS_COLORS ]] && {
        FFF_LS_COLORS=0
        return
    }

    # Turn $LS_COLORS into an array.
    IFS=: read -ra ls_cols <<< "$LS_COLORS"

    for ((i=0;i<${#ls_cols[@]};i++)); {
        # Separate patterns from file types.
        [[ ${ls_cols[i]} =~ ^\*[^\.] ]] &&
            ls_patterns+="${ls_cols[i]/=*}|"

        # Prepend 'ls_' to all LS_COLORS items
        # if they aren't types of files (symbolic links, block files etc.)
        [[ ${ls_cols[i]} =~ ^(\*|\.) ]] && {
            ls_cols[i]=${ls_cols[i]#\*}
            ls_cols[i]=ls_${ls_cols[i]#.}
        }
    }

    # Strip non-ascii characters from the string as they're
    # used as a key to color the dir items and variable
    # names in bash must be '[a-zA-z0-9_]'.
    ls_cols=("${ls_cols[@]//[^a-zA-Z0-9=\\;]/_}")

    # Store the patterns in a '|' separated string
    # for use in a REGEX match later.
    ls_patterns=${ls_patterns//\*}
    ls_patterns=${ls_patterns%?}

    # Define the ls_ variables.
    # 'declare' can't be used here as variables are scoped
    # locally. 'declare -g' is not available in 'bash 3'.
    # 'export' is a viable alternative.
    export "${ls_cols[@]}" &>/dev/null
}

get_w3m_path() {
    # Find the path to the w3m-img library.
    w3m_paths=(/usr/{pkg/,}{local/,}{bin,lib,libexec,lib64,libexec64}/w3m/w3mi*)
    read -r w3m _ < <(type -p "$FFF_W3M_PATH" w3mimgdisplay "${w3m_paths[@]}")
}

get_mime_type() {
    # Get a file's mime_type.
    mime_type=$(file "-${file_flags:-biL}" "$1" 2>/dev/null)
}

status_line() {
    # Status_line to print when files are marked for operation.
    local mark_ui="[${#marked_files[@]}] selected (${file_program[*]}) [p] ->"

    # Escape the directory string.
    # Remove all non-printable characters.
    PWD_escaped=${PWD//[^[:print:]]/^[}

    # '\e7':       Save cursor position.
    #              This is more widely supported than '\e[s'.
    # '\e[%sH':    Move cursor to bottom of the terminal.
    # '\e[30;41m': Set foreground and background colors.
    # '%*s':       Insert enough spaces to fill the screen width.
    #              This sets the background color to the whole line
    #              and fixes issues in 'screen' where '\e[K' doesn't work.
    # '\r':        Move cursor back to column 0 (was at EOL due to above).
    # '\e[m':      Reset text formatting.
    # '\e[H\e[K':  Clear line below status_line.
    # '\e8':       Restore cursor position.
    #              This is more widely supported than '\e[u'.
    printf '\e7\e[%sH\e[3%s;4%sm%*s\r%s %s%s\e[m\e[%sH\e[K\e8' \
           "$((LINES-1))" \
           "${FFF_COL5:-0}" \
           "${FFF_COL2:-1}" \
           "$COLUMNS" "" \
           "($((scroll+1))/$((list_total+1)))" \
           "${marked_files[*]:+${mark_ui}}" \
           "${1:-${PWD_escaped:-/}}" \
           "$LINES"
}

read_dir() {
    # Read a directory to an array and sort it directories first.
    local dirs
    local files
    local item_index

    # Set window name.
    printf '\e]2;fff: %s\e'\\ "$PWD"

    # If '$PWD' is '/', unset it to avoid '//'.
    [[ $PWD == / ]] && PWD=

    for item in "$PWD"/*; do
        if [[ -d $item ]]; then
            dirs+=("$item")

            # Find the position of the child directory in the
            # parent directory list.
            [[ $item == "$OLDPWD" ]] &&
                ((previous_index=item_index))
            ((item_index++))
        else
            files+=("$item")
        fi
    done

    list=("${dirs[@]}" "${files[@]}")

    # Indicate that the directory is empty.
    [[ -z ${list[0]} ]] &&
        list[0]=empty

    ((list_total=${#list[@]}-1))

    # Save the original dir in a second list as a backup.
    cur_list=("${list[@]}")
}

print_line() {
    # Format the list item and print it.
    local file_name=${list[$1]##*/}
    local file_ext=${file_name##*.}
    local format
    local suffix

    # If the dir item doesn't exist, end here.
    if [[ -z ${list[$1]} ]]; then
        return

    # Directory.
    elif [[ -d ${list[$1]} ]]; then
        format+=\\e[${di:-1;3${FFF_COL1:-2}}m
        suffix+=/

    # Block special file.
    elif [[ -b ${list[$1]} ]]; then
        format+=\\e[${bd:-40;33;01}m

    # Character special file.
    elif [[ -c ${list[$1]} ]]; then
        format+=\\e[${cd:-40;33;01}m

    # Executable file.
    elif [[ -x ${list[$1]} ]]; then
        format+=\\e[${ex:-01;32}m

    # Symbolic Link (broken).
    elif [[ -h ${list[$1]} && ! -e ${list[$1]} ]]; then
        format+=\\e[${mi:-01;31;7}m

    # Symbolic Link.
    elif [[ -h ${list[$1]} ]]; then
        format+=\\e[${ln:-01;36}m

    # Fifo file.
    elif [[ -p ${list[$1]} ]]; then
        format+=\\e[${pi:-40;33}m

    # Socket file.
    elif [[ -S ${list[$1]} ]]; then
        format+=\\e[${so:-01;35}m

    # Color files that end in a pattern as defined in LS_COLORS.
    # 'BASH_REMATCH' is an array that stores each REGEX match.
    elif [[ $FFF_LS_COLORS == 1 &&
            $ls_patterns &&
            $file_name =~ ($ls_patterns)$ ]]; then
        match=${BASH_REMATCH[0]}
        file_ext=ls_${match//[^a-zA-Z0-9=\\;]/_}
        format+=\\e[${!file_ext:-${fi:-37}}m

    # Color files based on file extension and LS_COLORS.
    # Check if file extension adheres to POSIX naming
    # standard before checking if it's a variable.
    elif [[ $FFF_LS_COLORS == 1 &&
            $file_ext != "$file_name" &&
            $file_ext =~ ^[a-zA-Z0-9_]*$ ]]; then
        file_ext=ls_${file_ext}
        format+=\\e[${!file_ext:-${fi:-37}}m

    else
        format+=\\e[${fi:-37}m
    fi

    # If the list item is under the cursor.
    (($1 == scroll)) &&
        format+="\\e[1;3${FFF_COL4:-6};7m"

    # If the list item is marked for operation.
    [[ ${marked_files[$1]} == "${list[$1]:-null}" ]] && {
        format+=\\e[3${FFF_COL3:-1}m${mark_pre}
        suffix+=${mark_post}
    }

    # Escape the directory string.
    # Remove all non-printable characters.
    file_name=${file_name//[^[:print:]]/^[}

    printf '\r%b%s\e[m\r' \
        "${file_pre}${format}" \
        "${file_name}${suffix}${file_post}"
}

draw_dir() {
    # Print the max directory items that fit in the scroll area.
    local scroll_start=$scroll
    local scroll_new_pos
    local scroll_end

    # When going up the directory tree, place the cursor on the position
    # of the previous directory.
    ((find_previous == 1)) && {
        ((scroll_start=previous_index))
        ((scroll=scroll_start))

        # Clear the directory history. We're here now.
        find_previous=
    }

    # If current dir is near the top of the list, keep scroll position.
    if ((list_total < max_items || scroll < max_items/2)); then
        ((scroll_start=0))
        ((scroll_end=max_items))
        ((scroll_new_pos=scroll+1))

    # If current dir is near the end of the list, keep scroll position.
    elif ((list_total - scroll < max_items/2)); then
        ((scroll_start=list_total-max_items+1))
        ((scroll_new_pos=max_items-(list_total-scroll)))
        ((scroll_end=list_total+1))

    # If current dir is somewhere in the middle, center scroll position.
    else
        ((scroll_start=scroll-max_items/2))
        ((scroll_end=scroll_start+max_items))
        ((scroll_new_pos=max_items/2+1))
    fi

    # Reset cursor position.
    printf '\e[H'

    for ((i=scroll_start;i<scroll_end;i++)); {
        # Don't print one too many newlines.
        ((i > scroll_start)) &&
            printf '\n'

        print_line "$i"
    }

    # Move the cursor to its new position if it changed.
    # If the variable 'scroll_new_pos' is empty, the cursor
    # is moved to line '0'.
    printf '\e[%sH' "$scroll_new_pos"
    ((y=scroll_new_pos))
}

draw_img() {
    # Draw an image file on the screen using w3m-img.
    # We can use the framebuffer; set win_info_cmd as appropriate.
    [[ $(tty) == /dev/tty[0-9]* && -w /dev/fb0 ]] &&
        win_info_cmd=fbset

    # X isn't running and we can't use the framebuffer, do nothing.
    [[ -z $DISPLAY && $win_info_cmd != fbset ]] &&
        return

    # File isn't an image file, do nothing.
    get_mime_type "${list[scroll]}"
    [[ $mime_type != image/* ]] &&
        return

    # w3m-img isn't installed, do nothing.
    type -p "$w3m" &>/dev/null || {
        cmd_line "error: Couldn't find 'w3m-img', is it installed?"
        return
    }

    # $win_info_cmd isn't installed, do nothing.
    type -p "${win_info_cmd:=xdotool}" &>/dev/null || {
        cmd_line "error: Couldn't find '$win_info_cmd', is it installed?"
        return
    }

    # Get terminal window size in pixels and set it to WIDTH and HEIGHT.
    if [[ $win_info_cmd == xdotool ]]; then
        IFS=$'\n' read -d "" -ra win_info \
            < <(xdotool getactivewindow getwindowgeometry --shell)

        declare "${win_info[@]}" &>/dev/null || {
            cmd_line "error: Failed to retrieve window size."
            return
        }
    else
        [[ $(fbset --show) =~ .*\"([0-9]+x[0-9]+)\".* ]]
        IFS=x read -r WIDTH HEIGHT <<< "${BASH_REMATCH[1]}"
    fi

    # Get the image size in pixels.
    read -r img_width img_height < <("$w3m" <<< "5;${list[scroll]}")

    # Subtract the status_line area from the image size.
    ((HEIGHT=HEIGHT-HEIGHT*5/LINES))

    ((img_width > WIDTH)) && {
        ((img_height=img_height*WIDTH/img_width))
        ((img_width=WIDTH))
    }

    ((img_height > HEIGHT)) && {
        ((img_width=img_width*HEIGHT/img_height))
        ((img_height=HEIGHT))
    }

    clear_screen
    status_line "${list[scroll]}"

    # Add a small delay to fix issues in VTE terminals.
    ((BASH_VERSINFO[0] > 3)) &&
        read "${read_flags[@]}" -srn 1

    # Display the image.
    printf '0;1;%s;%s;%s;%s;;;;;%s\n3;\n4\n' \
        "${FFF_W3M_XOFFSET:-0}" \
        "${FFF_W3M_YOFFSET:-0}" \
        "$img_width" \
        "$img_height" \
        "${list[scroll]}" | "$w3m" &>/dev/null

    # Wait for user input.
    read -ern 1

    # Clear the image.
    printf '6;%s;%s;%s;%s\n3;' \
        "${FFF_W3M_XOFFSET:-0}" \
        "${FFF_W3M_YOFFSET:-0}" \
        "$WIDTH" \
        "$HEIGHT" | "$w3m" &>/dev/null

    redraw
}

redraw() {
    # Redraw the current window.
    # If 'full' is passed, re-fetch the directory list.
    [[ $1 == full ]] && {
        read_dir
        scroll=0
    }

    clear_screen
    draw_dir
    status_line
}

mark() {
    # Mark file for operation.
    # If an item is marked in a second directory,
    # clear the marked files.
    [[ $PWD != "$mark_dir" ]] &&
        marked_files=()

    # Don't allow the user to mark the empty directory list item.
    [[ ${list[0]} == empty && -z ${list[1]} ]] &&
        return

    if [[ $1 == all ]]; then
        if ((${#marked_files[@]} != ${#list[@]})); then
            marked_files=("${list[@]}")
            mark_dir=$PWD
        else
            marked_files=()
        fi

        redraw
    else
        if [[ ${marked_files[$1]} == "${list[$1]}" ]]; then
            unset 'marked_files[scroll]'

        else
            marked_files[$1]="${list[$1]}"
            mark_dir=$PWD
        fi

        # Clear line before changing it.
        printf '\e[K'
        print_line "$1"
    fi

    # Find the program to use.
    case "$2" in
        ${FFF_KEY_YANK:=y}|${FFF_KEY_YANK_ALL:=Y}) file_program=(cp -iR) ;;
        ${FFF_KEY_MOVE:=m}|${FFF_KEY_MOVE_ALL:=M}) file_program=(mv -i)  ;;
        ${FFF_KEY_LINK:=s}|${FFF_KEY_LINK_ALL:=S}) file_program=(ln -s)  ;;

        # These are 'fff' functions.
        ${FFF_KEY_TRASH:=d}|${FFF_KEY_TRASH_ALL:=D})
            file_program=(trash)
        ;;

        ${FFF_KEY_BULK_RENAME:=b}|${FFF_KEY_BULK_RENAME_ALL:=B})
            file_program=(bulk_rename)
        ;;
    esac

    status_line
}

trash() {
    # Trash a file.
    cmd_line "trash [${#marked_files[@]}] items? [y/n]: " y n

    [[ $cmd_reply != y ]] &&
        return

    if [[ $FFF_TRASH_CMD ]]; then
        # Pass all but the last argument to the user's
        # custom script. command is used to prevent this function
        # from conflicting with commands named "trash".
        command "$FFF_TRASH_CMD" "${@:1:$#-1}"

    else
        cd "$FFF_TRASH" || cmd_line "error: Can't cd to trash directory."

        if cp -alf "$@" &>/dev/null; then
            rm -r "${@:1:$#-1}"
        else
            mv -f "$@"
        fi

        # Go back to where we were.
        cd "$OLDPWD" ||:
    fi
}

bulk_rename() {
    # Bulk rename files using '$EDITOR'.
    rename_file=${XDG_CACHE_HOME:=${HOME}/.cache}/fff/bulk_rename
    marked_files=("${@:1:$#-1}")

    # Save marked files to a file and open them for editing.
    printf '%s\n' "${marked_files[@]##*/}" > "$rename_file"
    "${EDITOR:-vi}" "$rename_file"

    # Read the renamed files to an array.
    IFS=$'\n' read -d "" -ra changed_files < "$rename_file"

    # If the user deleted a line, stop here.
    ((${#marked_files[@]} != ${#changed_files[@]})) && {
        rm "$rename_file"
        cmd_line "error: Line mismatch in rename file. Doing nothing."
        return
    }

    printf '%s\n%s\n' \
        "# This file will be executed when the editor is closed." \
        "# Clear the file to abort." > "$rename_file"

    # Construct the rename commands.
    for ((i=0;i<${#marked_files[@]};i++)); {
        [[ ${marked_files[i]} != "${PWD}/${changed_files[i]}" ]] && {
            printf 'mv -i -- %q %q\n' \
                "${marked_files[i]}" "${PWD}/${changed_files[i]}"
            local renamed=1
        }
    } >> "$rename_file"

    # Let the user double-check the commands and execute them.
    ((renamed == 1)) && {
        "${EDITOR:-vi}" "$rename_file"

        source "$rename_file"
        rm "$rename_file"
    }

    # Fix terminal settings after '$EDITOR'.
    setup_terminal
}

open() {
    # Open directories and files.
    if [[ -d $1/ ]]; then
        search=
        search_end_early=
        cd "${1:-/}" ||:
        redraw full

    elif [[ -f $1 ]]; then
        # Figure out what kind of file we're working with.
        get_mime_type "$1"

        # Open all text-based files in '$EDITOR'.
        # Everything else goes through 'xdg-open'/'open'.
        case "$mime_type" in
            text/*|*x-empty*|*json*)
                # If 'fff' was opened as a file picker, save the opened
                # file in a file called 'opened_file'.
                ((file_picker == 1)) && {
                    printf '%s\n' "$1" > \
                        "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/opened_file"
                    exit
                }

                clear_screen
                reset_terminal
                "${VISUAL:-${EDITOR:-vi}}" "$1"
                setup_terminal
                redraw
            ;;

            *)
                # 'nohup':  Make the process immune to hangups.
                # '&':      Send it to the background.
                # 'disown': Detach it from the shell.
                nohup "${FFF_OPENER:-${opener:-xdg-open}}" "$1" &>/dev/null &
                disown
            ;;
        esac
    fi
}

cmd_line() {
    # Write to the command_line (under status_line).
    cmd_reply=

    # '\e7':     Save cursor position.
    # '\e[?25h': Unhide the cursor.
    # '\e[%sH':  Move cursor to bottom (cmd_line).
    printf '\e7\e[%sH\e[?25h' "$LINES"

    # '\r\e[K': Redraw the read prompt on every keypress.
    #           This is mimicking what happens normally.
    while IFS= read -rsn 1 -p $'\r\e[K'"${1}${cmd_reply}" read_reply; do
        case $read_reply in
            # Backspace.
            $'\177'|$'\b')
                cmd_reply=${cmd_reply%?}

                # Clear tab-completion.
                unset comp c
            ;;

            # Tab.
            $'\t')
                comp_glob="$cmd_reply*"

                # Pass the argument dirs to limit completion to directories.
                [[ $2 == dirs ]] &&
                    comp_glob="$cmd_reply*/"

                # Generate a completion list once.
                [[ -z ${comp[0]} ]] &&
                    IFS=$'\n' read -d "" -ra comp < <(compgen -G "$comp_glob")

                # On each tab press, cycle through the completion list.
                [[ -n ${comp[c]} ]] && {
                    cmd_reply=${comp[c]}
                    ((c=c >= ${#comp[@]}-1 ? 0 : ++c))
                }
            ;;

            # Escape / Custom 'no' value (used as a replacement for '-n 1').
            $'\e'|${3:-null})
                read "${read_flags[@]}" -rsn 2
                cmd_reply=
                break
            ;;

            # Enter/Return.
            "")
                # If there's only one search result and its a directory,
                # enter it on one enter keypress.
                [[ $2 == search && -d ${list[0]} ]] && ((list_total == 0)) && {
                    # '\e[?25l': Hide the cursor.
                    printf '\e[?25l'

                    open "${list[0]}"
                    search_end_early=1

                    # Unset tab completion variables since we're done.
                    unset comp c
                    return
                }

                break
            ;;

            # Custom 'yes' value (used as a replacement for '-n 1').
            ${2:-null})
                cmd_reply=$read_reply
                break
            ;;

            # Replace '~' with '$HOME'.
            "~")
                cmd_reply+=$HOME
            ;;

            # Anything else, add it to read reply.
            *)
                cmd_reply+=$read_reply

                # Clear tab-completion.
                unset comp c
            ;;
        esac

        # Search on keypress if search passed as an argument.
        [[ $2 == search ]] && {
            # '\e[?25l': Hide the cursor.
            printf '\e[?25l'

            # Use a greedy glob to search.
            list=("$PWD"/*"$cmd_reply"*)
            ((list_total=${#list[@]}-1))

            # Draw the search results on screen.
            scroll=0
            redraw

            # '\e[%sH':  Move cursor back to cmd-line.
            # '\e[?25h': Unhide the cursor.
            printf '\e[%sH\e[?25h' "$LINES"
        }
    done

    # Unset tab completion variables since we're done.
    unset comp c

    # '\e[2K':   Clear the entire cmd_line on finish.
    # '\e[?25l': Hide the cursor.
    # '\e8':     Restore cursor position.
    printf '\e[2K\e[?25l\e8'
}

key() {
    # Handle special key presses.
    [[ $1 == $'\e' ]] && {
        read "${read_flags[@]}" -rsn 2

        # Handle a normal escape key press.
        [[ ${1}${REPLY} == $'\e\e['* ]] &&
            read "${read_flags[@]}" -rsn 1 _

        local special_key=${1}${REPLY}
    }

    case ${special_key:-$1} in
        # Open list item.
        # 'C' is what bash sees when the right arrow is pressed
        # ('\e[C' or '\eOC').
        # '' is what bash sees when the enter/return key is pressed.
        ${FFF_KEY_CHILD1:=l}|\
        ${FFF_KEY_CHILD2:=$'\e[C'}|\
        ${FFF_KEY_CHILD3:=""}|\
        ${FFF_KEY_CHILD4:=$'\eOC'})
            open "${list[scroll]}"
        ;;

        # Go to the parent directory.
        # 'D' is what bash sees when the left arrow is pressed
        # ('\e[D' or '\eOD').
        # '\177' and '\b' are what bash sometimes sees when the backspace
        # key is pressed.
        ${FFF_KEY_PARENT1:=h}|\
        ${FFF_KEY_PARENT2:=$'\e[D'}|\
        ${FFF_KEY_PARENT3:=$'\177'}|\
        ${FFF_KEY_PARENT4:=$'\b'}|\
        ${FFF_KEY_PARENT5:=$'\eOD'})
            # If a search was done, clear the results and open the current dir.
            if ((search == 1 && search_end_early != 1)); then
                open "$PWD"

            # If '$PWD' is '/', do nothing.
            elif [[ $PWD && $PWD != / ]]; then
                find_previous=1
                open "${PWD%/*}"
            fi
        ;;

        # Scroll down.
        # 'B' is what bash sees when the down arrow is pressed
        # ('\e[B' or '\eOB').
        ${FFF_KEY_SCROLL_DOWN1:=j}|\
        ${FFF_KEY_SCROLL_DOWN2:=$'\e[B'}|\
        ${FFF_KEY_SCROLL_DOWN3:=$'\eOB'})
            ((scroll < list_total)) && {
                ((scroll++))
                ((y < max_items)) && ((y++))

                print_line "$((scroll-1))"
                printf '\n'
                print_line "$scroll"
                status_line
            }
        ;;

        # Scroll up.
        # 'A' is what bash sees when the up arrow is pressed
        # ('\e[A' or '\eOA').
        ${FFF_KEY_SCROLL_UP1:=k}|\
        ${FFF_KEY_SCROLL_UP2:=$'\e[A'}|\
        ${FFF_KEY_SCROLL_UP3:=$'\eOA'})
            # '\e[1L': Insert a line above the cursor.
            # '\e[A':  Move cursor up a line.
            ((scroll > 0)) && {
                ((scroll--))

                print_line "$((scroll+1))"

                if ((y < 2)); then
                    printf '\e[L'
                else
                    printf '\e[A'
                    ((y--))
                fi

                print_line "$scroll"
                status_line
            }
        ;;

        # Go to top.
        ${FFF_KEY_TO_TOP:=g})
            ((scroll != 0)) && {
                scroll=0
                redraw
            }
        ;;

        # Go to bottom.
        ${FFF_KEY_TO_BOTTOM:=G})
            ((scroll != list_total)) && {
                ((scroll=list_total))
                redraw
            }
        ;;

        # Show hidden files.
        ${FFF_KEY_HIDDEN:=.})
            # 'a=a>0?0:++a': Toggle between both values of 'shopt_flags'.
            #                This also works for '3' or more values with
            #                some modification.
            shopt_flags=(u s)
            shopt -"${shopt_flags[((a=${a:=$FFF_HIDDEN}>0?0:++a))]}" dotglob
            redraw full
        ;;

        # Search.
        ${FFF_KEY_SEARCH:=/})
            cmd_line "/" "search"

            # If the search came up empty, redraw the current dir.
            if [[ -z ${list[*]} ]]; then
                list=("${cur_list[@]}")
                ((list_total=${#list[@]}-1))
                redraw
                search=
            else
                search=1
            fi
        ;;

        # Spawn a shell.
        ${FFF_KEY_SHELL:=!})
            reset_terminal

            # Make fff aware of how many times it is nested.
            export FFF_LEVEL
            ((FFF_LEVEL++))

            cd "$PWD" && "$SHELL"
            setup_terminal
            redraw full
        ;;

        # Mark files for operation.
        ${FFF_KEY_YANK:=y}|\
        ${FFF_KEY_MOVE:=m}|\
        ${FFF_KEY_TRASH:=d}|\
        ${FFF_KEY_LINK:=s}|\
        ${FFF_KEY_BULK_RENAME:=b})
            mark "$scroll" "$1"
        ;;

        # Mark all files for operation.
        ${FFF_KEY_YANK_ALL:=Y}|\
        ${FFF_KEY_MOVE_ALL:=M}|\
        ${FFF_KEY_TRASH_ALL:=D}|\
        ${FFF_KEY_LINK_ALL:=S}|\
        ${FFF_KEY_BULK_RENAME_ALL:=B})
            mark all "$1"
        ;;

        # Do the file operation.
        ${FFF_KEY_PASTE:=p})
            [[ ${marked_files[*]} ]] && {
                [[ ! -w $PWD ]] && {
                    cmd_line "warn: no write access to dir."
                    return
                }

                # Clear the screen to make room for a prompt if needed.
                clear_screen
                reset_terminal

                stty echo
                printf '\e[1mfff\e[m: %s\n' "Running ${file_program[0]}"
                "${file_program[@]}" "${marked_files[@]}" .
                stty -echo

                marked_files=()
                setup_terminal
                redraw full
            }
        ;;

        # Clear all marked files.
        ${FFF_KEY_CLEAR:=c})
            [[ ${marked_files[*]} ]] && {
                marked_files=()
                redraw
            }
        ;;

        # Rename list item.
        ${FFF_KEY_RENAME:=r})
            [[ ! -e ${list[scroll]} ]] &&
                return

            cmd_line "rename ${list[scroll]##*/}: "

            [[ $cmd_reply ]] &&
                if [[ -e $cmd_reply ]]; then
                    cmd_line "warn: '$cmd_reply' already exists."

                elif [[ -w ${list[scroll]} ]]; then
                    mv "${list[scroll]}" "${PWD}/${cmd_reply}"
                    redraw full

                else
                    cmd_line "warn: no write access to file."
                fi
        ;;

        # Create a directory.
        ${FFF_KEY_MKDIR:=n})
            cmd_line "mkdir: " "dirs"

            [[ $cmd_reply ]] &&
                if [[ -e $cmd_reply ]]; then
                    cmd_line "warn: '$cmd_reply' already exists."

                elif [[ -w $PWD ]]; then
                    mkdir -p "${PWD}/${cmd_reply}"
                    redraw full

                else
                    cmd_line "warn: no write access to dir."
                fi
        ;;

        # Create a file.
        ${FFF_KEY_MKFILE:=f})
            cmd_line "mkfile: "

            [[ $cmd_reply ]] &&
                if [[ -e $cmd_reply ]]; then
                    cmd_line "warn: '$cmd_reply' already exists."

                elif [[ -w $PWD ]]; then
                    : > "$cmd_reply"
                    redraw full

                else
                    cmd_line "warn: no write access to dir."
                fi
        ;;

        # Show file attributes.
        ${FFF_KEY_ATTRIBUTES:=x})
            [[ -e "${list[scroll]}" ]] && {
                clear_screen
                status_line "${list[scroll]}"
                "${FFF_STAT_CMD:-stat}" "${list[scroll]}"
                read -ern 1
                redraw
            }
        ;;

        # Toggle executable flag.
        ${FFF_KEY_EXECUTABLE:=X})
            [[ -f ${list[scroll]} && -w ${list[scroll]} ]] && {
                if [[ -x ${list[scroll]} ]]; then
                    chmod -x "${list[scroll]}"
                    status_line "Unset executable."
                else
                    chmod +x "${list[scroll]}"
                    status_line "Set executable."
                fi
            }
        ;;

        # Show image in terminal.
        ${FFF_KEY_IMAGE:=i})
            draw_img
        ;;

        # Go to dir.
        ${FFF_KEY_GO_DIR:=:})
            cmd_line "go to dir: " "dirs"

            # Let 'cd' know about the current directory.
            cd "$PWD" &>/dev/null ||:

            [[ $cmd_reply ]] &&
                cd "${cmd_reply/\~/$HOME}" &>/dev/null &&
                    open "$PWD"
        ;;

        # Go to '$HOME'.
        ${FFF_KEY_GO_HOME:='~'})
            open ~
        ;;

        # Go to trash.
        ${FFF_KEY_GO_TRASH:=t})
            get_os
            open "$FFF_TRASH"
        ;;

        # Go to previous dir.
        ${FFF_KEY_PREVIOUS:=-})
            open "$OLDPWD"
        ;;

        # Refresh current dir.
        ${FFF_KEY_REFRESH:=e})
            open "$PWD"
        ;;

        # Directory favourites.
        [1-9])
            favourite="FFF_FAV${1}"
            favourite="${!favourite}"

            [[ $favourite ]] &&
                open "$favourite"
        ;;

        # Quit and store current directory in a file for CD on exit.
        # Don't allow user to redefine 'q' so a bad keybinding doesn't
        # remove the option to quit.
        q)
            : "${FFF_CD_FILE:=${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d}"

            [[ -w $FFF_CD_FILE ]] &&
                rm "$FFF_CD_FILE"

            [[ ${FFF_CD_ON_EXIT:=1} == 1 ]] &&
                printf '%s\n' "$PWD" > "$FFF_CD_FILE"

            exit
        ;;
    esac
}

main() {
    # Handle a directory as the first argument.
    # 'cd' is a cheap way of finding the full path to a directory.
    # It updates the '$PWD' variable on successful execution.
    # It handles relative paths as well as '../../../'.
    #
    # '||:': Do nothing if 'cd' fails. We don't care.
    cd "${2:-$1}" &>/dev/null ||:

    [[ $1 == -v ]] && {
        printf '%s\n' "fff 2.2"
        exit
    }

    [[ $1 == -h ]] && {
        man fff
        exit
    }

    # Store file name in a file on open instead of using 'FFF_OPENER'.
    # Used in 'fff.vim'.
    [[ $1 == -p ]] &&
        file_picker=1

    # bash 5 and some versions of bash 4 don't allow SIGWINCH to interrupt
    # a 'read' command and instead wait for it to complete. In this case it
    # causes the window to not redraw on resize until the user has pressed
    # a key (causing the read to finish). This sets a read timeout on the
    # affected versions of bash.
    # NOTE: This shouldn't affect idle performance as the loop doesn't do
    # anything until a key is pressed.
    # SEE: https://github.com/dylanaraps/fff/issues/48
    ((BASH_VERSINFO[0] > 3)) &&
        read_flags=(-t 0.05)

    ((${FFF_LS_COLORS:=1} == 1)) &&
        get_ls_colors

    ((${FFF_HIDDEN:=0} == 1)) &&
        shopt -s dotglob

    # Create the trash and cache directory if they don't exist.
    mkdir -p "${XDG_CACHE_HOME:=${HOME}/.cache}/fff" \
             "${FFF_TRASH:=${XDG_DATA_HOME:=${HOME}/.local/share}/fff/trash}"

    # 'nocaseglob': Glob case insensitively (Used for case insensitive search).
    # 'nullglob':   Don't expand non-matching globs to themselves.
    shopt -s nocaseglob nullglob

    # Trap the exit signal (we need to reset the terminal to a useable state.)
    trap 'reset_terminal' EXIT

    # Trap the window resize signal (handle window resize events).
    trap 'get_term_size; redraw' WINCH

    get_os
    get_term_size
    get_w3m_path
    setup_options
    setup_terminal
    redraw full

    # Vintage infinite loop.
    for ((;;)); {
        read "${read_flags[@]}" -srn 1 && key "$REPLY"

        # Exit if there is no longer a terminal attached.
        [[ -t 1 ]] || exit 1
    }
}

main "$@"
