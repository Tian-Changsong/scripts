#!/usr/bin/env tclsh
set files [glob *.spef.gz]
foreach file $files {
    if {[file type $file] eq "link"} {
        continue
    }
    
    set parts [split [lindex [split $file {.}] 0] _]
    if {[lindex $parts 1] eq "cc"} {
        set rc_type c
    } elseif {[lindex $parts 1] eq "rc"} {
        set rc_type rc
    }
    puts $file
    switch  -- [lindex $parts 2] {
        "mat" {
            set rc_type1 worstT
        }
        "min" {
            set rc_type1 best
        }
        "max" {
            set rc_type1 worst
        }
        "typ" {
            set rc_type1 typical
        }
    }
    
    switch -exact -- [lindex $parts 3] {
        "125" {
            set rc_type2 125c
        }
        "-40" {
            set rc_type2 m40c
        }
        "25" {
            set rc_type2 25c
        }
        "0" {
            set rc_type2 m0c
        }
    }
    set link_name bt1300_core_${rc_type}${rc_type1}_${rc_type2}.spef.gz
    exec ln -sf $file $link_name
}
