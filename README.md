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
- `xdotool` for X.
- `fbset` for the framebuffer.


## (Un)installation

1. Download `fff`.
    - Release: https://github.com/IsaacElenbaas/fff/releases/latest
    - Git: `git clone https://github.com/IsaacElenbaas/fff`
2. Add to $PATH
    - https://wiki.archlinux.org/index.php/Environment_variables#Per_user

~~**NOTE:** `fff` can be uninstalled easily using `make uninstall`. This removes all of files from your system.~~ Uninstallation coming soon, need to rework storage.

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
e: refresh current dir
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
X: toggle executable

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

WIP

## Customizing the keybindings.

### Keybindings

WIP

### Disabling keybindings.

You can't unset keybindings by making their value `''`. What you need to do is change their value to `off`.

Example:

WIP

### Dealing with conflicting keybindings.

When rebinding a key in `fff` make sure you don't have two bindings with the same value. You can avoid this by setting the other conflicting key-binding to something else or by changing its value to `off`.


### How to figure out special keys.

Below is a tiny script which will tell you the exact value to use. It automates the deciphering of special key escape sequences to the exact value `fff` needs. Save this to a file and run it (or just paste in a terminal). Give it a key-press and it'll spit out the exact value needed.

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
