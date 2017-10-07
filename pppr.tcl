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
P_add_pg_stripe -type global
P_add_pg_stripe -type local
P_add_pg_stripe -type rail
P_add_pg_stripe -type channel

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

P_insert_fp_cells
foreach pd [dbget top.pds.isAlwaysOn 0 -p] {
    set pd_name [dbget $pd.name]
    P_add_psw_power_stripe -type core -power_domain $pd_name
    P_add_psw_power_stripe -type channel -power_domain $pd_name
}

#P_add_mem_power_stripe
#P_insert_eco_array
#P_connect_psw_chain
