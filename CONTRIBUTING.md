# CONTRIBUTING

# Variables

| var     | meaning |
| ------- | ------- |
| LINES   | total lines in terminal. |
| PWD     | current directory.
| REPLY   | user input.
| f[@]    | every dir item. |
| c       | total number of dir items. |
| g       | previous dir when navigating to a bookmark. |
| j       | last dir item that fits on the screen. |
| k       | first dir item that fits on the screen. |
| l       | cursor position. |
| l2[@]   | history of parent dirs (used to remember previous location). |
| m       | number of lines that fit on the screen. |
| n       | directory nest level. |

# Functions

| func      | meaning |
| --------- | ------- |
| refresh() | clear the screen and calculate window size. |
| get_dir() | get the list of dir items from `$PWD`. |
| f_print() | print the dir items to the terminal. |
| path()    | get the absolute path of a path. |
| hist()    | add a cursor position to the location history. |
| open()    | navigate to a dir or open a file. |
| prompt()  | handle user input. |
| key()     | handle key-presses. |
| main()    | set traps and start loop. |
