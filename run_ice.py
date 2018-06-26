#!/usr/bin/env python
# -*- coding: utf-8 -*-
import commands, os, glob
def genCSH(runDir="."):
    cmd=open(runDir+"/run.sh","w")
    cmd.write("#! /bin/bash -f\n")
    cmd.write("module load icexplorer\n")
    cmd.write("icexplorer -nowin -f ice.tcl\n")
    cmd.close()
    os.system("chmod 755 %s/run.sh" % runDir)
os.system("mkdir -p ./ICE")
os.chdir("./ICE")
voltMode = [
        "nd",
        "od",
        "ud",
        ]
tempCorner = [
        "125c",
        "m40c",
        ]
rcCorner = [
        "cbest",
        "cworst",
        "cworstT",
        "rcbest",
        "rctypical",
        "rcworst",
        "rcworstT",
        ]
libCorner = [
        "wc",
        "wcl",
        "lt",
        "ml",
        ]
timingType = [
        "setup",
        "hold",
        ]
analyzeMode = [
        "func",
        "scan",
        ]
config = {
        'type' 			: ["hold"],# hold | setup | leakage | transition
        'effort' 		: 'medium',
        'netlist' 		: '/home/tony/project/bt1300/usr/tony/pr_arm/run_2/output/bt1300_core.0116.new.v.gz',
        'def' 			: '/home/tony/project/bt1300/usr/tony/pr_arm/run_2/output/bt1300_core.0116.nofiller.def.gz',
        'STA_dir' 		: '/home/tony/project/bt1300/usr/tony/pr_arm/run_2/STA',
        'dont_use' 		: "fromConfig",
        'dont_touch' 	: "/home/tony/project/bt1300/usr/tony/pr_arm/run_2/output/dont_touch_list",
        'skip_io'		: "false",
        'thread_num'	: 8,
        'setup'			: "/home/tony/project/bt1300/usr/tony/pr_arm/run_2/scripts/setup.tcl",
        'pd'            : '/home/tony/project/bt1300/usr/tony/pr_arm/run_2/output/bt1300_core.pd',
        }
config["ice_data"]=config["STA_dir"]+"/ice_output"
libSet = {
        "nd_wcl" : '$vars(nd_wcl,lib)',
        "nd_wc"  : '$vars(nd_wc,lib)',
        "nd_ml"  : '$vars(nd_ml,lib)',
        "nd_lt"  : '$vars(nd_lt,lib)',
        "od_wcl" : '$vars(od_wcl,lib)',
        "od_wc"  : '$vars(od_wc,lib)',
        "od_ml"  : '$vars(od_ml,lib)',
        "od_lt"  : '$vars(od_lt,lib)',
        "ud_wcl" : '$vars(ud_wcl,lib)',
        "ud_wc"  : '$vars(ud_wc,lib)',
        "ud_ml"  : '$vars(ud_ml,lib)',
        "ud_lt"  : '$vars(ud_lt,lib)',
        }
delayCells = [
'BUFH_X1M_A7PP140ZTH_C35',
'BUFH_X1M_A7PP140ZTH_C40',
'BUFH_X1P2M_A7PP140ZTH_C40',
'BUFH_X1P4M_A7PP140ZTH_C40',
'BUFH_X1P7M_A7PP140ZTH_C35',
'BUFH_X1P7M_A7PP140ZTH_C40',
'BUFH_X2M_A7PP140ZTH_C35',
'BUFH_X2M_A7PP140ZTH_C40',
'BUFH_X2P5M_A7PP140ZTH_C40',
'BUFH_X3M_A7PP140ZTH_C35',
'BUFH_X3M_A7PP140ZTH_C40',
'BUFH_X3P5M_A7PP140ZTH_C35',
'BUFH_X3P5M_A7PP140ZTH_C40',
'DLY2_X1M_A7PP140ZTH_C35',
'DLY2_X1M_A7PP140ZTH_C40',
'DLY2_X2M_A7PP140ZTH_C35',
'DLY2_X2M_A7PP140ZTH_C40',
'DLY2_X4M_A7PP140ZTH_C40',
'DLY4_X1M_A7PP140ZTH_C35',
'DLY4_X1M_A7PP140ZTH_C40',
'DLY4_X2M_A7PP140ZTH_C35',
'DLY4_X2M_A7PP140ZTH_C40',
'DLY4_X4M_A7PP140ZTH_C35',
'DLY4_X4M_A7PP140ZTH_C40',
'DLY8_X1M_A7PP140ZTH_C35',
'DLY8_X1M_A7PP140ZTH_C40',
'DLY8_X2M_A7PP140ZTH_C35',
'DLY8_X2M_A7PP140ZTH_C40',
'DLY8_X4M_A7PP140ZTH_C35',
'DLY8_X4M_A7PP140ZTH_C40',
]

