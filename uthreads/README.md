# uthreads

## Setup

Follow the setup instructions given in the main `README.md` file for this repository.

## Commands

For the uthreads project, this `.gdbinit` file provides the following useful debugging commands:

1. `uthreads state [num]` (or `ut s [num]`): Print the first `num` threads, color-coded by their state. If no value of `num` is provided, the default is 100.
2. `uthreads npcount [num]` (or `ut np [num]`): Print the first `num` threads and their corresponding values of `ut_no_preempt_count`. If no value of `num` is provided, the default is 100.
3. `uthreads runq` (or `ut r`): Print the contents of the run queue, sorted by priority level.

You can also use the `help uthreads` (or `h ut`) command within gdb to display a help page with this information.

## Example

![Output of the `uthreads state` command](../.screenshots/uthreads_state.png)

This screenshot shows an example output of the `uthreads state` (or `ut s`) command, with the default `end` value of 100.
