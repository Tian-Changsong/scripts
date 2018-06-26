source ~/project/bt1300/usr/tony/pr_arm/run_2/scripts/pppr_procs.tcl
source ~/project/bt1300/usr/tony/pr_arm/run_2/scripts/pppr_setup.tcl
set filler_eco_cells "$pppr(cell,eco_comb) $pppr(cell,eco_dff) FILLCAP128_A7PP140ZTS_C35 FILLCAP128_A7PP140ZTH_C35 FILLCAP128_A7PP140ZTH_C40 FILLCAP64_A7PP140ZTS_C35 FILLCAP64_A7PP140ZTH_C35 FILLCAP64_A7PP140ZTH_C40 FILLCAP32_A7PP140ZTS_C35 FILLCAP32_A7PP140ZTH_C35 FILLCAP32_A7PP140ZTH_C40 FILLCAP16_A7PP140ZTS_C35 FILLCAP16_A7PP140ZTH_C35 FILLCAP16_A7PP140ZTH_C40 FILLCAP8_A7PP140ZTS_C35 FILLCAP8_A7PP140ZTH_C35 FILLCAP8_A7PP140ZTH_C40 FILLCAP4_A7PP140ZTS_C35 FILLCAP4_A7PP140ZTH_C35 FILLCAP4_A7PP140ZTH_C40 FILLCAP2_A7PP140ZTS_C35 FILLCAP2_A7PP140ZTH_C35 FILLCAP2_A7PP140ZTH_C40 FILL128_A7PP140ZTS_C35 FILL128_A7PP140ZTH_C35 FILL128_A7PP140ZTH_C40 FILL64_A7PP140ZTS_C35 FILL64_A7PP140ZTH_C35 FILL64_A7PP140ZTH_C40 FILL32_A7PP140ZTS_C35 FILL32_A7PP140ZTH_C35 FILL32_A7PP140ZTH_C40 FILL16_A7PP140ZTS_C35 FILL16_A7PP140ZTH_C35 FILL16_A7PP140ZTH_C40 FILL8_A7PP140ZTS_C35 FILL8_A7PP140ZTH_C35 FILL8_A7PP140ZTH_C40 FILL4_A7PP140ZTS_C35 FILL4_A7PP140ZTH_C35 FILL4_A7PP140ZTH_C40  FILL3_A7PP140ZTS_C35 FILL3_A7PP140ZTH_C35 FILL3_A7PP140ZTH_C40  FILL2_A7PP140ZTS_C35 FILL2_A7PP140ZTH_C35 FILL2_A7PP140ZTH_C40"
set filler_cells "FILLCAP128_A7PP140ZTS_C35 FILLCAP128_A7PP140ZTH_C35 FILLCAP128_A7PP140ZTH_C40 FILLCAP64_A7PP140ZTS_C35 FILLCAP64_A7PP140ZTH_C35 FILLCAP64_A7PP140ZTH_C40 FILLCAP32_A7PP140ZTS_C35 FILLCAP32_A7PP140ZTH_C35 FILLCAP32_A7PP140ZTH_C40 FILLCAP16_A7PP140ZTS_C35 FILLCAP16_A7PP140ZTH_C35 FILLCAP16_A7PP140ZTH_C40 FILLCAP8_A7PP140ZTS_C35 FILLCAP8_A7PP140ZTH_C35 FILLCAP8_A7PP140ZTH_C40 FILLCAP4_A7PP140ZTS_C35 FILLCAP4_A7PP140ZTH_C35 FILLCAP4_A7PP140ZTH_C40 FILLCAP2_A7PP140ZTS_C35 FILLCAP2_A7PP140ZTH_C35 FILLCAP2_A7PP140ZTH_C40 FILL128_A7PP140ZTS_C35 FILL128_A7PP140ZTH_C35 FILL128_A7PP140ZTH_C40 FILL64_A7PP140ZTS_C35 FILL64_A7PP140ZTH_C35 FILL64_A7PP140ZTH_C40 FILL32_A7PP140ZTS_C35 FILL32_A7PP140ZTH_C35 FILL32_A7PP140ZTH_C40 FILL16_A7PP140ZTS_C35 FILL16_A7PP140ZTH_C35 FILL16_A7PP140ZTH_C40 FILL8_A7PP140ZTS_C35 FILL8_A7PP140ZTH_C35 FILL8_A7PP140ZTH_C40 FILL4_A7PP140ZTS_C35 FILL4_A7PP140ZTH_C35 FILL4_A7PP140ZTH_C40  FILL3_A7PP140ZTS_C35 FILL3_A7PP140ZTH_C35 FILL3_A7PP140ZTH_C40  FILL2_A7PP140ZTS_C35 FILL2_A7PP140ZTH_C35 FILL2_A7PP140ZTH_C40"

