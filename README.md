# fff (*Fucking Fast File-Manager*)

<a href="https://asciinema.org/a/IKG1pSkeIQkc4dSjw4S0DZjXj" target="_blank"><img src="https://asciinema.org/a/IKG1pSkeIQkc4dSjw4S0DZjXj.png" alt="img" height="300px" align="right"/></a>

A [WIP] simple file manager written in `bash`.

- It's Fucking Fast 🚀
- Minimal (*~100 lines of bash*)
- Smooth Scrolling (*using vim keybindings*)
- File Operations (*copy, paste, rename, cut, etc*)
- Basic Search


## Dependencies

- `bash 3.2+`
- program handling (non-text): `xdg-utils` (*not needed on macos*)
- file operations: `coreutils`
- mime types: `file`


## Running

1. `fff` or `fff path/to/dir`, `fff ../../`, `fff /usr/share/`
2. optional: `alias f="fff"`


## Packages

- [arch (aur)](https://aur.archlinux.org/packages/fff-git/)


## Usage

```sh
j: scroll down
k: scroll up
h: go to parent dir
l: go to child dir

enter: go to child dir

g: go to top
G: go to bottom

.: toggle hidden files
/: search
t: go to trash
~: go to home
s: open shell in current dir

[1-9]: favourites (see customization)

down:  scroll down
up:    scroll up
left:  go to parent dir
right: go to child dir

f: new file
n: new dir

y: mark copy
m: mark move
p: paste/move
r: rename
d: trash (~/.cache/fff/trash/)

q: exit
```

## Customization

```sh
# Directory color [0-9]
export FFF_COL1=2

# Status color [0-9]
export FFF_COL2=7

# Selection color [0-9] (copied/moved files)
export FFF_COL3=6

# Text Editor
export FFF_EDITOR="vim" # alternative: export EDITOR="vim"

# File Opener
export FFF_OPENER="xdg-open"

# Trash Directory
export FFF_TRASH="~/.cache/fff/trash"

# Favourites (keys 1-9) (dir or file)
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
