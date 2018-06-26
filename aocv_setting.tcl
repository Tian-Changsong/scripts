
if {[regexp "od" $voltageMode]} {
    set corners ${voltageMode}_${db_corner}
} else {
    set corners $db_corner
} 

set aocvm_files [concat \
        [glob /home/tony/project/bt1300/input/lib/memory/*/*aocv*] \
        [glob /home/tony/project/bt1300/input/lib/std/*/*/aocv/*aocv*] \
]
foreach file $aocvm_files {
    read_aocvm $file >> $log_dir/read_aocvm_${voltageMode}_${db_corner}.log
}
# --------------------------------------------------------------------------------------------
# Apply voltage derates and net derates
# --------------------------------------------------------------------------------------------

redirect /dev/null {
    set cellsAocvCol [get_cells -hierarchical -filter "is_hierarchical == false"]
}
set clkTreeIsSvt 1
if {$clkTreeIsSvt == 1} {
    # Clock Tree is SVT
    if {[regexp {od} $voltageMode]} {
        if {$process == "ssg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early -0.027 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early -0.051 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early -0.051 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            }
        } elseif {$process == "ffg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.051 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.051 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.051 -increment [get_cells $cellsAocvCol]  
            }
        } else {
            echo "Error: Unsupported criteria corner \$process = $process"; set runFlow 0
        }
    } elseif {[regexp {nd} $voltageMode]} {
        if {$process == "ssg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early -0.043 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early -0.076 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early -0.076 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            }
        } elseif {$process == "ffg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.058 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.058 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.058 -increment [get_cells $cellsAocvCol]  
            }
        } else {
            echo "Error: Unsupported criteria corner \$process = $process"; set runFlow 0
        }
    } elseif {[regexp {ud} $voltageMode]} {
        if {$process == "ssg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early -0.078 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early -0.129 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early -0.129 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            }
        } elseif {$process == "ffg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.079 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.079 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.079 -increment [get_cells $cellsAocvCol]  
            }
        } else {
            echo "Error: Unsupported criteria corner \$process = $process"; set runFlow 0
        }
    } else {
        echo "Error: Unsupported voltage mode for $func"; set errorFlag 1
    }
} else {
    # Clock Tree is LVT
    if {[regexp {od} $voltageMode]} {
        if {$process == "ssg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early -0.022 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early -0.042 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early -0.051 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            }
        } elseif {$process == "ffg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.042 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.042 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.042 -increment [get_cells $cellsAocvCol]  
            }
        } else {
            echo "Error: Unsupported criteria corner \$process = $process"; set runFlow 0
        }
    } elseif {[regexp {nd} $voltageMode]} {
        if {$process == "ssg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early -0.031 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early -0.057 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early -0.072 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            }
        } elseif {$process == "ffg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.047 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.047 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.047 -increment [get_cells $cellsAocvCol]  
            }
        } else {
            echo "Error: Unsupported criteria corner \$process = $process"; set runFlow 0
        }
    } elseif {[regexp {ud} $voltageMode]} {
        if {$process == "ssg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early -0.045 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early -0.083 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early -0.110 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            }
        } elseif {$process == "ffg"} {
            if {$check_dir == "setup" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.066 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.000 -increment [get_cells $cellsAocvCol]  
            } elseif {$check_dir == "hold" } {
                set_timing_derate -clock -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -clock -cell_delay -late   0.062 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -early  0.000 -increment [get_cells $cellsAocvCol]  
                set_timing_derate -data  -cell_delay -late   0.062 -increment [get_cells $cellsAocvCol]  
            }
        } else {
            echo "Error: Unsupported criteria corner \$process = $process"; set runFlow 0
        }
    } else {
        echo "Error: Unsupported voltage mode for $func"; set errorFlag 1
    }
}

redirect -append -tee ${log_dir}/aocvm_annotated.rpt {report_aocvm}
