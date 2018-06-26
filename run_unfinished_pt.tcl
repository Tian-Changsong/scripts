#!/usr/bin/env tclsh
set corners [glob ./STA/func* ./STA/scan*]
set unfinished_corners ""
foreach corner $corners {
    if {[glob -nocomplain $corner/timing_reports/*wo_io.rpt] == ""} {
        lappend unfinished_corners $corner
    }
}
puts "INFO: Found [llength $unfinished_corners] unfinished_corners!"
foreach corner $unfinished_corners {
    set cmd [file normalize $corner/do_pt_si.csh]
    exec ssh -X pr6 xterm -T $corner -e $cmd &
}


