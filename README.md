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
export FFF_CD_FILE=~/.fff_d

# Trash Directory
export FFF_TRASH=~/.cache/fff/trash
```

## Why?

¯\\_(ツ)_/¯

<sup><sub>dont touch my shrug</sub></sup>