bufferCells = [
'BUFH_X4M_A7PP140ZTH_C35',
'BUFH_X4M_A7PP140ZTH_C40',
'BUFH_X6M_A7PP140ZTH_C35',
'BUFH_X6M_A7PP140ZTH_C40',
'BUFH_X7P5M_A7PP140ZTH_C35',
'BUFH_X7P5M_A7PP140ZTH_C40',
'BUFH_X9M_A7PP140ZTH_C35',
'BUFH_X9M_A7PP140ZTH_C40',
]
# 'BUFH_X4M_A7PP140ZTS_C35',
# 'BUFH_X6M_A7PP140ZTS_C35',
# 'BUFH_X7P5M_A7PP140ZTS_C35',
# 'BUFH_X9M_A7PP140ZTS_C35',


# leakage_swapVTList = "ZTH_C35 ZTH_C40 ZTS_C35"
# leakage_swapVTList = "ZTH_C35 ZTH_C40"
leakage_swapVTList = "ZTS_C35 ZTH_C35 ZTH_C40"
setup_swapVTList = "ZTS_C35 ZTH_C35 ZTH_C40"
ignore_scenarios = []

dlyList = " ".join(delayCells)
bufList = " ".join(bufferCells)
date = commands.getoutput("date +%m_%d_%H_%M")
user = commands.getoutput("whoami")
mainDir = commands.getoutput("pwd")
prefix = "_".join(["ice" , "_".join(config["type"]) , date , user])
runDir = mainDir + "/" + prefix + "_timing_fix"
os.system("mkdir -p "+runDir)
os.system("rm -rf timing_fix")
os.system("ln -s " + runDir + " timing_fix")
genCSH(runDir)

## generate ice_setup.tcl -----------------------------------------------------------------------------------------
ice=open(runDir+"/ice.tcl","w")
mmmc=open(runDir+"/mmmc.tcl","w")
ice.write("source /home/tony/project/bt1300/usr/tony/pr_arm/run_2/scripts/setup.tcl\n")
ice.write("ice_set_parameter opt.legalization_align_fixed_track_color true\n")
ice.write("ice_set_parameter lef_files $vars(lef_files)\n")
ice.write("ice_set_parameter verilog_files " + config["netlist"] + "\n")
ice.write("ice_set_parameter def_files "+ config["def"] + "\n")
if "pd" in config:
    ice.write("ice_set_parameter power_domain_files " + config["pd"] + "\n")
ice.write("ice_design_setup\n")
# if config["dont_use"] == "fromConfig":
    # ice.write("""
# set ice(dont_use_list) [list]
# foreach item $vars(dont_use_list) {
    # regsub -all {\\*+[\/]} \$item {} new
    # lappend ice(dont_use_list) \$new
    # $ice{dont_use} = '$ice(dont_use_list)'
# }
# """
# )

for fs in analyzeMode:
    mmmc.write("ice_create_mode %s\n" % fs)

for volt in voltMode:
    for lib in libCorner:
        cc="%s_%s" % (volt,lib)
        mmmc.write("ice_create_corner %s -max_libs %s\n" % (cc,libSet[cc]))

corners=[
"func_nd_lt_rcworst_m40c_hold",
"func_nd_lt_cworst_m40c_hold",
"func_nd_lt_rcbest_m40c_hold",
"func_nd_lt_cbest_m40c_hold",
"func_nd_ml_rcworst_125c_hold",
"func_nd_ml_cworst_125c_hold",
"func_nd_ml_rcbest_125c_hold",
"func_nd_ml_cbest_125c_hold",
"func_nd_wcl_rcworst_m40c_hold",
"func_nd_wcl_cworst_m40c_hold",
"func_nd_wc_rcworst_125c_hold",
"func_nd_wc_cworst_125c_hold",
"func_nd_wcl_rcworstT_m40c_setup",
"func_nd_wcl_cworstT_m40c_setup",
"func_nd_wc_rcworstT_125c_setup",
"func_nd_wc_cworstT_125c_setup",
"func_od_lt_rcworst_m40c_hold",
"func_od_lt_cworst_m40c_hold",
"func_od_lt_rcbest_m40c_hold",
"func_od_lt_cbest_m40c_hold",
"func_od_ml_rcworst_125c_hold",
"func_od_ml_cworst_125c_hold",
"func_od_ml_rcbest_125c_hold",
"func_od_ml_cbest_125c_hold",
"func_od_wcl_rcworst_m40c_hold",
"func_od_wcl_cworst_m40c_hold",
"func_od_wc_rcworst_125c_hold",
"func_od_wc_cworst_125c_hold",
"func_od_wcl_rcworstT_m40c_setup",
"func_od_wcl_cworstT_m40c_setup",
"func_ud_ml_rcworst_125c_hold",
"func_ud_lt_cbest_m40c_hold",
"scan_nd_lt_rcworst_m40c_hold",
"scan_nd_lt_cworst_m40c_hold",
"scan_nd_lt_rcbest_m40c_hold",
"scan_nd_lt_cbest_m40c_hold",
"scan_nd_ml_rcworst_125c_hold",
"scan_nd_ml_cworst_125c_hold",
"scan_nd_ml_rcbest_125c_hold",
"scan_nd_ml_cbest_125c_hold",
"scan_nd_wcl_rcworst_m40c_hold",
"scan_nd_wcl_cworst_m40c_hold",
"scan_nd_wc_rcworst_125c_hold",
"scan_nd_wc_cworst_125c_hold",
]
# ignore missing corners 
for corner in corners:
    if glob.glob(config["STA_dir"]+"/"+corner+"/timing_reports/*wo_io.rpt") == []:
        ignore_scenarios.append(corner)
