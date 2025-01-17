# weenix

In weenix, one of the biggest annoyances while debugging is the inability to restart the gdb session, because you have to manually re-add your breakpoints on each new debuging run.

Enter `.gdbinit`! For this project, we give you the ability to reuse your breakpoints across gdb sessions with two simple commands: First, run `we sbq` to save your breakpoints and quit the session. Then open gdb again and run `we lb` to load your breakpoints back. Magic!

## Setup

For weenix, two versions of `.gdbinit` are available. One version logs all of your gdb sessions (your command inputs and their outputs) to a text file for your future reference, which can sometimes be useful. The other version does not perform this logging. Aside from that difference, the two versions are the same.

After choosing which version you want, follow the setup instructions given in the main `README.md` file for this repository.

## Commands

For the weenix project, this `.gdbinit` file provides the following useful debugging commands:

1. `weenix sb` (or `we sb`): Saves your breakpoints out to a file for loading later, since you can't restart gdb for weenix.
2. `weenix sbq` (or `we sbq`): Saves your breakpoints out to a file and then quits your debugging session.
3. `weenix lb` (or `we lb`): Loads your previously-saved breakpoints to the current gdb session.
4. `weenix lbt` (or `we lbt`): Loads your previously-saved breakpoints to the current gdb session and then opens the TUI.

In addition, the version with logging enabled provides the following extra commands, since gdb has a bug that would otherwise prevent logging continuity across opening/closing the TUI.

5. `weenix plus` (or `we p`): Opens the TUI while preserving logging.
6. `weenix minus` (or `we m`): Closes the TUI while preserving logging.

You can also use the `help weenix` (or `h we`) command within gdb to display a help page with this information.
