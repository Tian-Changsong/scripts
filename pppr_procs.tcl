proc P_generage_tracks {} {
    add_tracks -honor_pitch
}
proc P_regenerate_row {} {
    global pppr
    deleteRow -all
    createRow -site $pppr(site,std)
    createRow -site $pppr(site,psw) -noFlip

}
proc P_global_net_connect {} {
    global pppr
    foreach power_domain [dbget top.pds] {
        set pd_name [dbget $power_domain.name]
        set primary_power [dbget $power_domain.primaryPowerNet.name]
        globalNetConnect $pppr(power,aon) -pin BIASCNW -all -type pgpin
        globalNetConnect $pppr(power,aon) -pin BIASNW  -all -type pgpin
        globalNetConnect $pppr(gnd) -pin BIASPW  -all -type pgpin
        globalNetConnect $pppr(gnd) -pin VSS     -all -type pgpin
        globalNetConnect $pppr(gnd) -pin VSSE    -all -type pgpin
        globalNetConnect $pppr(power,aon) -pin VNW     -all -type pgpin
        globalNetConnect $pppr(gnd) -pin VPW     -all -type pgpin
        globalNetConnect $primary_power -pin VDD  -type pgpin -powerDomain $pd_name
        globalNetConnect $primary_power -pin VDDCE -type pgpin -powerDomain $pd_name -override
        globalNetConnect $primary_power -pin VDDE -type pgpin -powerDomain $pd_name -override
        globalNetConnect $pppr(power,aon) -pin VDDG  -type pgpin 
    }
}
proc P_add_pg_ring {} {
    global pppr
    setAddRingMode -stacked_via_top_layer M6 \
        -stacked_via_bottom_layer M5
    foreach pd [dbget [dbget top.pds.isAlwaysOn 0 -p].name] {
        deselectAll
        selectObject Group $pd
        addRing \
            -skip_via_on_wire_shape Noshape \
            -skip_via_on_pin Standardcell \
            -around power_domain \
            -jog_distance 2.5 \
            -threshold 2.5 \
            -type block_rings \
            -nets "$pppr(power,aon) $pppr(gnd)" \
            -layer {bottom M6 top M6 right M5 left M5} \
            -width 1 \
            -spacing 0.25 \
            -offset 0.3
    }
    deselectAll
}

proc P_add_halo {} {
    addHaloToBlock 0.8 0.8 0.8 0.8 -allBlock
}


