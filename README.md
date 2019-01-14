# fff (*Fucking Fast File-Manager*)

<a href="https://asciinema.org/a/QBCXlA7qbkQPCcfdBGDoPUWiH" target="_blank"><img src="https://asciinema.org/a/QBCXlA7qbkQPCcfdBGDoPUWiH.svg" alt="img" height="300px" align="right"/></a>

A simple file manager written in `bash`.

- It's Fucking Fast 🚀
- Minimal (*only requires **bash** and coreutils*)
- Smooth Scrolling (*using **vim** keybindings*)
- Supports `LS_COLORS`!
- File Operations (*copy, paste, rename, cut, etc*)
- Instant as you type search
- Automatic CD on exit (*see [setup](#cd-on-exit)*)


## Introduction

The entire program has been rewritten in **readable** bash. It's no longer 100 obfuscated lines and<br>
no longer has that restriction. Numerous bugs were discovered in the rewrite and have<br>
been all fixed. The program has been highly optimized now. The old version did a full screen<br>
redraw on every keypress while the new version redraws only when necessary<br>
(*Scrolling only redraws 2 lines now!*).

Take a peek at the source code. I've done my best to explain the non-obvious and tricky parts.


## Dependencies

- `bash 3.2+`
- program handling (non-text): `xdg-utils`
    - *Not needed on macos and Haiku.*
    - *Customizable (if not using `xdg-open`): `$FFF_OPENER`.*
- file operations: `coreutils`
- mime types: `file`


## Running

1. `fff` or `fff path/to/dir`, `fff ../../`, `fff /usr/share/`
2. optional: `alias f="fff"`

#### CD on Exit

```sh
# Example setup (bash) (in .bashrc)
f() { fff "$@"; cd "$(< ~/.fff_d)"; }

# Customization (temporary file to use)
# Default: '${XDG_CACHE_HOME}/fff/fff.d'
#          If not using XDG, '${HOME}/.cache/fff/fff.d' is used.
export FFF_CD_FILE=~/.fff_d


# Example setup (posix) (in .shellrc)
f() { fff "$@"; cd "$(cat ~/.fff_d)"; }

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

.: toggle hidden files
/: search
t: go to trash
~: go to home
s: open shell in current dir
x: view file/dir attributes

down:  scroll down
up:    scroll up
left:  go to parent dir
right: go to child dir

f: new file
n: new dir
r: rename

y: mark copy
m: mark move
d: mark trash (~/.cache/fff/trash/)
p: paste/move/delete
c: clear file selections

[1-9]: favourites/bookmarks (see customization)

q: exit
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

# CD on exit helper file
# Default: '${XDG_CACHE_HOME}/fff/fff.d'
#          If not using XDG, '${HOME}/.cache/fff/fff.d' is used.
export FFF_CD_FILE=~/.fff_d

# Trash Directory
# Default: '${XDG_CACHE_HOME}/fff/trash'
#          If not using XDG, '${HOME}/.cache/fff/trash' is used.
export FFF_TRASH=~/.cache/fff/trash

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
```

## Why?

¯\\_(ツ)_/¯

<sup><sub>dont touch my shrug</sub></sup>
