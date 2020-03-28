## Why is this staying a fork?

 - It's a unneccessary breaking change (changing all the config names) and I don't want to pollute the code with `: ${fkey_child1:=FFF_KEY_CHILD1}` for all 64 original settings
 - I don't feel it's going to deviate far enough to justify detachment

## Why not just. . . leave the config names alone?

 - I use [Auto Shift](https://beta.docs.qmk.fm/using-qmk/software-features/feature_auto_shift), and I hated trying to type them. I even have a backup shift key to type all caps and it was bad because I had to switch between hitting that and the underscores
 - If I was going to make a fork to make a config file and fix a few bugs, why would I rewrite the config with garbage names and *then* make a workaround so I don't have to type them?
 - At the moment there's not a ton those using the main branch are missing out on

## What's changed?

 - Added a config file (`~/.fff`) and removed globals
 - Made `f_color1` have priority over `di` from `LS_COLORS`
 - Added `f_visual_default` to allow prioritizing `EDITOR` over `VISUAL`
 - Added `f_print_actions` to toggle printing file operations so you can look back at them after exiting
 - Added `f_trash_confirm` to allow not asking for confirmation when trashing files (I don't know why this wasn't added when the default option isn't to permanently delete)
 - Added `fkey_img_preview_max` to preview images at maximum size

# fff (*Fucking Fast File-Manager*)

<a href="https://asciinema.org/a/qvNlrFrGB3xKZXb6GkremjZNp" target="_blank"><img src="https://asciinema.org/a/qvNlrFrGB3xKZXb6GkremjZNp.svg" alt="img" height="210px" align="right"/></a>

A simple file manager written in `bash`.

<a href="https://travis-ci.org/dylanaraps/fff"><img src="https://travis-ci.org/dylanaraps/fff.svg?branch=master"></a>
<a href="https://github.com/dylanaraps/fff/releases"><img src="https://img.shields.io/github/release/dylanaraps/fff.svg"></a>
<a href="https://repology.org/metapackage/fff"><img src="https://repology.org/badge/tiny-repos/fff.svg" alt="Packaging status"></a>

- It's Fucking Fast 🚀
- Minimal (*only requires **bash** and coreutils*)
- Smooth Scrolling (*using **vim** keybindings*)
- Works on **Linux**, **BSD**, **macOS**, **Haiku** etc.
- Supports `LS_COLORS`!
- File Operations (*copy, paste, cut, **ranger style bulk rename**, etc*) <img src="https://i.imgur.com/tjIWUjf.jpg" alt="img" height="213px" align="right"/>
- Instant as you type search
- Tab completion for all commands!
- Automatic CD on exit (*see [setup](#cd-on-exit)*)
- Works as a **file picker** in `vim`/`neovim` ([**link**](https://github.com/dylanaraps/fff.vim))!
- **Display images with w3m-img!**
- Supports `$CDPATH`.


## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Dependencies](#dependencies)
* [(Un)installation](#uninstallation)
* [Usage](#usage)
* [Customization](#customization)
* [Customizing the keybindings.](#customizing-the-keybindings)
    * [Keybindings](#keybindings)
    * [Disabling keybindings.](#disabling-keybindings)
    * [Dealing with conflicting keybindings.](#dealing-with-conflicting-keybindings)
    * [How to figure out special keys.](#how-to-figure-out-special-keys)
* [Using `fff` in vim/neovim as a file picker](#using-fff-in-vimneovim-as-a-file-picker)
* [Why?](#why)

<!-- vim-markdown-toc -->

## Dependencies

- `bash 3.2+`
- `coreutils`
    - File operations.
- `xdg-utils` (*optional*)
    - Program handling (*non-text*).
    - *Not needed on macos and Haiku.*
    - *Customizable (if not using `xdg-open`): `$FFF_OPENER`.*

**Dependencies for image display**

- `w3m-img`
- `xdotool` for X
- `fbset` for the framebuffer

## (Un)installation

1. Download `fff`
    - Release: https://github.com/IsaacElenbaas/fff/releases/latest
    - Git: `git clone https://github.com/IsaacElenbaas/fff`
2. Add to $PATH
    - https://wiki.archlinux.org/index.php/Environment_variables#Per_user

**NOTE:** `fff` can be uninstalled by - duh - deleting it, and the only other places anything is stored are `.cache/fff` and `.local/share/fff` in your `$HOME` by default, or whatever you've set `XDG_CACHE_HOME` and `XDG_DATA_HOME` to.

### CD on Exit

```sh
# Add this to your .bashrc, .zshrc or equivalent
# fff will run with 'fff' or 'f' (or whatever you decide to name the function)
f() {
    \fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d" 2>/dev/null)"
    rm "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d" 2>/dev/null
}
alias fff='f'
```

## Usage

```sh
j: scroll down
k: scroll up
h: go to parent dir
l: go to child dir

enter: go to child dir
backspace: go to parent dir

-: Go to previous dir.

g: go to top
G: go to bottom

:: go to a directory by typing.

.: toggle hidden files
/: search
t: go to trash
~: go to home
e: refresh current dir
!: open shell in current dir

x: view file/dir attributes
i: display image with w3m-img
I: display image with w3m-img at maximum size

down:  scroll down
up:    scroll up
left:  go to parent dir
right: go to child dir

f: new file
n: new dir
r: rename
X: toggle executable

y: mark copy
m: mark move
d: mark trash ([~/.local/share/fff or whatever you've set XDG_DATA_HOME to]/trash/)
s: mark symbolic link
b: mark bulk rename

Y: mark all for copy
M: mark all for move
D: mark all for trash ([~/.local/share/fff or whatever you've set XDG_DATA_HOME to]/trash/)
S: mark all for symbolic link
B: mark all for bulk rename

p: paste/move/delete/bulk_rename
c: clear file selections

[1-9]: favourites/bookmarks (see customization)

q: exit (with 'cd' if enabled)
Ctrl+C: exit without 'cd'
```

## Customization

This is the list of settings along with their default values. You only need to modify the keybindings that you'd like to change from the default. `fff` will run perfectly fine without any of these defined.

```sh
# Try VISUAL before EDITOR when opening text files or those without a mime_type
f_visual_default=1

# Print actions so you can look back at what you did if needed after exiting
f_print_actions=1

# Ask for confirmation when moving items to trash
# You can accidentally permanently delete if you set f_trash_cmd to rm or equivalent, be careful!
f_trash_confirm=1

# Use LS_COLORS to color fff (if set)
f_LS_COLORS=1

# Show/Hide hidden files on open
# (On by default)
f_show_hidden=0

# For color numbers, see http://www.linux-sxs.org/housekeeping/lscolors.html 30-37

# Directory color [0-7]
f_color1=2

# Status background color [0-7]
f_color2=1

# Selection color [0-7] (copied/moved files)
f_color3=1

# Cursor color [0-7]
f_color4=6

# Status foreground color [0-7]
f_color5=0

# Text Editor, you'll have to set these as environment variables in .bashrc or equivalent
# vi is fallback if neither is set
# See f_visual_default
export VISUAL="vi"
export EDITOR="vi"

# File Opener
f_opener="xdg-open"

# Enable or disable CD on exit
f_cd_on_exit=1

# CD on exit helper file
# Default: '${XDG_CACHE_HOME}/fff/fff.d'
#          If not using XDG, '${HOME}/.cache/fff/fff.d' is used
f_cd_file

# Trash Directory
# Default: '${XDG_DATA_HOME}/fff/trash'
#          If not using XDG, '${XDG_DATA_HOME}/fff/trash' is used
f_trash_dir

# Trash Command
# Default (unset, passing anything prevents using default) uses 'mv'
# The program will be passed the list of selected files and directories
f_trash_cmd=

# Favourites (Bookmarks) (keys 1-9) (dir or file)
f_fav1=
f_fav2=
f_fav3=
f_fav4=
f_fav5=
f_fav6=
f_fav7=
f_fav8=
f_fav9=

# w3m-img offsets
f_w3m_offset_x=0
f_w3m_offset_y=0

# File format
# Customize the item string
# Format ('%f' is the current file): "str%fstr"
# Example (Add a tab before files): FFF_FILE_FORMAT="\t%f"
f_file_format="%f"

# Mark format
# Customize the marked item string
# Format ('%f' is the current file): "str%fstr"
# Example (Add a ' >' before files): FFF_MARK_FORMAT="> %f"
f_mark_format=" %f*"
```

## Customizing the keybindings

### Keybindings

This is the list of keybindings along with their default values. You only need to modify the keybindings that you'd like to change from the default. `fff` will run perfectly fine without any of these defined.

```sh
### Moving around

# Go to child directory
fkey_child1="l"
fkey_child2=$'\e[C' # Right Arrow
fkey_child3=""      # Enter / Return

# Go to parent directory
fkey_parent1="h"
fkey_parent2=$'\e[D' # Left Arrow
fkey_parent3=$'\177' # Backspace
fkey_parent4=$'\b'   # Backspace (Older terminals)

# Go to previous directory
fkey_previous="-"

# Search
fkey_search="/"

# Spawn a shell
fkey_shell="!"

# Scroll down
fkey_scroll_down1="j"
fkey_scroll_down2=$'\e[B' # Down Arrow

# Scroll up
fkey_scroll_up1="k"
fkey_scroll_up2=$'\e[A'   # Up Arrow

# Go to top and bottom
fkey_top="g"
fkey_bottom="G"

# Go to dirs
fkey_go_dir=":"
fkey_go_home="~"
fkey_go_trash="t"
fkey_refresh="e"

### File operations

fkey_yank="y"
fkey_move="m"
fkey_trash="d"
fkey_link="s"
fkey_bulk_rename="b"

fkey_yank_all="Y"
fkey_move_all="M"
fkey_trash_all="D"
fkey_link_all="S"
fkey_bulk_rename_all="B"

fkey_paste="p"
fkey_clear="c"

fkey_rename="r"
fkey_mkdir="n"
fkey_mkfile="f"

# Display image with w3m-img
fkey_image_preview="i"
# Display image with w3m-img at maximum size
fkey_image_preview_max="I"

### Miscellaneous

# Show file attributes
fkey_view_attributes="x"

# Toggle executable flag
fkey_toggle_executable="X"

# Toggle hidden files
fkey_toggle_show_hidden="."
```

### Disabling keybindings.

You can't unset keybindings by making their value `''`. What you need to do is change their value to `off`.

Example:

```sh
# go_trash was bound to 't', now its unset
fkey_go_trash="off"

# mkfile is now set to 't' and its original
# keybinding of 'f' is also unset
fkey_mkfile="t"
```

### Dealing with conflicting keybindings

When rebinding a key in `fff` make sure you don't have two bindings with the same value. You can avoid this by setting the other conflicting key-binding to something else or by changing its value to `off`.

### How to figure out special keys

Below is a tiny script which will tell you the exact value to use. It automates the deciphering of special key escape sequences to the exact value `fff` needs. Save this to a file and run it (or just paste in a terminal). Give it a key-press and it'll spit out the exact value needed.

```sh
#!/usr/bin/env bash
# Output the key-binding values for 'fff'
key() {
    case "$1" in
        # Backspace
        $'\b'|$'\177')
            printf '%s\n' "key: \$'\\b' or \$'\\177'"
        ;;

        # Escape Sequences
        $'\e')
            read -rsn 2
            printf '%s %q\n' "key:" "${1}${REPLY}"
        ;;

        # Return / Enter
        "")
            printf '%s\n' "key: \" \""
        ;;

        # Everything else
        *)
            printf '%s %q\n' "key:" "$1"
        ;;
    esac
}

read -srn 1 && key "$REPLY"
```

## Using `fff` in vim/neovim as a file picker

See: [**`fff.vim`**](https://github.com/dylanaraps/fff.vim)


## Why?

¯\\_(ツ)_/¯
