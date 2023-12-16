# fff (*Fucking Fine File-Manager*)

### This fork is meant to make fff a more feature-rich file manager, but at cost of raw speed.

<a href="https://asciinema.org/a/qvNlrFrGB3xKZXb6GkremjZNp" target="_blank"><img src="https://asciinema.org/a/qvNlrFrGB3xKZXb6GkremjZNp.svg" alt="img" height="210px" align="right"/></a>

### Changes to original

- [Nerd Fonts devicons](https://www.nerdfonts.com/#home) support
- Help page on `?`
- `Open with` commands
- Human-readable size in stats
- Git branch in stats
- Git branch on status line
- Recursive git signs for changed files <img src="https://i.imgur.com/V2aCYWn.png" alt="img" height="180px" align="right"/>
- Display file modification date, time and size (resource-heavy)
- Sort files by modification time or alphabetically
- `ctrl + d`/`ctrl + u` scrolling
- Working history of directories and picker for them
- Changed marking behavior to nnn-like (mark with space, choose a command, and then execute it)
- Changed keybindings to better suit more options
- Removed ability to view images (because I don't use it, but can add it for a request)
- Optional config file for global configuration
- Colored filenames
- Copy filename to clipboard with `y` and copy file with `c` (when marking)
- Changed single file renaming behavior to allow using arrows and automatically display renamed file (and `ctrl + a` to go at the beginning of the filename).
- Deleted clear option (clear marks by pressing `FFF_KEY_MARK_ALL`) 
- Mark and open with multiple files at time


### Thanks

A big part of code in there is from people who made PRs and posted issues to fff:

- Roy Orbitson (help page) <img src="https://i.imgur.com/psnHD6l.png" alt="img" height="180px" align="right"/>
- Sidd Dino (devicons)
- qwool (human-readable size)
- Docbroke (sorting)
- yiselieren (file details)
- Isaac Elenbaas (config file, changing renaming behavior)

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Dependencies](#dependencies)
* [Installation](#installation)
    * [Distros](#distros)
    * [Manual](#manual)
    * [CD on Exit](#cd-on-exit)
        * [Bash and Zsh](#bash-and-zsh)
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
- `Nerd Font` (*optional*)
    - Icons
- `xclip or any clipboard manager` (*optional*)
    - clipboard

## Installation

### Manual

1. Download `fff`.
    - Git: `git clone https://github.com/piotr-marendowski/fff`
2. Change working directory to `fff`.
    - `cd fff`
3. Run `make install` inside the script directory to install the script.
    - **El Capitan**: `make PREFIX=/usr/local install`
    - **Haiku**: `make PREFIX="$(finddir B_USER_NONPACKAGED_DIRECTORY)" MANDIR='$(PREFIX)/documentation/man' DOCDIR='$(PREFIX)/documentation/fff' install`
    - **OpenIndiana**: `gmake install`
    - **MinGW/MSys**: `make -i install`
    - **NOTE**: You may have to run this as root.

**NOTE:** `fff` can be uninstalled easily using `make uninstall`. This removes all of files from your system.

### CD on Exit
#### Bash and Zsh
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

enter: go to child dir/open file
backspace: go to parent dir

o: open file with
O: open file with GUI program detached from file manager

-: Go to previous dir.

g: go to top
G: go to bottom

:: go to a directory by typing.

.: toggle hidden files
/: search
t: go to trash
~: go to home
z: refresh current dir
!: open shell in current dir

i: display file details
u: sort files
x: view file/dir attributes
e: show history
y: copy filename to clipboard

down:  scroll down
up:    scroll up
left:  go to parent dir
right: go to child dir

f: new file
n: new dir
r: rename
X: toggle executable

space: mark file
a: mark all files in directory
c: copy
m: move
d: trash (move to FFF_TRASH)
s: symbolic link
b: bulk rename

p: execute paste/move/delete/bulk_rename

[1-9]: favourites/bookmarks (see customization)

q: exit with 'cd' (if enabled).
Ctrl+C: exit without 'cd'.

?: show help
```

## Customization

Can be added to your `bashrc` (or other shell's configuration files) and/or can be added to `FFF_CONFIG`. Everything put in `FFF_CONFIG` file will be sourced globally meaning that e.g. Neovim's terminal will have these settings. And I'm not sure why the only option (maybe there are others) not working in config file is `FFF_HIDDEN` which only works, when fff is run inside terminal manually.

```sh
# Show/Hide hidden files on open.
# (Off by default)
export FFF_HIDDEN=1

# Show/Hide file icons on open
# (Off by default)
export FFF_FILE_ICON=1

# Show/Hide git status signs (+) on open
# (Off by default)
export FFF_GIT_CHANGES=1

# Default method to sort files on open
# 0 - alphabetically
# 1 - modification time
# (0 by default)
export FFF_SORT_METHOD=1

# Show/Hide file details on open
# (Off by default)
export FFF_FILE_DETAILS=1

# Use LS_COLORS to color fff.
# (On by default if available)
# (Ignores FFF_COL1)
export FFF_LS_COLORS=1

# Directory color [0-9]
export FFF_COL1=2

# Status background color [0-9]
export FFF_COL2=7

# Selection color [0-9] (copied/moved files)
export FFF_COL3=6

# Cursor color [0-9]
export FFF_COL4=1

# Status foreground color [0-9]
export FFF_COL5=0

# Selection color
# (inverted foreground by default)
# ('48;2;R;G;B' values separated by ';', don't edit the '48;2;' part!).
# In terminals that support truecolor, this will set the selection color
# to grey, but on others selection will be only white bold text (if this
# is set).
export FFF_COL6="48;2;80;80;80"

# Colored filenames
# (0 by default)
export FFF_COLORED_FILENAMES=1

# Text Editor
export EDITOR="nvim"

# File Opener
export FFF_OPENER="xdg-open"

# File Attributes Command
export FFF_STAT_CMD="stat"

# Enable or disable CD on exit.
# (On by default)
export FFF_CD_ON_EXIT=0

# CD on exit helper file
# Default: '${XDG_CACHE_HOME}/fff/fff.d'
#          If not using XDG, '${HOME}/.cache/fff/fff.d' is used.
export FFF_CD_FILE=~/.fff_d

# Config Directory
# Default: '${XDG_CONFIG_HOME/fff}'
#          If not using XDG, '${HOME}/.config/fff' is used.
export FFF_CONFIG=~/.config/fff

# Trash Directory
# Default: '${XDG_DATA_HOME}/fff/trash'
#          If not using XDG, '${HOME}/.local/share/fff/trash' is used.
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

# History file length.
# (100 lines by default)
# Every cd-on-exit (q) program deletes every line older than
# FFF_HISTORY_LENGTH.
# Example: history has 150 lines, quitting trims history file
# to 100 most recent.
export FFF_HISTORY_LENGTH=200

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

# Clipboard program and arguments.
# Default: xclip -selection c 
export FFF_KEY_CLIPBOARD="xclip -selection c"

# Scroll steps.
# (14 by default).
export FFF_SCROLL_UP=14
export FFF_SCROLL_DOWN=14
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
export FFF_KEY_REFRESH="z"

### File operations.
export FFF_KEY_MARK=" "
export FFF_KEY_MARK_ALL="a"
export FFF_KEY_COPY="c"
export FFF_KEY_MOVE="m"
export FFF_KEY_TRASH="d"
export FFF_KEY_LINK="s"
export FFF_KEY_BULK_RENAME="b"

export FFF_KEY_EXECUTE="p"

export FFF_KEY_RENAME="r"
export FFF_KEY_MKDIR="n"
export FFF_KEY_MKFILE="f"

### Miscellaneous

# Display file details.
export FFF_KEY_DETAILS="i"

# Sort files.
export FFF_KEY_SORT="u"

# Show file attributes.
export FFF_KEY_ATTRIBUTES="x"

# Toggle executable flag.
export FFF_KEY_EXECUTABLE="X"

# Toggle hidden files.
export FFF_KEY_HIDDEN="."

# Show history of directories. 
export FFF_KEY_HISTORY="e"

# Yank filename to clipboard.
export FFF_KEY_CLIPBOARD="y"
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