proc P_add_pg_stripe {args} {
    parse_proc_arguments -args $args results
    global pppr
    if {$results(-type) eq "global"} {
        setAddStripeMode -reset
        setAddStripeMode -stacked_via_bottom_layer M5 -stacked_via_top_layer M6
        setAddStripeMode -ignore_nondefault_domains 1
        foreach layer [list M6 M5] {
            set lower_layer "M[expr [regsub "M" $layer ""]-1]"
            set upper_layer "M[expr [regsub "M" $layer ""]+1]"
            set direction [string tolower [dbget [dbget head.layers.name $layer -p].direction]]
            addStripe -width $pppr(width,$layer) \
                -nets $pppr(gnd) \
                -layer $layer \
                -direction $direction \
                -set_to_set_distance $pppr(pitch,$layer) \
                -spacing $pppr(spacing,$layer) \
                -start_offset $pppr(gnd_offset,$layer) \
                -switch_layer_over_obs 0 \
                -max_via_size {Ring 100 100 100 100} \
                -padcore_ring_bottom_layer_limit M5 \
                -padcore_ring_top_layer_limit M6 \
                -block_ring_bottom_layer_limit M5 \
                -block_ring_top_layer_limit M6 \
                -skip_via_on_pin Standardcell \
                -merge_stripes_value 2.5 \
                -max_same_layer_jog_length 0 \
                -extend_to design_boundary \
                -create_pins 1
            addStripe -width $pppr(width,$layer) \
                -nets $pppr(power,aon) \
                -layer $layer \
                -direction $direction \
                -set_to_set_distance $pppr(pitch,$layer) \
                -spacing $pppr(spacing,$layer) \
                -start_offset $pppr(aon_offset,$layer) \
                -switch_layer_over_obs 0 \
                -max_via_size {Ring 100 100 100 100} \
                -padcore_ring_bottom_layer_limit M5 \
                -padcore_ring_top_layer_limit M6 \
                -block_ring_bottom_layer_limit M5 \
                -block_ring_top_layer_limit M6 \
                -skip_via_on_pin Standardcell \
                -merge_stripes_value 2.5 \
                -max_same_layer_jog_length 0 \
                -extend_to design_boundary \
                -create_pins 1
        }

    } 
    if {$results(-type) eq "local"} {
        # M5 and M6
        setAddStripeMode -reset
        setAddStripeMode -stacked_via_bottom_layer M5 -stacked_via_top_layer M6
        foreach pd [dbget [dbget top.pds.isAlwaysOn 0 -p].name] {
            deselectAll
            selectObject Group $pd
            set sw_net [dbget [dbget top.pds.name $pd -p].primaryPowerNet.name]
            foreach layer [list M6 M5] {
                set direction [string tolower [dbget [dbget head.layers.name $layer -p].direction]]
                set area [lindex [dbget [dbget top.pds.name $pd -p].group.members.box] 0]
                scan $area {%f %f %f %f} pd_llx pd_lly pd_urx pd_ury
                if {$layer eq "M5"} {
                    set first_gnd [P_get_first_pg -area $area -net $pppr(gnd) -layer $layer -direction left_to_right]
                    set offset [expr {[dbget $first_gnd.box_llx]+$pppr(pitch,$layer)*2/3-$pd_llx}]
                } elseif {$layer eq "M6"} {
                    set first_gnd [P_get_first_pg -area $area -net $pppr(gnd) -layer $layer -direction bottom_to_top]
                    set offset [expr {[dbget $first_gnd.box_lly]+$pppr(pitch,$layer)*2/3-$pd_lly}]
                }

                addStripe -width $pppr(width,$layer) \
                    -nets $sw_net \
                    -layer $layer \
                    -direction $direction \
                    -set_to_set_distance $pppr(pitch,$layer) \
                    -spacing $pppr(spacing,$layer) \
                    -start_offset $offset \
                    -over_power_domain 1 \
                    -switch_layer_over_obs 0 \
                    -max_via_size {Ring 100 100 100 100} \
                    -padcore_ring_bottom_layer_limit M5 \
                    -padcore_ring_top_layer_limit M6 \
                    -block_ring_bottom_layer_limit M5 \
                    -block_ring_top_layer_limit M6 \
                    -skip_via_on_pin Standardcell \
                    -merge_stripes_value 2.5 \
                    -max_same_layer_jog_length 0 \
                    -create_pins 0
            }
        }
        deselectAll
        # add vias for memory pin
        set macros [dbget top.insts.cell.subClass block -p2]
        foreach macro $macros {
            set box [dbget $macro.box]
            editPowerVia -bottom_layer M4 -top_layer M6 -delete_vias 1 -area [lindex $box 0]
            editPowerVia -bottom_layer M4 -top_layer M5 -add_vias 1 -area [lindex $box 0]
            editPowerVia -bottom_layer M5 -top_layer M6 -add_vias 1 -area [lindex $box 0]
        }
        

    }
    if {$results(-type) eq "rail"} {
        # M1 rail
        sroute -connect { corePin floatingStripe} \
            -layerChangeRange { M1 M5 } \
            -corePinTarget { none } \
            -corePinLayer M2 \
            -allowJogging 0 \
            -crossoverViaLayerRange { M1 M5 } \
            -nets [dbget [dbget top.physNets.isPwrOrGnd 1 -p].name] \
            -allowLayerChange 0 \
            -targetViaLayerRange { M1 M5 } \
            -floatingStripeTarget { followpin }
    }

    if {$results(-type) eq "channel"} {
        foreach pd [dbget top.pds] {
            set power_net [dbget $pd.primaryPowerNet.name]
            set gnd_net [dbget $pd.primaryGroundNet.name]
            set pd_name [dbget $pd.name]
            set channel_boxes [P_get_channel_area -power_domain $pd_name -width $pppr(psw,channel_threshold)]
            foreach box $channel_boxes {
                set box_extend [lindex [dbShape $box SIZEY 0.4] 0]
                set box_stripe [lindex [dbShape $box SIZEY 0.2] 0]
                scan $box_stripe {%f %f %f %f} box_stripe_llx box_stripe_lly box_stripe_urx box_stripe_ury
                set width [format "%.3f" [expr {$box_stripe_urx-$box_stripe_llx}]]
                deselectAll
                editSelect -layer M5 -type Special
                editCutWire -box $box_extend -selected
                deselectAll
                editSelect -area $box_extend -direction V -type Special
                editSelectVia -area $box_extend -cut_layer {VIA1 VIA2 VIA3 VIA4} -type Special
                editDelete -selected
                deselectAll
                if {$width < 1.25} {
                    puts "Error: Found narrow channel with width $width at $box, no stripes will be inserted, please check !"
                } elseif {$width > 1.25} {
                    dbCreateWire $power_net [expr {$box_stripe_llx+0.25*2}] $box_stripe_lly [expr {$box_stripe_llx+0.25*3}] $box_stripe_ury 5 1 STRIPE
                    dbCreateWire $gnd_net [expr {$box_stripe_llx+0.25*4}] $box_stripe_lly [expr {$box_stripe_llx+0.25*5}] $box_stripe_ury 5 1 STRIPE
                }
                if {$width > 2.25} {
                    dbCreateWire $power_net [expr {$box_stripe_urx-0.25*4}] $box_stripe_lly [expr {$box_stripe_urx-0.25*3}] $box_stripe_ury 5 1 STRIPE
                    dbCreateWire $gnd_net [expr {$box_stripe_urx-0.25*2}] $box_stripe_lly [expr {$box_stripe_urx-0.25*1}] $box_stripe_ury 5 1 STRIPE
                }
                editPowerVia -bottom_layer M5 -top_layer M6 -add_vias 1 -area $box_stripe
                editPowerVia -bottom_layer M1 -top_layer M5 -add_vias 1 -area $box_stripe
                editSelect -area $box_stripe -layer M5 -type Special
                editTrim -selected
            }
        }
    }
}
define_proc_arguments P_add_pg_stripe -info "Add PG stripes in core, channel, and on macros" \
    -define_args {
        {-type "String help" "string_val" one_of_string {required value_help {values {global local rail channel}}}}
    }