setFillerMode -reset
setFillerMode -doDRC false -fitGap true -corePrefix signoff_FILLER_ \
    -core $filler_eco_cells
deleteFiller -keepFixed

set blockage_list "
{2272.918 1430.496 2814.456 1369.143}
{-3.139 557.138 208.877 532.301}
{1481.771 787.039 2361.018 723.569}
{1347.115 24.525 2340.147 -4.469}
{2324.829 178.440 2628.951 163.784}
{1.390 19.767 1289.640 -5.608}
{1548.764 1859.795 2840.499 1833.812}
{-10.216 1796.184 1586.035 1758.801}
{-8.499 1390.001 394.018 1361.144}
{1526.435 1877.019 2887.002 1821.258}
"
set blockage_list_dff "
{1534.440 1884.768 2845.865 1808.548}
{-17.739 1797.563 397.005 1365.225}
{2231.928 1855.376 2905.572 1400.415}
"
foreach box $blockage_list {
    createPlaceBlockage -type hard -box $box -name filler_tmp
}
foreach box $blockage_list_dff {
    createPlaceBlockage -type hard -box $box -name filler_tmp_dff
}

foreach pd [dbGet top.pds.name] {
    foreach box [P_get_channel_area -power_domain $pd -width 60] {
        createPlaceBlockage -type hard -box $box -name filler_tmp
    }
    
    setFillerMode -reset
    setFillerMode -doDRC false -fitGap true -corePrefix signoff_FILLER_$pd \
        -core  $filler_eco_cells
    addFiller -powerDomain $pd 
    
}
set comb_limit 98692
set eco_comb [dbGet [dbGet top.insts.name *signoff_FILLER_* -p].cell.name $pppr(cell,eco_comb) -p2]
set delete_num [expr [llength $eco_comb] - $comb_limit]
puts "INFO: $delete_num comb cells to delete"
set index_already_has ""
set deleteInsts ""
for {set i 0} {$i < $delete_num} {incr i} {
    set rand_index [expr round(floor(rand()*[llength $eco_comb]))]
    while {$rand_index in $index_already_has} {
        set rand_index [expr round(floor(rand()*[llength $eco_comb]))]
    }
    lappend index_already_has $rand_index
}
set eco_comb_name [dbGet $eco_comb.name]
foreach var $index_already_has {
    deleteInst [lindex $eco_comb_name $var]
}
set dff_limit [expr $comb_limit/15]
set eco_dff [dbGet [dbGet top.insts.name *signoff_FILLER_* -p].cell.name $pppr(cell,eco_dff) -p2]
set delete_num [expr [llength $eco_dff] - $dff_limit]
puts "INFO: $delete_num dff cells to delete"
set index_already_has ""
for {set i 0} {$i < $delete_num} {incr i} {
    set rand_index [expr round(floor(rand()*[llength $eco_dff]))]
    while {$rand_index in $index_already_has} {
        set rand_index [expr round(floor(rand()*[llength $eco_dff]))]
    }
    lappend index_already_has $rand_index
}
set eco_dff_name [dbGet $eco_dff.name]
foreach var $index_already_has {
    deleteInst [lindex $eco_dff_name $var]
}


deletePlaceBlockage filler_tmp
deletePlaceBlockage filler_tmp_dff
foreach pd [dbGet top.pds.name] {
    setFillerMode -doDRC false -fitGap true -corePrefix signoff_FILLER_$pd \
        -core $filler_cells 
    addFiller -powerDomain $pd
}
set eco_comb_all [dbGet top.insts.cell.name $pppr(cell,eco_comb) -p2]
set eco_dff_all [dbGet top.insts.cell.name $pppr(cell,eco_comb) -p2]

