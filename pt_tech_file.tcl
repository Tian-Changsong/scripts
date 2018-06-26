source SETUPPATH/setup.tcl -continue_on_error
set log_dir ./log
sh mkdir -p $log_dir

set top_cell $vars(design)

## Please define mode func|scan|capture|shift
set mode CON_MODE
## Please define rc corner cworst|cbest|rcworst|rcbest
set rc_corner RC_CORNER
set rcCorner [lindex [split $rc_corner "_"] 0]
## Please define db corner wc|wcl|bc
set db_corner DB_CORNER
## please defind check_dir for setup or hold
set check_dir REPORT_TYPE
## voltage mode: nd or od
set voltageMode VOLTAGE_MODE
## If you want to generate sdf, please set true
set gen_sdf 0
## If you want to generate .lib/.db files, please set true
set create_db 1
###
set delay_type DELAY_TYPE
##############################################
set scenario ${mode}_${voltageMode}_${db_corner}_${rc_corner}_${check_dir}
##############################################

if {$vars(ILM_flow) == 1} {
    set sdc_file $vars(${mode}_${voltageMode},signoff_sdc_ilm)
} else {
    set sdc_file $vars(${mode}_${voltageMode},signoff_sdc)
}

set netlist $vars(top_netlist)
set spef_file $vars(spef_dir)/${top_cell}_${rc_corner}.spef.gz
set output_dir timing_reports
sh mkdir -p $output_dir
set session_dir session_$scenario
set filename ${top_cell}_timing.rpt

set report_default_significant_digits 4
set svr_keep_unconnected_nets true
set_app_var timing_crpr_threshold_ps 5
set timing_remove_clock_reconvergence_pessimism true
# make case analysis can be propagated through clock gating.
set case_analysis_propagate_through_icg true
set delay_calc_waveform_analysis_mode full_design
### add by jianqi Jul22 2015
set link_create_black_boxes false

suppress_message PTE-060
suppress_message PTE-054
suppress_message PTE-017

switch -regexp $scenario  {
    .*_ud_lt.*_.*_hold {
        set process ffg
    }
    .*_ud_ml_.*_.*_hold {
        set process ffg
    }
    .*_ud_wc_.*_.*_hold {
        set process ssg
    }
    .*_ud_wcl_.*_.*_hold {
        set process ssg
    } 
    .*_ud_wc_.*_.*_setup {
        set process ssg
    }
    .*_ud_wcl_.*_.*_setup {
        set process ssg
    }
    .*_nd_lt.*_.*_hold {
        set process ffg
    }
    .*_nd_ml_.*_.*_hold {
        set process ffg
    }
    .*_nd_wc_.*_.*_hold {
        set process ssg
    }
    .*_nd_wcl_.*_.*_hold {
        set process ssg
    } 
    .*_nd_wc_.*_.*_setup {
        set process ssg
    }
    .*_nd_wcl_.*_.*_setup {
        set process ssg
    }
    .*_od_lt.*_.*_hold {
        set process ffg
    }
    .*_od_ml_.*_.*_hold {
        set process ffg
    }
    .*_od_wc_.*_.*_hold {
        set process ssg
    }
    .*_od_wcl_.*_.*_hold {
        set process ssg
    } 
    .*_od_wc_.*_.*_setup {
        set process ssg
    }
    .*_od_wcl_.*_.*_setup {
        set process ssg
    }
}

## Please define search path and .db file list

set link_path "[concat [list *] $vars(${voltageMode}_${db_corner},db)]"
##############################################

#===================================================
# Star run PT check
#===================================================

sh date
sh hostname

if {$vars(ILM_flow) == 1} {
    foreach block  $vars(block_sets) {
        redirect -tee ${log_dir}/read_verilog_${block}.log {read_file -f verilog $vars($block,netlist)}
    }
}
redirect -tee ${log_dir}/read_verilog.log {read_file -f verilog $netlist}

current_design $top_cell
redirect -tee ${log_dir}/link_${voltageMode}_${db_corner}.log {link}

