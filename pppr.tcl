set current_dir [file dirname [info script]]
source $current_dir/pppr_procs.tcl
source -verbose $current_dir/pppr_setup.tcl
P_generage_tracks
#placePowerDomain
P_regenerate_row
foreach power_domain [dbget top.pds.name] {
    modifyPowerDomainAttr $power_domain -minGaps 3
}
P_add_halo
P_global_net_connect
P_add_pg_ring
P_insert_boundary_cells
foreach c [dbGet -p2 top.insts.cell.name *DMY_TCD* ]  {
    createRouteBlk  -name TcdRtBlk -box "[expr [dbGet $c.box_llx] - 2] [expr [dbGet $c.box_lly] - 2] [expr [dbGet $c.box_urx] + 2 ]  [expr [dbGet $c.box_ury] + 2] "  -layer {M1 M2 M3 M4 M5 M6} -exceptpgnet   ;# first allow PG routing, then can be deleted if needed.
    dbSet $c.pStatus fixed 
}
foreach c [dbGet -p2 top.insts.cell.name *BEOL_small_FDM* ]  {
    createRouteBlk  -name TcdRtBlk -box "[expr [dbGet $c.box_llx] - 2] [expr [dbGet $c.box_lly] - 2] [expr [dbGet $c.box_urx] + 2 ]  [expr [dbGet $c.box_ury] + 2] "  -layer {M1 M2 M3 M4 M5 M6} -exceptpgnet   ;# first allow PG routing, then can be deleted if needed.
    dbSet $c.pStatus fixed 
}
P_add_pg_stripe -type global
P_add_pg_stripe -type local
P_add_pg_stripe -type rail
P_add_pg_stripe -type channel
catch {deletePowerSwitch}
foreach pd [dbget top.pds.isAlwaysOn 0 -p] {
    set pd_name [dbget $pd.name]
    P_insert_power_switch -type core \
        -power_domain $pd_name \
        -skip_row $pppr(psw,skip_row_core) \
        -horizontal_pitch $pppr(psw,horizontal_pitch_core)
    P_insert_power_switch -type channel \
        -power_domain $pd_name \
        -skip_row $pppr(psw,skip_row_channel) \
        -horizontal_pitch $pppr(psw,horizontal_pitch_channel)
}
# avoid tapcell in channel
foreach pd [dbget top.pds] {
    set pd_name [dbget $pd.name]
    set channel_boxes [P_get_channel_area -power_domain $pd_name -width $pppr(psw,channel_threshold)]
    foreach box $channel_boxes {
        createPlaceBlockage -box $box -type hard -name tapcell_blk
    }
}

P_insert_fp_cells
deletePlaceBlockage tapcell_blk

P_insert_eco_array -pitch 50
foreach pd [dbget top.pds.isAlwaysOn 0 -p] {
    set pd_name [dbget $pd.name]
    P_add_psw_power_stripe -type core -power_domain $pd_name
    P_add_psw_power_stripe -type channel -power_domain $pd_name
}

P_connect_psw_chain
P_add_macro_stripe
source ~/project/bt1300/usr/tony/pr_arm/run_2/scripts/fix_endcap.tcl
