# .gdbinit (uthreads)
# by Alex Mazansky
# February 6, 2024
# This code is open-source under the MIT license

set $col_blk = "\033[0m"
set $col_red = "\033[31m"
set $col_grn = "\033[32m"
set $col_yel = "\033[33m"
set $col_blu = "\033[34m"
set $col_pur = "\033[35m"

define-prefix uthreads

define uthreads state
    set $i = 0
    set $end = 100

    if $argc >= 1
        set $end = $arg0
    end

    while $i < $end
        # is it possible to set print color dynamically based on tty code and enum id from state??
        # printf "%02d: \033[%dm%d\033[30m, ", $i, 30 + uthreads[$i]->ut_state, uthreads[$i]->ut_state
        set $col_toprint = $col_blk

        # on cpu
        if uthreads[$i]->ut_state == 1
            set $col_toprint = $col_red
        else
            # runnable
            if uthreads[$i]->ut_state == 2
                set $col_toprint = $col_blu
            else
                # wait
                if uthreads[$i]->ut_state == 3
                    set $col_toprint = $col_yel
                else
                    # zombie
                    if uthreads[$i]->ut_state == 4
                        set $col_toprint = $col_grn
                    else
                        # transition
                        if uthreads[$i]->ut_state == 5
                            set $col_toprint = $col_pur
                        end
                    end
                end
            end
        end

        printf "%s%02d%s, ", $col_toprint, $i, $col_blk
        set $i = $i + 1
        if $i % 10 == 0
            echo \n
        end
    end

    if $end % 10 != 0
        echo \n
    end

    printf "key: %sNO_STATE, %sON_CPU, %sRUNNABLE, %sWAIT, %sZOMBIE, %sTRANSITION\n", $col_blk, $col_red, $col_blu, $col_yel, $col_grn, $col_pur
end

define uthreads npcount
    set $i = 0
    set $end = 100

    if $argc >= 1
        set $end = $arg0
    end

    while $i < $end
        printf "%02d: %d, ", $i, uthreads[$i]->ut_no_preempt_count
        set $i = $i + 1
        if $i % 10 == 0
            echo \n
        end
    end

    if $end % 10 != 0
        echo \n
    end
end

document uthreads state
Prints all threads color coded by their state.
Usage: uthreads state [num]

[num] is an optional parameter indicating what thread to stop at. Default = 100.
end

document uthreads npcount
Prints the no_preempt_count field for each thread.
Usage: uthreads npcount [num]

[num] is an optional parameter indicating what thread to stop at. Default = 100.
end
