# CONTRIBUTING


# Variables

| var     | meaning |
| ------- | ------- |
| `LINES` | total lines in terminal. |
| `PWD`   | current directory.
| `REPLY` | user input.
| `f[@]`  | every dir item. |
| `c`     | total number of dir items. |
| `g`     | previous dir when navigating to a bookmark. |
| `j`     | last dir item that fits on the screen. |
| `k`     | first dir item that fits on the screen. |
| `l`     | cursor position. |
| `l2[@]` | history of parent dirs (used to remember previous location). |
| `m`     | number of lines that fit on the screen. |
| `n`     | directory nest level. |


# Functions

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


# Escape Sequences

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
| `\e[999B`   | move cursor 999 lines down (go-to-bottom). |
