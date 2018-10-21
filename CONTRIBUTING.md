# CONTRIBUTING

<!-- vim-markdown-toc GFM -->

* [Index](#index)
    * [Variables](#variables)
    * [Functions](#functions)
    * [Escape Sequences](#escape-sequences)
    * [Traps](#traps)
* [Components](#components)
    * [Scroll](#scroll)
    * [Search](#search)

<!-- vim-markdown-toc -->

# Index

## Variables

| var     | meaning |
| ------- | ------- |
| `LINES` | total lines in terminal. |
| `PWD`   | current dir.
| `REPLY` | user input.
| `f[@]`  | every dir item. |
| `g`     | previous dir when navigating to a bookmark. |
| `c`     | total number of dir items. |
| `j`     | last dir item that fits on the screen. |
| `k`     | first dir item that fits on the screen. |
| `l`     | cursor position (and index to current dir item). |
| `m`     | max number of dir items that fit on the screen. |
| `l2[@]` | history of parent dir nest level. |


## Functions

| func        | meaning |
| ----------- | ------- |
| `refresh()` | clear the screen and calculate window size. |
| `get_dir()` | get the list of dir items from `$PWD`. |
| `f_print()` | print the dir items to the terminal. |
| `path()`    | get the absolute path of a path. |
| `hist()`    | add a cursor position to the location history. |
| `open()`    | navigate to a dir or open a file. |
| `prompt()`  | handle user input. |
| `key()`     | handle key-presses. |
| `main()`    | set traps and start loop. |


## Escape Sequences

| sequence    | meaning |
| ----------- | ------- |
| `\e[?7l`    | disable line wrapping. |
| `\e[?7h`    | enable line wrapping. |
| `\e[?25l`   | hide the cursor. |
| `\e[?25h`   | show the cursor. |
| `\e[2J`     | clear the terminal. |
| `\e[H`      | move cursor to `0,0`. |
| `\e[X;H`    | move cursor to line `X`.
| `\e[1m`     | bold text. |
| `\e[3Xm`    | change text color to `X`. |
| `\e[7m`     | invert text colors (`fg->bg`,`bg->fg`). |
| `\e[m`      | reset text formatting. |
| `\e[K`      | clear from cursor position to end of line. |
| `\e[999B`   | move cursor `999` lines down (go-to-bottom). |

## Traps

| trap        | meaning |
| ----------- | ------- |
| `SIGWINCH`  | on terminal resize. |
| `EXIT`      | on terminal exit. |


# Components

## Scroll

The scroll uses these variables for the math.

| var     | meaning |
| ------- | ------- |
| `c`     | total number of dir items. |
| `j`     | last dir item that fits on the screen. |
| `k`     | first dir item that fits on the screen. |
| `l`     | cursor position (and index to current dir item). |
| `m`     | max number of dir items that fit on the screen. |


## Search

The search feature works by creating an array of matches using a `glob`. The `f_print` function is used next to create a "fake" directory with the search results.

The current directory is saved in variable `g`. The saved directory is then used the next time the user navigates to a parent directory. This mimics a `cd` while also clearing the search results.