proc P_delete_powerswitch {} {
    foreach pd [dbget top.pds.isAlwaysOn 0 -p] {
        deletePowerSwitch -powerDomain [dbget $pd.name]
    }
}

proc P_get_first_pg {args} {
    parse_proc_arguments -args $args results
    set swires_in_area [dbQuery -area $results(-area) -objType sWire]
    set swires [dbget [dbget $swires_in_area.net.name $results(-net) -p2].layer.name $results(-layer) -p2]
    #set box_list [dbget [dbget [dbget top.physNets.name $results(-net) -p].sWires.layer.name $results(-layer) -p2].box]
    set first_value ""
    set swire_found ""
    if {$swires != "0x0"} {
        foreach swire $swires {
            set swire_box [lindex [dbget $swire.box] 0]
            scan $swire_box {%f %f %f %f} swire_llx swire_lly swire_urx swire_ury
            switch -exact -- $results(-direction) {
                "bottom_to_top" {
                    if {$first_value == ""} {
                        set first_value $swire_lly
                        set swire_found $swire
                    } else {
                        if {$swire_lly < $first_value} {
                            set first_value $swire_lly
                            set swire_found $swire
                        }
                    }
                }
                "top_to_bottom" {
                    if {$first_value == ""} {
                        set first_value $swire_lly
                        set swire_found $swire
                    } else {
                        if {$swire_lly > $first_value} {
                            set first_value $swire_lly
                            set swire_found $swire
                        }
                    }
                }
                "left_to_right" {
                    if {$first_value == ""} {
                        set first_value $swire_llx
                        set swire_found $swire
                    } else {
                        if {$swire_llx < $first_value} {
                            set first_value $swire_llx
                            set swire_found $swire
                        }
                    }
                }
                "right_to_left" {
                    if {$first_value == ""} {
                        set first_value $swire_llx
                        set swire_found $swire
                    } else {
                        if {$swire_llx > $first_value} {
                            set first_value $swire_llx
                            set swire_found $swire
                        }
                    }
                }
            }
        }
        return $swire_found
    } else {
        return "NONE"
    }
}
define_proc_arguments P_get_first_pg -info "get first PG stripe" \
    -define_args {
        {-area "area to search" area list required}
        {-layer "layer name" layer string required}
        {-direction "direction" direction one_of_string {required value_help {values {bottom_to_top top_to_bottom left_to_right right_to_left}}}}
        {-net "PG net name" net_name string required}
        #"arg_name"  "option_help"  "value_help"  "data_type" "attributes"
        #data_type:string, list, boolean, int, integer, float, or one_of_string
        #attributes|required|optional|internal|value_help|values {allowable_values} | merge_duplicates
    }



