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
set $col_cyn = "\033[36m"

define-prefix uthreads

define uthreads state
    # print a list of threads color coded by state
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
    # print a list of threads and their no_preempt_count
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

define uthreads runq
    # print the contents of the run queue
    printf "%scurthr%s: %02d\n", $col_pur, $col_blk, ut_curthr->ut_id
    set $mismatch = 0
    set $unrunnable = 0

    set $maxprio = 7
    set $i = $maxprio
    while $i >= 0
        printf "%s%d%s: ", $col_pur, $i, $col_blk

        # simulate utqueue_empty assertion by calculating queue size and list links myself

        # 1. size=0 variable based on whether the size field is 0
        set $num_links = runq_table[$i].tq_size
        set $size0 = !$num_links

        # 2. nolinks variable based on a lack of links (nothing in queue)
        # this is a little sketchy and implementation-dependent (it assumes
        # that ut_link is the first field in struct uthread) but it works here
        set $listitem = ((uthread_t *) runq_table[$i]->tq_waiters.l_prev)
        set $nolinks = $listitem == ((uthread_t *) $listitem->ut_link->l_prev)

        # If everything is working, $size0 == $nolinks at all times. However in
        # practice this is not always the case, so we should warn the user if
        # something is amiss.

        set $printlinks = 0

        if !$size0 && !$nolinks
            # both size0 and nolinks agree we're non-empty
            set $printlinks = 1
        else
            if $size0 && !$nolinks
                # queue thinks it's empty (size == 0) but actually has links
                printf "%s(mismatch!)%s queue has tq_size == 0 but actually contains the following links: ", $col_red, $col_blk
                set $mismatch = 1
                set $printlinks = 1
            else
                if !$size0 && $nolinks
                    # queue thinks it is nonempty (size != 0) but actually has no links
                    printf "%s(mismatch!)%s queue has tq_size == %d but actually contains no links", $col_red, $col_blk, $num_links
                    set $mismatch = 1
                else
                    # size0 and nolinks agree we're empty
                    printf "%s(empty)%s", $col_cyn, $col_blk
                end
            end
        end

        if $printlinks
            set $listitem_first = $listitem

            while ((uthread_t *) $listitem->ut_link->l_prev) != $listitem_first

                if $listitem->ut_state == UT_RUNNABLE
                    printf "%02d, ", $listitem->ut_id
                else
                    # Print warning if any thread we encounter is not runnable
                    printf "%s%02d*%s, ", $col_yel, $listitem->ut_id, $col_blk
                    set $unrunnable = 1
                end

                set $listitem = ((uthread_t *) $listitem->ut_link->l_prev)
            end
        end

        echo \n
        set $i = $i - 1
    end

    # After printing all priority levels, print user warnings if applicable
    if $mismatch
        printf "\nIf you're seeing this message, it's because you got at least \
one mismatch, meaning the corresponding utqueue's internal data structures \
disagreed on whether or not the queue is empty. This likely indicates bad \
preemption logic somewhere in your code.\n"
    end

    if $unrunnable
        printf "\nIf you're seeing this message, it's because at least one \
thread in your run queue (marked in yellow and with an asterisk) was not in \
the UT_RUNNABLE state. This should never happen, and likely indicates bad \
logic involving queueing or `ut_state` somewhere in your code.\n"
    end
end

document uthreads
uthreads debugging tools created by Alex Mazansky

This command is part of `cs1690_gdbinit`, a set of debugging tools created by
Alex Mazansky for cs1670/1690, the Operating Systems class at Brown University.
These tools are open source! You can find them online at:
https://github.com/amazansky/cs1690_gdbinit
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

document uthreads runq
Prints the contents of the run queue by priority.
Usage: uthreads runq

This command traverses the internal data structures of the run queue, namely
the utqueue for each priority level, and displays the output. Along the way, it
also double-checks to make sure that the size field agrees with the internal
linked list implementation of the queue with respect to whether the queue is
empty or not. (This logic is the same as the assertion made in
`utqueue_empty()`.) If there are any discrepancies, the user is warned.

(Implementation Details) This command relies on the assumption that the ut_link
field of utqueue_t is the first item in the struct, i.e. its memory address is
the same as the whole utqueue_t struct. (This assumption was true at the time of
development, and can be verified in gdb with the `ptype/o uthread_t` command.)
If that assumption is no longer true, you will have to use pointer arithmetic to
offset the memory address in a similar way to how the `list_item()` macro works.
end