redirect -tee ${log_dir}/read_spef.log {read_parasitics -keep_capacitive_coupling -format SPEF $spef_file}
if {$vars(ILM_flow) == 1} {
    foreach block  $vars(block_sets) {
        redirect -tee ${log_dir}/${block}_spef.log {read_parasitics -keep_capacitive_coupling -increment -path $vars($block,hier_path) $vars(block_data_root)/${block}/SPEF/${block}_${rc_corner}.spef.gz}
    }
}

complete_net_parasitics -complete_with zero
redirect -tee ${log_dir}/read_sdc.log {source $sdc_file -echo -verbose -continue_on_error}

set timing_enable_prset_clear_arcs true


set_operating_conditions -analysis_type on_chip_variation 
set_propagated_clock [all_clocks]

#apply derating
set aocv_enable true
redirect -tee log/read_ocv.log {source /home/tony/project/bt1300/usr/tony/pr_arm/run_2/scripts/ocv_setting.tcl}
if {[info exists aocv_enable] && $aocv_enable == "true"} {
    # AOCV Criteria based on :
    set timing_aocvm_enable_analysis   true
    set pba_aocvm_only_mode            true
    set delay_calc_waveform_analysis_mode full_design
    # Define based on TSMC criteria
    if {[regexp {od} $voltageMode]} {
        #set timing_aocvm_analysis_mode   combined_launch_capture_depth
        set timing_aocvm_analysis_mode   separate_data_and_clock_metrics
    } elseif {[regexp {nd} $voltageMode]} {
        #set timing_aocvm_analysis_mode   combined_launch_capture_depth
        set timing_aocvm_analysis_mode   separate_data_and_clock_metrics
    } elseif {[regexp {ud} $voltageMode]} {
        set timing_aocvm_analysis_mode   separate_data_and_clock_metrics
    }
    redirect -tee log/read_aocv.log {source /home/tony/project/bt1300/usr/tony/pr_arm/run_2/scripts/aocv_setting.tcl}
}
#group inout paths
set all_clock_inputs ""
foreach_in_collection clock [ all_clocks ] {
    foreach_in_collection source [ get_attribute $clock sources ] {
        set all_clock_inputs [ add_to_collection $all_clock_inputs $source ]
    }
}
set all_data_inputs [ remove_from_collection [ all_inputs ] $all_clock_inputs ]
set all_data_outputs [ remove_from_collection [ all_outputs ] $all_clock_inputs ]

group_path -name REGOUT -to $all_data_outputs
group_path -name REGIN -from $all_data_inputs
group_path -name FEEDTHROUGH -from $all_data_inputs -to $all_data_outputs
group_path -name i2r -from [all_inputs]    -to [all_registers]
group_path -name r2r -from [all_registers] -to [all_registers]
group_path -name r2o -from [all_registers] -to [all_outputs]
group_path -name i2o -from [all_inputs]    -to [all_outputs]

## update timing with si
### si options for aocv confirmed by mavic
set si_enable_analysis true
set pba_aocvm_analysis_mode separate_data_and_clock_metrics
set si_xtalk_composite_aggr_mode statistical
set si_noise_composite_aggr_mode statistical
set si_composite_aggr_noise_peak_ratio 95.45
if {$delay_type eq "max"} {
    set si_xtalk_composite_aggr_noise_peak_ratio 0.05
} else {
    set si_xtalk_composite_aggr_noise_peak_ratio 0.01
}
set si_xtalk_double_switching_mode clock_network
set si_xtalk_composite_aggr_quantile_high_pct 95.45
###need confirm
#set si_xtalk_delay_analysis_mode all_path_edges
##### End Si Setting

update_timing -full
report_annotated_parasitics -list_not_annotated > ${log_dir}/report_para.log.${db_corner}
report_annotated_parasitics -list_not_annotated -pin_to_pin_nets -max_nets 200 > ${log_dir}/report_para_pin2pin.log.${db_corner}
#check_timing -verbose  > ${log_dir}/check_timing.log