proc P_get_channel_area {args} {
    parse_proc_arguments -args $args results
    global pppr
    set domain_name $results(-power_domain)
    set channel_shape ""
    set macros [dbget [dbget top.insts.cell.subClass block -p2].pd.name $domain_name -p2]
    set all_shape_blocked ""
    set power_domain [dbget top.pds.name $domain_name -p]
    set domain_boxes [lindex [dbget $power_domain.group.boxes] 0]
    foreach macro $macros {
        if {[dbget $macro.boxes] eq "0x0"} {
            set box [dbget $macro.box]
            set box_expand_halo [dbShape $box SIZE 0.8] ;# include halo
            set all_shape_blocked [dbShape $box_expand_halo OR $all_shape_blocked]
        } else {
            set boxes [lindex [dbget $macro.boxes] 0]
            foreach box $boxes {
                set box_expand_halo [dbShape $box SIZE 0.8] ;# include halo
                set all_shape_blocked [dbShape $box_expand_halo OR $all_shape_blocked]
            }
        }
    }
    set hard_blockage_boxes [dbget -e [dbget top.fplan.pBlkgs.type hard -p].boxes]
    set all_shape_blocked [dbShape $all_shape_blocked OR $hard_blockage_boxes]
    set rows [dbget top.fplan.rows.site.name $pppr(site,std) -p2]
    set row_height [dbget [dbget head.sites.name $pppr(site,std) -p].size_y]
    foreach row $rows {
        set row_box [lindex [dbget $row.box] 0]
        set row_box_in_pd [dbShape $row_box AND $domain_boxes]
        if {$row_box_in_pd != ""} {
            set box_exclude_macro [dbShape $row_box_in_pd ANDNOT $all_shape_blocked]
            foreach box $box_exclude_macro {
                scan $box {%f %f %f %f} box_llx box_lly box_urx box_ury
                set width [format "%.3f" [expr {$box_urx-$box_llx}]]
                set height [format "%.3f" [expr {$box_ury-$box_lly}]]
                if {$width <= $results(-width) && $height == $row_height} {
                    set channel_shape [dbShape $channel_shape OR $box -output hrect]
                }
            }
        }
    }
    if {0} {
        clearDrc
        foreach box $channel_shape {
            createMarker -bbox $box
        }
    }
    return $channel_shape
}
define_proc_arguments P_get_channel_area -info "P_get_channel_area" \
    -define_args {
        {-power_domain "power domain name" domain_name string required}
        {-width "channel width threshold, channels narrower than this value are returned" width float required}
    }
proc P_insert_boundary_cells {} {
    global pppr
    setEndCapMode -reset
    setEndCapMode \
        -leftEdge $pppr(cell,endcap_LR) \
        -rightEdge $pppr(cell,endcap_LR) \
        -topEdge $pppr(cell,endcap_TB) \
        -bottomEdge $pppr(cell,endcap_TB) \
        -rightBottomEdge $pppr(cell,endcap_RB_EDGE) \
        -rightTopEdge $pppr(cell,endcap_RT_EDGE) \
        -leftTopCorner $pppr(cell,endcap_LR) \
        -leftBottomCorner $pppr(cell,endcap_LR)
        #-rightBottomCorner $pppr(cell,endcap) \
        #-rightTopCorner $pppr(cell,endcap) \
        #-rightTopEdge $pppr(cell,endcap) \
        #
    foreach pd [dbget top.pds.name] {
        addEndCap -prefix BOUNDARY_$pd -powerDomain $pd
    }
}
    
