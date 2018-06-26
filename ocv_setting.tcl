if {[regexp {od} $voltageMode]} {
    if {$process == "ssg"} {
        if {$check_dir == "setup" } {
            set_timing_derate -clock -cell_delay -early  0.956
            set_timing_derate -clock -cell_delay -late   1.017
            set_timing_derate -data  -cell_delay -early  1.000
            set_timing_derate -data  -cell_delay -late   1.057
            set_timing_derate -net_delay  -late          1.060
            set_timing_derate -net_delay  -early         0.940
        } elseif {$check_dir == "hold" } {
            set_timing_derate -clock -cell_delay -early  0.927
            set_timing_derate -clock -cell_delay -late   1.022
            set_timing_derate -data  -cell_delay -early  0.875
            set_timing_derate -data  -cell_delay -late   1.000
            set_timing_derate -net_delay  -late          1.000
            set_timing_derate -net_delay  -early         0.915
            set_clock_uncertainty -hold 0.040 [get_clocks *]
        }
    } elseif {$process == "ffg"} {
        if {$check_dir == "setup" } {
            set_timing_derate -clock -cell_delay -early  0.962
            set_timing_derate -clock -cell_delay -late   1.089
            set_timing_derate -data  -cell_delay -early  1.000
            set_timing_derate -data  -cell_delay -late   1.174
        } elseif {$check_dir == "hold" } {
            set_timing_derate -clock -cell_delay -early  0.962
            set_timing_derate -clock -cell_delay -late   1.089
            set_timing_derate -data  -cell_delay -early  0.877
            set_timing_derate -data  -cell_delay -late   1.000
            set_clock_uncertainty -hold 0.030 [get_clocks *]
        }
        if {$rcCorner == "cbest"  || $rcCorner == "rcbest"   }  {set_timing_derate -net_delay  -late  1.085; set_timing_derate -net_delay  -early 1.000}
        if {$rcCorner == "cworst" || $rcCorner == "rcworst"  }  {set_timing_derate -net_delay  -late  1.000 ;set_timing_derate -net_delay  -early 0.915}
    } else {
        echo "Error: Unsupported corner $process"; set errorFlag 1
    }
    #set_max_transition 0.20 [current_design]
    #set_max_transition 0.12 [get_clocks *] -clock_path
    set_max_transition 0.25 [current_design]
    set_max_transition 0.15 [get_clocks *] -clock_path

} elseif {[regexp {nd} $voltageMode]} {
    # nd = Normal drive voltage mode, clock Tree = SVT
    if {$process == "ssg"} {
        if {$check_dir == "setup" } {
            set_timing_derate -clock -cell_delay -early  0.937
            set_timing_derate -clock -cell_delay -late   1.020
            set_timing_derate -data  -cell_delay -early  1.000
            set_timing_derate -data  -cell_delay -late   1.069
            set_timing_derate -net_delay  -late          1.060
            set_timing_derate -net_delay  -early         0.940
        } elseif {$check_dir == "hold" } {
            set_timing_derate -clock -cell_delay -early  0.892
            set_timing_derate -clock -cell_delay -late   1.032
            set_timing_derate -data  -cell_delay -early  0.827
            set_timing_derate -data  -cell_delay -late   1.000
            set_timing_derate -net_delay  -late          1.000
            set_timing_derate -net_delay  -early         0.915
            set_clock_uncertainty -hold 0.050 [get_clocks *]
        }
    } elseif {$process == "ffg"} {
        if {$check_dir == "setup" } {
            set_timing_derate -clock -cell_delay -early  0.963
            set_timing_derate -clock -cell_delay -late   1.095
            set_timing_derate -data  -cell_delay -early  1.000
            set_timing_derate -data  -cell_delay -late   1.179
        } elseif {$check_dir == "hold" } {
            set_timing_derate -clock -cell_delay -early  0.963
            set_timing_derate -clock -cell_delay -late   1.095
            set_timing_derate -data  -cell_delay -early  0.879
            set_timing_derate -data  -cell_delay -late   1.000
            set_clock_uncertainty -hold 0.040 [get_clocks *]
        }
        if {$rcCorner == "cbest"  || $rcCorner == "rcbest"   }  {set_timing_derate -net_delay  -late  1.085; set_timing_derate -net_delay  -early 1.000}
        if {$rcCorner == "cworst" || $rcCorner == "rcworst"  }  {set_timing_derate -net_delay  -late  1.000 ;set_timing_derate -net_delay  -early 0.915}
    } else {
        echo "Error: Unsupported corner $process"; set errorFlag 1
    }
    #####by michaeldu 20170308
    set_max_transition 0.35 [current_design]
    set_max_transition 0.15 [get_clocks *] -clock_path

} elseif {[regexp {ud} $voltageMode]} {
    # ud = Under drive voltage mode, clock Tree = LVT
    if {$process == "ssg"} {
        if {$check_dir == "setup" } {
            set_timing_derate -clock -cell_delay -early  0.873
            set_timing_derate -clock -cell_delay -late   1.049
            set_timing_derate -data  -cell_delay -early  1.000
            set_timing_derate -data  -cell_delay -late   1.182
            set_timing_derate -net_delay  -late          1.060
            set_timing_derate -net_delay  -early         0.940
        } elseif {$check_dir == "hold" } {
            set_timing_derate -clock -cell_delay -early  0.792
            set_timing_derate -clock -cell_delay -late   1.079
            set_timing_derate -data  -cell_delay -early  0.721
            set_timing_derate -data  -cell_delay -late   1.000
            set_timing_derate -net_delay  -late          1.000
            set_timing_derate -net_delay  -early         0.915
            set_clock_uncertainty -hold 0.151 [get_clocks *]
        }
    } elseif {$process == "ffg"} {
        if {$check_dir == "setup" } {
            set_timing_derate -clock -cell_delay -early  0.937
            set_timing_derate -clock -cell_delay -late   1.142
            set_timing_derate -data  -cell_delay -early  1.000
            set_timing_derate -data  -cell_delay -late   1.265
        } elseif {$check_dir == "hold" } {
            set_timing_derate -clock -cell_delay -early  0.937
            set_timing_derate -clock -cell_delay -late   1.142
            set_timing_derate -data  -cell_delay -early  0.814
            set_timing_derate -data  -cell_delay -late   1.000
            set_clock_uncertainty -hold 0.050 [get_clocks *]
        }
        if {$rcCorner == "cbest"  || $rcCorner == "rcbest"   }  {set_timing_derate -net_delay  -late  1.085; set_timing_derate -net_delay  -early 1.000}
        if {$rcCorner == "cworst" || $rcCorner == "rcworst"  }  {set_timing_derate -net_delay  -late  1.000 ;set_timing_derate -net_delay  -early 0.915}
    } else {
        echo "Error: Unsupported corner $process"; set errorFlag 1
    }
    set_max_transition 0.35 [current_design]
    set_max_transition 0.20 [get_clocks *] -clock_path
}
set_clock_uncertainty -setup 0.050 [get_clocks *]