#report_timing -pba_mode path -crosstalk_delta -cap -input -net -delay_type $delay_type -slack_lesser_than 0.0 -max_paths 10000 -derate -nosplit -path_type full_clock_expanded > ${output_dir}/${filename}.derate
report_timing -pba_mode path -crosstalk_delta -cap -input -net -delay_type $delay_type -slack_lesser_than 0.0 -max_paths 10000 -derate -nosplit -path_type full_clock_expanded -transition_time > ${output_dir}/${filename}.derate
report_constraint -all_violators -nosplit > ${output_dir}/${filename}.cons
report_constraint -all_violators -nosplit -max_transition -max_fanout -max_capacitance > ${output_dir}/${filename}.drc.cons
report_constraint -all_violators -verbose -nosplit > ${output_dir}/${filename}.cons.verb
report_clock_timing -type summary > ${output_dir}/${filename}.clksum
#report_analysis_coverage -status_details { untested } -exclude_untested { constant_disabled } -nosplit > ${output_dir}/${filename}.coverage

# Clock Network Double Switching Report
report_si_double_switching -nosplit -rise -fall > ${output_dir}/${top_cell}_si_double_switching.report

# Noise Settings
set_noise_parameters -enable_propagation
check_noise
update_noise
# Noise Reporting
report_noise -nosplit -all_violators -above -low  > ${output_dir}/${top_cell}_noise_all_viol_abv_low.report
report_noise -nosplit -nworst 10 -above -low > ${output_dir}/${top_cell}_noise_above_low_nworst10_verbose.report
report_noise -nosplit -all_violators -below -high > ${output_dir}/${top_cell}_noise_all_viol_below_high.report
report_noise -nosplit -nworst 10 -below -high > ${output_dir}/${top_cell}_noise_below_high_nworst10_verbose.report


set create_db 0
if {$create_db} {

    set extract_model_num_capacitance_points 7
    set extract_model_num_data_transition_points 7
    set extract_model_num_clock_transition_points 7
    set extract_model_use_conservative_current_slew TRUE

    ## This variable must be set to FALSE if libraries are defined with input capacitance ranges to model the Miller effect
    set extract_model_single_pin_cap TRUE

    ## If TRUE, extract_model traverses all clock tree paths, computes the insertion delay and creates clock latency arcs in the model
    #set extract_model_with_clock_latency_arcs TRUE

    #set_clock_gating_check

    # following 2 lines are for Model Validation Flow
    #extract_model -output ${top_cell}_${rm_operating_condition} -format {db lib} -lib -test_design -block_scope
    #write_interface_timing -timing_type slack ${top_cell}_${rm_operating_condition}.tim

    extract_model -output ${output_dir}/${top_cell}_${mode}_${voltageMode}_${db_corner}_${rc_corner}_${check_dir} -format {db lib} -library_cell
}


save_session $session_dir

#set_false_path -from $all_data_inputs
#set_false_path -to $all_data_outputs
set_false_path -from [all_inputs]
set_false_path -to [all_outputs]

update_timing

# dump data for ice
set dump_data_for_ice 1
set output_dir_ice ../ice_output
if {$dump_data_for_ice == 1} {
    if ![file exist $output_dir_ice] { exec mkdir $output_dir_ice -p }
    source /opt/eda/icexplorer2016.12.sp2/library/pt_utils.tcl 
    report_scenario_data_for_icexplorer $scenario $output_dir_ice
    report_pba_paths_for_icexplorer $scenario $output_dir_ice min_max 5000000 100
}
########################################################################
# Extra timing setting, mode timing relax
#
if { ${check_dir} == "setup" } {
    report_timing -pba_mode path -crosstalk_delta -cap -input -net -derate -nosplit -path_type full_clock_expanded -transition_time -significant_digits 3 \
        -max_paths 9999999 -slack_lesser_than 0 -nworst 1 \
        -delay_type max \
        > ${output_dir}/${top_cell}.xtk.setup.wo_io.rpt
}

if { ${check_dir} == "hold" } {
    report_timing  -pba_mode path -crosstalk_delta -cap -input -net -derate -nosplit -path_type full_clock_expanded -transition_time -significant_digits 3 \
        -max_paths 9999999 -slack_lesser_than 0 -nworst 1 \
        -delay_type min  \
        > ${output_dir}/${top_cell}.xtk.hold.wo_io.rpt
}

sh date
cputime
mem
exit