proc P_insert_power_switch {args} {
    global pppr
    parse_proc_arguments -args $args results
    set power_domain $results(-power_domain)
    set skip_row $results(-skip_row)
    set horizontal_pitch $results(-horizontal_pitch)
    set module_instance [dbget [dbget top.pds.name $power_domain -p].group.members.name]
    set domain_box [dbget [dbget top.pds.name $power_domain -p].group.members.box]
    scan [lindex $domain_box 0] {%f %f %f %f} domain_llx domain_lly domain_urx domain_ury
    if {$results(-type) eq "channel"} {
        set channels [P_get_channel_area -power_domain $power_domain -width $pppr(psw,channel_threshold)]
        foreach box $channels {
            scan $box {%f %f %f %f} box_llx box_lly box_urx box_ury
            set offset_adjust [format "%.3f" [expr $pppr(site,width) - [P_fmod $box_llx $pppr(site,width)]]]
            set width_thresold [format "%.3f" [expr {$offset_adjust+$pppr(cell_width,psw_channel)+$pppr(cell_width,endcap_LR)*2+$pppr(cell_width,welltap)}]]
            set width [format "%.3f" [expr {$box_urx-$box_llx}]]
            set leftOffset [expr {$offset_adjust+$pppr(cell_width,endcap_LR)+$pppr(cell_width,welltap)}]
            set first_m6_aon [P_get_first_pg -area $box -layer M6 -direction bottom_to_top -net $pppr(power,aon)]
            scan [lindex [dbget $first_m6_aon.box] 0] {%f %f %f %f} m6_llx m6_lly m6_urx m6_ury
            set bottomOffset [expr {$m6_lly-$box_lly}]

            if {$width > $width_thresold} {
                addPowerSwitch \
                    -column \
                    -powerDomain $power_domain \
                    -globalSwitchCellName $pppr(psw,channel) \
                    -skipRows $skip_row \
                    -area $box \
                    -ignoreSoftBlockage \
                    -noEnableChain \
                    -horizontalPitch $horizontal_pitch\
                    -leftOffset $leftOffset \
                    -bottomOffset $bottomOffset \
                    -incremental \
                    -instancePrefix PSW_CHANNEL_${power_domain}_ \
                    -switchModuleInstance $module_instance

            }
        }
    }
    if {$results(-type) eq "core"} {
        set channels [P_get_channel_area -power_domain $power_domain -width $pppr(psw,channel_threshold)]
        foreach box $channels {
            createPlaceBlockage -type hard -box $box -name channel_blockage_tmp
        }
        set first_m6_aon [P_get_first_pg -area $domain_box -layer M6 -direction bottom_to_top -net $pppr(power,aon)]
        set first_m5_aon [P_get_first_pg -area $domain_box -layer M5 -direction left_to_right -net $pppr(power,aon)]
        scan [lindex [dbget $first_m6_aon.box] 0] {%f %f %f %f} m6_llx m6_lly m6_urx m6_ury
        scan [lindex [dbget $first_m5_aon.box] 0] {%f %f %f %f} m5_llx m5_lly m5_urx m5_ury
        set bottomOffset [expr {$m6_lly+0-$domain_lly}]
        set leftOffset [expr {$m5_llx-$domain_llx}]
        addPowerSwitch \
            -column \
            -globalSwitchCellName $pppr(psw,core) \
            -skipRows $skip_row \
            -noEnableChain \
            -ignoreSoftBlockage \
            -noFixedStdCellOverlap \
            -horizontalPitch $horizontal_pitch \
            -leftOffset $leftOffset  \
            -bottomOffset $bottomOffset \
            -incremental \
            -instancePrefix PSW_CORE_${power_domain}_ \
            -powerDomain $power_domain \
            -switchModuleInstance $module_instance \
            -checkerBoard
        catch {deletePlaceBlockage channel_blockage_tmp}
    }
}
define_proc_arguments P_insert_power_switch -info "Insert psw in core and channel" \
    -define_args {
        {-power_domain "power_domain" power_domain string required}
        {-skip_row "row number to skip" skip_row_number integer required}
        {-horizontal_pitch "horizontal pitch" pitch float required}
        {-type "powerswitch type, channel or core" type string one_of_string {required value_help {values {core channel}}}}
    }