ice.write("set skip_setup_timing [list]\n")
ice.write("set skip_hold_timing [list]\n")
for fs in analyzeMode:
    for volt in voltMode:
        for lib in libCorner:
            for rc in rcCorner:
                for temp in tempCorner:
                    for type in timingType:
                        scenario="_".join([fs,volt,lib,rc,temp,type])
                        if scenario not in corners or scenario in ignore_scenarios:
                            continue
                        mmmc.write("ice_create_scenario %s -mode %s -corner %s_%s\n" % (scenario,fs,volt,lib))
                        if type == "hold":
                            ice.write("lappend skip_setup_timing %s\n" % scenario)
                        if type == "setup":
                            ice.write("lappend skip_hold_timing %s\n" % scenario)
                        # config["thread_num"]+=2
ice.write("source ./mmmc.tcl\n")
ice.write("ice_check_readiness\n")
ice.write("ice_set_parameter opt.fix_timing_effort %s\n" % config["effort"])
ice.write("ice_set_parameter opt.max_thread_number %s\n" % config["thread_num"])
ice.write("ice_set_parameter opt.legalization_min_spacing 2\n")
ice.write("ice_set_parameter opt.dont_touch_objects_file \"%s\"\n" % config["dont_touch"])
# ice.write("ice_set_parameter opt.dont_use_cell_masters \"%s\"\n" % config["dont_use"])
ice.write("ice_set_parameter opt.skip_setup_timing_for_scenarios $skip_setup_timing\n")
ice.write("ice_set_parameter opt.skip_hold_timing_for_scenarios  $skip_hold_timing\n")
ice.write("ice_set_parameter opt.new_object_prefix %s\n" % prefix)
ice.write("ice_set_parameter opt.skip_io_paths %s\n" % config["skip_io"])

#ice_set_parameter power_domain_files { {cpu cpu.pd} {regs regs.pd} }
ice.write("ice_set_parameter opt.pba_mode both\n")
if "setup" in config["type"]:
        ice.write("# for setup\n")
        #print ICE "ice_set_parameter opt.fix_timing_effort undefined","\n";
        ice.write("ice_set_parameter opt.legalization_margin 1.5\n")
        ice.write("ice_set_parameter opt.new_inst_legalization_margin 15\n")
        # ice.write("ice_fix_setup_timing -data_dir %s -methods \"gate_sizing\" -swap_cell_keywords \"%s\"\n" % (config["ice_data"],leakage_swapVTList))
        ice.write("ice_fix_setup_timing -buffer_list \"%s\" -data_dir %s  -swap_cell_keywords \"%s\"\n" % (bufList,config["ice_data"],setup_swapVTList))
if "hold" in config["type"]:
        ice.write("# for hold\n")
        ice.write("ice_opt_hold -buffer_list \"%s\" -data_dir %s -swap_cell_keywords \"%s\"\n" % (dlyList, config["ice_data"],setup_swapVTList))
if "leakage" in config["type"]:
        ice.write("# for leakage\n")
        ice.write("ice_opt_leakage_power -data_dir %s -swap_cell_keywords \"%s\"\n" % (config["ice_data"],leakage_swapVTList))
if "transition" in config["type"]:
        ice.write("# for transition\n")
        ice.write("ice_opt_transition -buffer_list \"%s\" -data_dir %s -swap_cell_keywords  \"%s\"\n" % (bufList,config["ice_data"],setup_swapVTList))

ice.write("ice_write_design_changes -format SOC -netlist_eco_file result/eco_netlist -phys_eco_file result/eco_phys\n")
ice.write("ice_write_design_changes -format PT -netlist_eco_file result/eco_netlist_pt\n")
# ice.write("exit\n")
ice.close()
mmmc.close()



####################################
## ice fix_timing
####################################
os.chdir(runDir)
if os.path.exists("./run.sh"):
    os.system("./run.sh")
else:
    print("***Error: Please check if the file run.sh exists or not!\n")
