# fff (*Fucking Fast File-Manager*)

<a href="https://asciinema.org/a/IKG1pSkeIQkc4dSjw4S0DZjXj" target="_blank"><img src="https://asciinema.org/a/IKG1pSkeIQkc4dSjw4S0DZjXj.png" alt="img" height="300px" align="right"/></a>

A [WIP] simple file manager written in `bash`.

- It's Fucking Fast 🚀
- Minimal (*~100 lines of bash*)
- Smooth Scrolling (*using vim keybindings.*)
- File Operations (*copy, paste, rename, cut, delete*)
- Basic Search
- CD on Exit


## Dependencies

- `bash`
- program handling (non-text): `xdg-open`
- copying: `cp`
- moving, renaming, trash: `mv`

## Running

1. `fff`
2. optional: `alias f="fff"`


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

down:  scroll down
up:    scroll up
left:  go to parent dir
right: go to child dir

y: mark copy
m: mark move
p: paste/move
r: rename
d: trash (~/.cache/fff/bin/)
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
export EDITOR="cmd"
```

## Why?

¯\\_(ツ)_/¯