proc P_insert_fp_cells {} {
    global pppr
    set spgAddTapInBoundaryRow 1
    set spgWellTapCheckVio 1
    #deleteInst *DECAP*
    #deleteInst *WELLTAP*
    foreach pd [dbget top.pds] {
        set domain_box [lindex [dbShape [dbget $pd.group.boxes] BBOX] 0]
        scan $domain_box {%f %f %f %f} domain_llx domain_lly domain_urx domain_ury
        set pd_name [dbget $pd.name]
        set first_m5_aon [P_get_first_pg -area $domain_box -layer M5 -direction left_to_right -net $pppr(power,aon)]
        scan [lindex [dbget $first_m5_aon.box] 0] {%f %f %f %f} m5_llx m5_lly m5_urx m5_ury
        set tap_offset [expr {$m5_llx+12.44-$domain_llx}]
        addWellTap -cell $pppr(cell,welltap)  -cellInterval [expr {$pppr(hunit)*18}]  -prefix WELLTAP -checkerBoard -powerDomain $pd_name -inRowOffset $tap_offset
        #verifyWellTap -cell $pppr(cell,welltap) -rule 29 -powerDomain PD_ALLON
        #addWellTap -cell PEH_TAPPN -cellInterval [expr 56 * 2] -prefix WELLTAP -checkerBoard -incremental PEH_TAPPN  -powerDomain PD_ALLON
        addWellTap -cell $pppr(cell,decap)  -cellInterval [expr {$pppr(hunit)*18}]  -prefix DECAP -fixedGap -checkerBoard -powerDomain $pd_name -inRowOffset $tap_offset
    }
}
proc P_fmod {divident divisor} {
    set remainder [format "%.3f" [expr {fmod($divident,$divisor)}]]
    if {$remainder == $divisor} {
        set result 0.0
    } else {
        set result $remainder
    }
    return $result
}
proc P_add_psw_power_stripe {args} {
    parse_proc_arguments -args $args results
    global pppr
    set module_instance [dbget [dbget top.pds.name $results(-power_domain) -p].group.members.name]
    set sw_net [dbget [dbget top.pds.name $results(-power_domain) -p].primaryPowerNet.name]
    set aon_net $pppr(power,aon)
    setViaGenMode -reset

    if {$results(-type) eq "core"} {
        set psws [dbget -e top.insts.name $module_instance/PSW_CORE_* -p]
    } elseif {$results(-type) eq "channel"} {
        set psws [dbget -e top.insts.name $module_instance/PSW_CHANNEL_* -p]
    }
    set psw_number [llength $psws]
    set count 0
    foreach psw $psws {
        puts "INFO: \[$count/$psw_number]: Current powerswitch is [dbget $psw.name]"
        incr count
        #set psw [dbget top.insts.name u_mcu_top/PSW_CORE_PD_MCU_psoI_PD_MCU_17_HEADBUFBIAS41_X3M_A7PP140ZTH_C40_1249_963_108 -p]
        set psw_box [dbget $psw.box]
        scan [lindex $psw_box 0] {%f %f %f %f} psw_box_llx psw_box_lly psw_box_urx psw_box_ury
        # create M2 shapes on pins
        set sw_pin_shapes ""
        set aon_pin_shapes ""
        # for HEADBUFTIE41_X3M_A7PP140ZTH_C40
        lappend sw_pin_shapes [list $psw_box_llx [expr $psw_box_lly-0.13/2] $psw_box_urx [expr $psw_box_lly+0.13/2]];#VDD
        lappend sw_pin_shapes [list $psw_box_llx [expr $psw_box_ury-0.13/2] $psw_box_urx [expr $psw_box_ury+0.13/2]];#VDD
        lappend aon_pin_shapes [list [expr $psw_box_llx+0.12] [expr $psw_box_lly+1.035] [expr $psw_box_urx-0.12] [expr $psw_box_lly+1.035+0.13]];#VDDG
        lappend aon_pin_shapes [list [expr $psw_box_llx+0.12] [expr $psw_box_lly+0.235] [expr $psw_box_urx-0.12] [expr $psw_box_lly+0.235+0.13]];#VDDG

        foreach box $aon_pin_shapes {
            dbCreateWire $aon_net {*}$box 2 0 STRIPE
        }
        foreach box $sw_pin_shapes {
            dbCreateWire $sw_net {*}$box 2 0 STRIPE
        }


        set track_skip(M3) 6
        set track_skip(M4) 4
        set track_skip(M5) 6
        foreach layer [list M3 M4] {
            set stripe_box_list ""
            set direction [dbget [dbget head.layers.name $layer -p].direction]
            #set width [dbget [dbget head.layers.name $layer -p].width]
            if {$layer eq "M3"} {
                set width 0.25
                set direction_id 1
            } elseif {$layer eq "M4"} {
                set width 0.13
                set direction_id 0
            }
            
            if {$direction eq "Horizontal"} {
                set pitch [dbget [dbget head.layers.name $layer -p].pitchY]
                set start [format "%.3f" [expr {$psw_box_lly-[P_fmod $psw_box_lly $pitch]+0.1}]]
                set stop $psw_box_ury
                for {set i $start} {$i <= $stop} {set i [format "%.3f" [expr {$i+$pitch*$track_skip($layer)}]]} {
                    lappend stripe_box_list [list [expr $psw_box_llx+0.2] [expr {$i-$width/2}] [expr $psw_box_urx-0.2] [expr {$i+$width/2}]]
                }
            } elseif {$direction eq "Vertical"} {
                set pitch [dbget [dbget head.layers.name $layer -p].pitchX]
                set start [format "%.3f" [expr {$psw_box_llx -[P_fmod $psw_box_llx $pitch]+0.7}]]
                set stop [format "%.3f" [expr {$psw_box_urx -0.7}]]
                for {set i $start} {$i <= $stop} {set i [format "%.3f" [expr {$i+$pitch*$track_skip($layer)}]]} {
                    lappend stripe_box_list [list [expr {$i-$width/2}] [expr {$psw_box_lly-0.1}] [expr {$i+$width/2}] [expr {$psw_box_ury+0.1}]]
                }
            }
            set index 0
            set layer_id [string trim $layer M]
            foreach box $stripe_box_list {
                if {[P_fmod $index 2] == 0} {
                    set cmd "dbCreateWire $sw_net $box $layer_id $direction_id STRIPE"
                    eval $cmd
                    #dbCreateWire $sw_net $box 3 1 STRIPE
                } else {
                    set cmd "dbCreateWire $aon_net $box $layer_id $direction_id STRIPE"
                    eval $cmd
                }
                incr index
            }
        }
        editPowerVia -add_vias 1 -bottom_layer M2 -top_layer M3 -area [lindex $psw_box 0]
        editPowerVia -add_vias 1 -bottom_layer M3 -top_layer M4 -area [lindex $psw_box 0]
        # create M5 stripes for connect to closest M6
        set closest_m6_aon [P_get_closest_stripe -layer M6 -loc [list $psw_box_llx $psw_box_lly] -net $aon_net]
        set closest_m6_sw [P_get_closest_stripe -layer M6 -loc [list $psw_box_llx $psw_box_lly] -net $sw_net]
        set box_m6_aon [dbget $closest_m6_aon.box]
        set box_m6_sw [dbget $closest_m6_sw.box]
        scan [lindex $box_m6_aon 0] {%f %f %f %f} m6_aon_llx m6_aon_lly m6_aon_urx m6_aon_ury
        scan [lindex $box_m6_sw 0] {%f %f %f %f} m6_sw_llx m6_sw_lly m6_sw_urx m6_sw_ury
        if {$m6_aon_lly < $psw_box_lly} {
            set aon_lly $m6_aon_lly
            set aon_ury $psw_box_ury
        } elseif {$m6_aon_ury > $psw_box_ury} {
            set aon_lly $psw_box_lly
            set aon_ury $m6_aon_ury
        } else {
            set aon_lly $psw_box_lly
            set aon_ury $psw_box_ury
        }
        if {$m6_sw_lly < $psw_box_lly} {
            set sw_lly $m6_sw_lly
            set sw_ury $psw_box_ury
        } elseif {$m6_sw_ury > $psw_box_ury} {
            set sw_lly $psw_box_lly
            set sw_ury $m6_sw_ury
        } else {
            set sw_lly $psw_box_lly
            set sw_ury $psw_box_ury
        }
        set index 0
        set width 0.25
        set layer M5
        set pitch [dbget [dbget head.layers.name $layer -p].pitchX]
        set start [format "%.3f" [expr {$psw_box_llx -[P_fmod $psw_box_llx $pitch]+0.7}]]
        set stop [format "%.3f" [expr {$psw_box_urx -0.7}]]
        for {set i $start} {$i <= $stop} {set i [format "%.3f" [expr {$i+$pitch*$track_skip($layer)}]]} {
            if {[P_fmod $index 2]==0} {
                set sw_box [list [expr $i-$width/2] $sw_lly [expr $i+$width/2] $sw_ury]
                dbCreateWire $sw_net {*}$sw_box 5 1 STRIPE
                editPowerVia -add_vias 1 -bottom_layer M4 -top_layer M6 -area $sw_box
            } else {
                set aon_box [list [expr $i-$width/2] $aon_lly [expr $i+$width/2] $aon_ury]
                dbCreateWire $aon_net {*}$aon_box 5 1 STRIPE
                editPowerVia -add_vias 1 -bottom_layer M4 -top_layer M6 -area $aon_box
            }
            incr index
        }
    }
}
define_proc_arguments P_add_psw_power_stripe -info "add power stripes for powerswitch" \
    -define_args {
        {-power_domain "power domain name" power_domain string required}
        {-type "power switch type, core or channel" type string one_of_string {required value_help {values {core channel}}}}

        #"arg_name"  "option_help"  "value_help"  "data_type" "attributes"
        #data_type:string, list, boolean, int, integer, float, or one_of_string
        #attributes|required|optional|internal|value_help|values {allowable_values} | merge_duplicates
    }
