# fff (*Fucking Fast File-Manager*)

<a href="https://asciinema.org/a/qvNlrFrGB3xKZXb6GkremjZNp" target="_blank"><img src="https://asciinema.org/a/qvNlrFrGB3xKZXb6GkremjZNp.svg" alt="img" height="210px" align="right"/></a>

A simple file manager written in `bash`.

<a href="https://discord.gg/BtnTPFF"><img src="https://img.shields.io/discord/440354555197128704.svg"></a>
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
- **Display images with w3m-img (in master)!**
- Supports `$CDPATH`.


## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Dependencies](#dependencies)
* [Installation](#installation)
    * [Distros](#distros)
    * [Manual](#manual)
    * [CD on Exit](#cd-on-exit)
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

**Dependencies for image display (in master)**

- `w3m-img`
- `xdotool`


## Installation

### Distros

- Arch Linux (based): `pacman -S fff`
- Haiku: `pkgman install fff`
- Nix: `nix-env -iA fff`
- Void Linux: `xbps-install -S fff`

### Manual

1. Download `fff`.
    - Release: https://github.com/dylanaraps/fff/releases/latest
    - Git: `git clone https://github.com/dylanaraps/fff`
2. Change working directory to `fff`.
    - `cd fff`
3. Run `make install` inside the script directory to install the script.
    - **El Capitan**: `make PREFIX=/usr/local install`
    - **Haiku**: `make PREFIX="$(finddir B_USER_NONPACKAGED_DIRECTORY)" MANDIR="$(finddir B_USER_NONPACKAGED_DOCUMENTATION_DIRECTORY)/man" install`
    - **OpenIndiana**: `gmake install`
    - **MinGW/MSys**: `make -i install`
    - **NOTE**: You may have to run this as root.

**NOTE:** `fff` can be uninstalled easily using `make uninstall`. This removes all of files from your system.

### CD on Exit

```sh
# Add this to your .bashrc, .zshrc or equivalent.
# Run 'fff' with 'f' or whatever you decide to name the function.
f() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}
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
!: open shell in current dir

x: view file/dir attributes
i: display image with w3m-img

down:  scroll down
up:    scroll up
left:  go to parent dir
right: go to child dir

f: new file
n: new dir
r: rename

y: mark copy
m: mark move
d: mark trash (~/.local/share/fff/trash/)
s: mark symbolic link
b: mark bulk rename

Y: mark all for copy
M: mark all for move
D: mark all for trash (~/.local/share/fff/trash/)
S: mark all for symbolic link
B: mark all for bulk rename

p: paste/move/delete/bulk_rename
c: clear file selections

[1-9]: favourites/bookmarks (see customization)

q: exit with 'cd' (if enabled).
Ctrl+C: exit without 'cd'.
```

## Customization

```sh
# Use LS_COLORS to color fff.
# (On by default if available)
# (Ignores FFF_COL1)
export FFF_LS_COLORS=1

# Directory color [0-9]
export FFF_COL1=2

# Status color [0-9]
export FFF_COL2=7

# Selection color [0-9] (copied/moved files)
export FFF_COL3=6

# Cursor color [0-9]
export FFF_COL4=1

# Text Editor
export EDITOR="vim"

# File Opener
export FFF_OPENER="xdg-open"

# Enable or disable CD on exit.
# Default: '1'
export FFF_CD_ON_EXIT=1

# CD on exit helper file
# Default: '${XDG_CACHE_HOME}/fff/fff.d'
#          If not using XDG, '${HOME}/.cache/fff/fff.d' is used.
export FFF_CD_FILE=~/.fff_d

# Trash Directory
# Default: '${XDG_DATA_HOME}/fff/trash'
#          If not using XDG, '${XDG_DATA_HOME}/fff/trash' is used.
export FFF_TRASH=~/.local/share/fff/trash

# Trash Command
# Default: 'mv'
#          Define a custom program to use to trash files.
#          The program will be passed the list of selected files
#          and directories.
export FFF_TRASH_CMD="mv"

# Favourites (Bookmarks) (keys 1-9) (dir or file)
export FFF_FAV1=~/projects
export FFF_FAV2=~/.bashrc
export FFF_FAV3=~/Pictures/Wallpapers/
export FFF_FAV4=/usr/share
export FFF_FAV5=/
export FFF_FAV6=
export FFF_FAV7=
export FFF_FAV8=
export FFF_FAV9=

# w3m-img offsets.
export FFF_W3M_XOFFSET=0
export FFF_W3M_YOFFSET=0

# File format.
# Customize the item string.
# Format ('%f' is the current file): "str%fstr"
# Example (Add a tab before files): FFF_FILE_FORMAT="\t%f"
export FFF_FILE_FORMAT="%f"

# Mark format.
# Customize the marked item string.
# Format ('%f' is the current file): "str%fstr"
# Example (Add a ' >' before files): FFF_MARK_FORMAT="> %f"
export FFF_MARK_FORMAT=" %f*"
```

## Customizing the keybindings.

### Keybindings

This is the list of full keybindings along with their default values. You only need to modify the keybindings that you'd like to change from the default. `fff` will run perfectly fine without any of these defined.

```sh
### Moving around.

# Go to child directory.
export FFF_KEY_CHILD1="l"
export FFF_KEY_CHILD2=$'\e[C' # Right Arrow
export FFF_KEY_CHILD3=""      # Enter / Return

# Go to parent directory.
export FFF_KEY_PARENT1="h"
export FFF_KEY_PARENT2=$'\e[D' # Left Arrow
export FFF_KEY_PARENT3=$'\177' # Backspace
export FFF_KEY_PARENT4=$'\b'   # Backspace (Older terminals)

# Go to previous directory.
export FFF_KEY_PREVIOUS="-"

# Search.
export FFF_KEY_SEARCH="/"

# Spawn a shell.
export FFF_KEY_SHELL="!"

# Scroll down.
export FFF_KEY_SCROLL_DOWN1="j"
export FFF_KEY_SCROLL_DOWN2=$'\e[B' # Down Arrow

# Scroll up.
export FFF_KEY_SCROLL_UP1="k"
export FFF_KEY_SCROLL_UP2=$'\e[A'   # Up Arrow

# Go to top and bottom.
export FFF_KEY_TO_TOP="g"
export FFF_KEY_TO_BOTTOM="G"

# Go to dirs.
export FFF_KEY_GO_DIR=":"
export FFF_KEY_GO_HOME="~"
export FFF_KEY_GO_TRASH="t"

### File operations.

export FFF_KEY_YANK="y"
export FFF_KEY_MOVE="m"
export FFF_KEY_TRASH="d"
export FFF_KEY_LINK="s"
export FFF_KEY_BULK_RENAME="b"

export FFF_KEY_YANK_ALL="Y"
export FFF_KEY_MOVE_ALL="M"
export FFF_KEY_TRASH_ALL="D"
export FFF_KEY_LINK_ALL="S"
export FFF_KEY_BULK_RENAME_ALL="B"

export FFF_KEY_PASTE="p"
export FFF_KEY_CLEAR="c"

export FFF_KEY_RENAME="r"
export FFF_KEY_MKDIR="n"
export FFF_KEY_MKFILE="f"

### Miscellaneous

# Show file attributes.
export FFF_KEY_ATTRIBUTES="x"

# Toggle hidden files.
export FFF_KEY_HIDDEN="."
```

### Disabling keybindings.

You can't unset keybindings by making their value `''`. What you need to do is change their value to `off`.

Example:

```sh
# KEY_GO_TRASH was bound to 't', now its unset.
export FFF_KEY_GO_TRASH="off"

# KEY_MKFILE is now set to 't' and its original
# keybinding is also unset 'f'.
export FFF_KEY_MKFILE="t"
```

### Dealing with conflicting keybindings.

When rebinding a key in `fff` make sure you don't have two bindings with the same value. You can avoid this by setting the other conflicting key-binding to something else or by changing its value to `off`.


### How to figure out special keys.

Below is a tiny script I've written which will tell you the exact value to use. It automates the deciphering of special key escape sequences to the exact value `fff` needs. Save this to a file and run it. Give it a key-press and it'll spit out the exact value needed.

```sh
#!/usr/bin/env bash
# Output the key-binding values for 'fff'.
key() {
    case "$1" in
        # Backspace.
        $'\b'|$'\177')
            printf '%s\n' "key: \$'\\b' or \$'\\177'"
        ;;

        # Escape Sequences.
        $'\e')
            read -rsn 2
            printf '%s %q\n' "key:" "${1}${REPLY}"
        ;;

        # Return / Enter.
        "")
            printf '%s\n' "key: \" \""
        ;;

        # Everything else.
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

<sup><sub>dont touch my shrug</sub></sup>
