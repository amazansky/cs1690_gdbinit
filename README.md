# cs1690_gdbinit

This is a (work-in-progress) collection of `.gdbinit` files for Brown University's Operating Systems course, [cs1670/1690](https://brown-cs1690.github.io/brown-cs167-s24/). These files add useful debugging commands for the course's programming projects.

## Examples
For the first programming project, [uthreads](https://github.com/brown-cs1690/handout/wiki/uthreads), the provided file adds the `uthreads state` command, which prints out the list of uthreads color-coded by their current state.

![Output of the `uthreads state` command](./.screenshots/uthreads_state.png)

## Setup

### Method 1: Direct download

This method is quicker to set up, but you'll have to redo most of the steps whenever you want to get updates to a dotfile or set up a new assignment.

For each project's initial setup, follow these steps:

1. In this GitHub repository, click into the folder corresponding to the assignment you're working on and open the `.gdbinit` file
2. In the upper right corner of the file viewer, click the download button ("Download raw file")
3. Move the downloaded file into the base directory of your project
4. Open a terminal, `cd` to the base directory of your project, and run the following command:
    ```
    mkdir -p ~/.config/gdb && echo add-auto-load-safe-path $PWD/.gdbinit >> ~/.config/gdb/gdbinit
    ```
5. Done! Run `gdb` as normal, and you should now have access to our debugging commands.

If you want to get new updates to a dotfile for a project you've already set up, follow all steps above **except** step 4.

### Method 2: Clone & symlink

This method requires a little more initial setup, but after that you can get updates to the dotfiles with minimal additional effort.

*(Instructions coming soon.)*

## Want to contribute?

If you're also taking Operating Systems and want to contribute to these dotfiles, please **make a pull request**! My hope is that this repository will become a collaborative space for OS students to share useful debugging tools, and any contributions to that end will be gladly welcomed.