proc P_check_overlap {args} {
    parse_proc_arguments -args $args results
    set overlap [dbQuery -objType $results(-type) -area $results(-area)]
    if {$overlap == ""} {
        return 0
    } else {
        if {[info exists results(-layer)]} {
            set overlap [dbget -e $overlap.layer.name $results(-layer) -p2]
        }
        if {$overlap != ""} {
            return 1
        } else {
            return 0
        }
    }
}
define_proc_arguments P_check_overlap -info "Check if specified layer exists in specified area" \
    -define_args {
        {-layer "layer name" layer string optional}
        {-area "search area" area list required}
        {-type "wire type, such as sWire or wire" type string required}
    }

proc P_get_closest_stripe {args} {
    parse_proc_arguments -args $args results
    global pppr
    set layer $results(-layer)
    set width $pppr(width,$layer)
    set net_name $results(-net)
    set loc $results(-location)
    lassign $loc llx lly
    set direction [dbget [dbget head.layers.name $layer -p].direction]
    set min_distance ""
    set closest_stripe ""
    if {$direction eq "Horizontal"} {
        set attribute box_sizey
    } elseif {$direction eq "Vertical"} {
        set attribute box_sizex
    }
    set stripes [dbget [dbget [dbget top.physNets.name $net_name -p].sWires.layer.name $layer -p2].$attribute $width -p]
    foreach stripe $stripes {
        set box [dbget $stripe.box]
        scan [lindex $box 0] {%f %f %f %f} stripe_llx stripe_lly stripe_urx stripe_ury
        if {$direction eq "Horizontal"} {
            set distance [expr {abs($stripe_lly-$lly)}]
        } elseif {$direction eq "Vertical"} {
            set distance [expr {abs($stripe_llx-$llx)}]
        }

        if {$min_distance == ""} {
            set min_distance $distance
            set closest_stripe $stripe
        } else {
            if {$distance < $min_distance} {
                set min_distance $distance
                set closest_stripe $stripe
            }
        }
    }
    return $closest_stripe
}
define_proc_arguments P_get_closest_stripe -info "get closest stripe of a location" \
    -define_args {
        {-layer "layer name" layer string required}
        {-net "net name" net_name string required}
        {-location "location" point list required}
    }
proc P_connect_psw_chain {args} {
    parse_proc_arguments -args $args results

    foreach pd [dbget top.pds.isAlwaysOn 0 -p] {
        set pd_name [dbget $pd.name]
        set psws [addPowerSwitch -getSwitchInstances  -powerDomain $pd_name]
        rechainPowerSwitch \
            -unchainByInstances \
            -switchInstances $psws \
            -enablePinIn SLEEP \
            -enablePinOut SLEEPOUT
        rechainPowerSwitch \
            -powerDomain $pd_name \
            -enablePinIn EN \
            -enablePinOut ENX \
            -enableNetIn psw_en_codec \
            -enableNetOut psw_en_codec_ack \
            -switchInstances $psws \
            -backToBackChain \
            -chainByInstances  \
            -chainDirectionX RtoL \
            -chainDirectionY TtoB  \
            -mergeDistanceX 26 
    }
}

