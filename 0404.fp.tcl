setMultiCpuUsage -localCpu 16
#set init_assign_buffer "1 -buffer BUF_X4M_A9TR40"
#source DBS/fp3_tmp1.enc.dat/bt1000_core.globals
#init_design
#loadFPlan  DBS/fp3_tmp1.enc.dat/bt1000_core.fp.gz
#
#source hhh_scripts/blk.tcl

#createPlaceBlockage -box "423.51 992.88 432.82 994.14" -name defScreenName  -type hard -noCutByCore
#createPlaceBlockage -box "1005.48 992.88 1014.03 994.14" -name defScreenName  -type hard -noCutByCore
#createPlaceBlockage -box "855.19 992.88 864.88 994.14" -name defScreenName  -type hard -noCutByCore

#saveDesign DBS/fp6_tmp1.enc 

#####
#deletePlaceBlockage -all
#deleteRouteBlk -all
set ver 0405
######gk modify######
#modifyPowerDomainAttr PD_CODEC -gapEdges {5 }
#modifyPowerDomainAttr PD_MCU -gapEdges {5 5 }
#modifyPowerDomainAttr PD_WLAN -gapEdges {5 5 }
#modifyPowerDomainAttr PD_BT -gapEdges {5 5 }
deleteRow -all
createRow -site TS45_DST
modifyPowerDomainAttr PD_CODEC -gapEdges {3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78}
modifyPowerDomainAttr PD_MCU -gapEdges {3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78   }
modifyPowerDomainAttr PD_WLAN -gapEdges {3.78 3.78 3.78 3.78 3.78 3.78 3.78 3.78 }
modifyPowerDomainAttr PD_BT -gapEdges {3.78 3.78 3.78 3.78 3.78 3.78 }
#modifyPowerDomainAttr PD_CODEC -gapEdges {0 0 0 0 0 0}
#modifyPowerDomainAttr PD_MCU -gapEdges {0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0  }
#modifyPowerDomainAttr PD_WLAN -gapEdges {0 0 0 0 0 0 0 0 }
#modifyPowerDomainAttr PD_BT -gapEdges {0 0 0 0 0 0 }

  set dieBoxes  [dbGet top.fplan.boxes]
  set coreBoxes [dbShape $dieBoxes SIZE -0.5]
  set coreBoxes2 [dbShape $dieBoxes SIZE -0.7]  ;#placeblk must large than routeblk, otherwise endcap can't be added in left/right
  set ringBoxes [dbShape $dieBoxes ANDNOT $coreBoxes]
  set ringBoxes2 [dbShape $dieBoxes ANDNOT $coreBoxes2]
  foreach box $ringBoxes {
    #createRouteBlk      -name RtBlkRing -box $box -layer {M1 M2 M3 M4 M5 M6 VIA5} -exceptpgnet
    createRouteBlk      -name RtBlkRing -box $box -layer {M1 M2 M3 M4 M5 M6 VIA5} 
  }
  foreach box $ringBoxes2 {
    createPlaceBlockage -box $box -name PlBlkRing  -type hard
  }
#######
#globalNetConnect VSS -type pgpin -pin VSS -inst * -override -verbose
#globalNetConnect VSS -type pgpin -pin VSSE -inst * -override -verbose
#globalNetConnect VDD -type pgpin -pin VDD -inst * -override -verbose
#globalNetConnect VDD -type pgpin -pin VDDPE -inst * -override -verbose
#globalNetConnect VDD -type pgpin -pin VDDCE -inst * -override -verbose
#globalNetConnect VDD -type pgpin -pin VDDE -inst * -override -verbose
globalNetConnect VNW -pin BIASCNW -all -type pgpin
globalNetConnect VNW -pin BIASNW  -all -type pgpin
globalNetConnect VPW -pin BIASPW  -all -type pgpin
globalNetConnect VSS -pin VSS     -all -type pgpin
globalNetConnect VNW -pin VBP     -all -type pgpin
globalNetConnect VPW -pin VBN     -all -type pgpin
globalNetConnect VDD -pin VDD  -type pgpin -powerDomain PD_ALLON
globalNetConnect VDD_SW_CODEC -pin VDD  -type pgpin -powerDomain PD_CODEC
globalNetConnect VDD_SW_MCU -pin VDD  -type pgpin -powerDomain PD_MCU
globalNetConnect VDD_SW_WLAN -pin VDD  -type pgpin -powerDomain PD_WLAN
globalNetConnect VDD_SW_BT -pin VDD  -type pgpin -powerDomain PD_BT
globalNetConnect VDD -pin VDDCE -type pgpin -powerDomain PD_ALLON -override
globalNetConnect VDD_SW_BT -pin VDDCE -type pgpin -powerDomain PD_BT -override
globalNetConnect VDD_SW_CODEC -pin VDDCE -type pgpin -powerDomain PD_CODEC -override
globalNetConnect VDD_SW_MCU -pin VDDCE -type pgpin -powerDomain PD_MCU -override
globalNetConnect VDD_SW_WLAN -pin VDDCE -type pgpin -powerDomain PD_WLAN -override
globalNetConnect VDD -pin VDDCE -type pgpin -powerDomain PD_ALLON -override
globalNetConnect VDD_SW_BT -pin VDDCE -type pgpin -powerDomain PD_BT -override
globalNetConnect VDD_SW_CODEC -pin VDDCE -type pgpin -powerDomain PD_CODEC -override
globalNetConnect VDD_SW_MCU -pin VDDCE -type pgpin -powerDomain PD_MCU -override
globalNetConnect VDD_SW_WLAN -pin VDDCE -type pgpin -powerDomain PD_WLAN -override
# for physical cells, only works with -hierInst
#globalNetConnect VDD_SW_CODEC -pin VBP  -type pgpin -hierInst u_codec_pd_top
#globalNetConnect VDD_SW_MCU -pin VBP  -type pgpin -hierInst u_mcu_top
#globalNetConnect VDD_SW_WLAN -pin VBP  -type pgpin -hierInst u_wlan_top
#globalNetConnect VDD_SW_BT -pin VBP  -type pgpin -hierInst u_bt_top
#globalNetConnect VDD -pin VBP  -type pgpin 
globalNetConnect VDD -pin VDDR  -type pgpin 

#######
setPlaceMode  -place_detail_legalization_inst_gap 2
dbSet top.terms.pStatus fixed
#addHaloToBlock 1 1 1 1 -allBlock
#addHaloToBlock 2.14 2.14 2.14 2.14 -cell DMY_TCD_H

if {1} {
 addInst -inst u_mcu_top/DMY_TCD_c1 -cell DMY_TCD_H -loc  1550.63 1043.305
 addInst -inst u_wlan_top/DMY_TCD_c2 -cell DMY_TCD_H -loc 2700.45 786.255
 #addInst -inst u_bt_top/DMY_TCD_c3 -cell DMY_TCD_H -loc 2533.97 2448.23
 addInst -inst u_bt_top/DMY_TCD_c3 -cell DMY_TCD_H -loc 2510.97 2448.23
 addInst -inst u_mcu_top/DMY_TCD_c4 -cell DMY_TCD_H -loc 1157.61 2525.0
 addHaloToBlock 2 2 2 2 -cell DMY_TCD_H
 foreach c [dbGet -p2 top.insts.cell.name DMY_TCD_H ]  {
   createRouteBlk  -name TcdRtBlk -box "[expr [dbGet $c.box_llx] - 2] [expr [dbGet $c.box_lly] - 2] [expr [dbGet $c.box_urx] + 2 ]  [expr [dbGet $c.box_ury] + 2] "  -layer {M1 M2 M3 M4 M5 M6} -exceptpgnet   ;# first allow PG routing, then can be deleted if needed.
   dbSet $c.pStatus fixed 
 }
}


#deleteRouteBlk -name RtBlkRing
#deletePlaceBlockage PlBlkRing

######gk modify######
#modifyPowerDomainAttr PD_CODEC -gapEdges {4.5 5 4.5 5}
#modifyPowerDomainAttr PD_MCU -gapEdges {4.5 5 4.5 5 4.5 5 }
#modifyPowerDomainAttr PD_WLAN -gapEdges {4.5 5 4.5 5 4.5 5 4.5 5 4.5 5}
#modifyPowerDomainAttr PD_BT -gapEdges {4.5 5 4.5 5 4.5 5 4.5 5}

setEndCapMode -leftEdge SEH_FILLNOPG4 -rightEdge SEH_FILLNOPG4 -topEdge PEH_TAPPN -bottomEdge PEH_TAPPN
addEndCap -prefix AO_ENDCAP
setEndCapMode -leftEdge SEH_FILLNOPG4 -rightEdge SEH_FILLNOPG4 -topEdge PEN_TAPPN -bottomEdge PEN_TAPPN
addEndCap -prefix PD_CODEC_ENDCAP -powerDomain PD_CODEC
addEndCap -prefix PD_MCU_ENDCAP -powerDomain PD_MCU
addEndCap -prefix PD_WLAN_ENDCAP -powerDomain PD_WLAN
addEndCap -prefix PD_BT_ENDCAP -powerDomain PD_BT

set n 0
foreach i [dbGet [dbGet -p top.insts.name *ENDCAP*].pt] {
        set x0 [lindex  $i 0]
        set y0 [lindex  $i 1]
        set x1 [expr $x0 + 0.7]   ;#endcap cell width
        set y1 [expr $y0 + 1.26]   ;#endcap cell height
        createPlaceBlockage -name ENDCAP_OBS_${n} -box "$x0 $y0 $x1 $y1"
        incr n
}

####### 48.02 is integer times of site 0.14
set DM PD_CODEC
addPowerSwitch -column  -globalSwitchCellName PEN_PGATBDRV_OW_6   \
               -skipRows 14   -noEnableChain -horizontalPitch 56 \
               -leftOffset 0.56  -bottomOffset 3 -incremental -instancePrefix PSO_${DM}_ \
               -powerDomain $DM -switchModuleInstance u_codec_pd_top

set channel_pso_list_$DM ""
#lappend channel_pso_list_$DM {8 {783.72 21.42 791.42 93.24 }}
#lappend channel_pso_list_$DM {8 {995.54 21.42 1002.82 93.24 }}
#lappend channel_pso_list_$DM {8 {1101.52 21.42 1109.5 93.24 }}
#lappend channel_pso_list_$DM {8 {1206.24 21.42 1215.9 93.24 }}
#lappend channel_pso_list_$DM {8 {1314.18 21.42 1324.82 715.68 }}
lappend channel_pso_list_$DM  {8 {1730.88 25.64  1738.9 244.88}} 
lappend channel_pso_list_$DM  {8 {1077.56 629.18 1086 726.2}} 
lappend channel_pso_list_$DM  {8 {936.1 629.18  942 726.2}}
lappend channel_pso_list_$DM  {8 {789.6 629.18 797 726.2}}
lappend channel_pso_list_$DM  {8 {691.66 436.4  697.9 726.2}}
#lappend channel_pso_list_$DM  {8 {1083 600 1089 700}}
#lappend channel_pso_list_$DM  {8 {915.5 600 921.5 700}}


foreach i $channel_pso_list_PD_CODEC {
 addPowerSwitch -column -powerDomain $DM -globalSwitchCellName PEN_PGATBDRV_OW_6  \
               -skipRows [lindex $i 0] -area [lindex $i 1] -ignoreSoftBlockage -noEnableChain -horizontalPitch 56 \
               -leftOffset 0 -incremental -instancePrefix PSO_CH_${DM}_ -switchModuleInstance u_codec_pd_top
}

set all_pso_list_$DM [addPowerSwitch -getSwitchInstances  -powerDomain $DM]

rechainPowerSwitch -unchainByInstances -switchInstances $all_pso_list_PD_CODEC \
		   -enablePinIn EN -enablePinOut ENX 

rechainPowerSwitch -powerDomain $DM -enablePinIn EN -enablePinOut ENX -enableNetIn psw_en_codec -enableNetOut psw_en_codec_ack \
	           -switchInstances $all_pso_list_PD_CODEC   -backToBackChain RtoL  -chainByInstances  -chainDirectionX RtoL -chainDirectionY TtoB  \
                   -mergeDistanceX 26 


#######
set DM PD_MCU
addPowerSwitch -column  -globalSwitchCellName PEN_PGATBDRV_OW_6   \
               -skipRows 14   -noEnableChain -horizontalPitch 56 \
               -leftOffset 0.56  -bottomOffset 3 -incremental -instancePrefix PSO_${DM}_ \
               -powerDomain $DM -switchModuleInstance u_mcu_top

set channel_pso_list_$DM ""
lappend channel_pso_list_$DM {8 {340.54 1698.92 347.6 1843.82}} 
lappend channel_pso_list_$DM {8 {407.6 1227.68 415.49 1696.4}} 
lappend channel_pso_list_$DM {8 {717.2 1060.1 625.11 1223.9}} 
lappend channel_pso_list_$DM {8 {867 1940.84 873 2409.56}} 
lappend channel_pso_list_$DM {8 {871.28 784.16  879 1027.34}} 
lappend channel_pso_list_$DM {8 {1081.14 784.16 1087 972.4}} 
lappend channel_pso_list_$DM {8 {1249.14 784.16 1257 972.4}} 
lappend channel_pso_list_$DM {8 {1529.14 2543.12  1536.4 3013.1}}


foreach i $channel_pso_list_PD_MCU {
 addPowerSwitch -column -powerDomain $DM -globalSwitchCellName PEN_PGATBDRV_OW_6  \
               -skipRows [lindex $i 0] -area [lindex $i 1] -ignoreSoftBlockage -noEnableChain -horizontalPitch 56 \
               -leftOffset 0 -incremental -instancePrefix PSO_CH_${DM}_ -switchModuleInstance u_mcu_top
}

set all_pso_list_$DM [addPowerSwitch -getSwitchInstances  -powerDomain $DM]

rechainPowerSwitch -unchainByInstances -switchInstances $all_pso_list_PD_MCU \
		   -enablePinIn EN -enablePinOut ENX 

rechainPowerSwitch -powerDomain $DM -enablePinIn EN -enablePinOut ENX -enableNetIn psw_en_mcu -enableNetOut psw_en_mcu_ack \
	           -switchInstances $all_pso_list_PD_MCU   -backToBackChain RtoL  -chainByInstances  -chainDirectionX RtoL -chainDirectionY TtoB  \
                   -mergeDistanceX 26 


#######
set DM PD_WLAN
addPowerSwitch -column  -globalSwitchCellName PEN_PGATBDRV_OW_6   \
               -skipRows 14   -noEnableChain -horizontalPitch 56 \
               -leftOffset 0.56  -bottomOffset 3 -incremental -instancePrefix PSO_${DM}_ \
               -powerDomain $DM -switchModuleInstance u_wlan_top

set channel_pso_list_$DM ""
#lappend channel_pso_list_$DM {8  {2743.58 327.6 2748.48 623.7}} 
#lappend channel_pso_list_$DM {8  {2810.36 327.6 2817.22 1088.64}} 
#lappend channel_pso_list_$DM {8  {2742.18 1088.64 2749.32 1272.6}} 
#lappend channel_pso_list_$DM {8  {2789.92 1092.42 2799.02 1291.5}} 
#lappend channel_pso_list_$DM {8  {2739.94 1450.26 2748.9 1756.44}} 
#lappend channel_pso_list_$DM {8  {2791.18 1591.38 2799.44 1756.44}} 
#lappend channel_pso_list_$DM {8  {2879.24 327.6 2884.56 1949.22}} 
#lappend channel_pso_list_$DM {8  {2773.26 1760.22 2780.54 1947.96}} 

lappend channel_pso_list_$DM  {8 {2860 326.78 2867 409.94}}
lappend channel_pso_list_$DM  {8 {2764.36 326.78  2772 404.9}}
lappend channel_pso_list_$DM  {8 {2676.58 326.78  2684 403.64}}
lappend channel_pso_list_$DM  {8 {2536.44 25.64 2544 185.66}}
lappend channel_pso_list_$DM  {8 {2481.0 25.64 2487.25 185.66}}
lappend channel_pso_list_$DM  {8 {2398.16 25.64 2405.01 185.66}}
lappend channel_pso_list_$DM  {8 {2309.92 25.64 2317 194.48}}
lappend channel_pso_list_$DM  {8 {2235.44 25.64 2243.44 194.48}}
lappend channel_pso_list_$DM  {8 {2162.92 25.64 2170 194.48}}
lappend channel_pso_list_$DM  {8 {2090.4 25.64 2098 194.48}}
lappend channel_pso_list_$DM  {8 {2018.58 25.64 2026.5 194.48}}
lappend channel_pso_list_$DM  {8 {1946.12 25.64 1951.91 208.34}}
lappend channel_pso_list_$DM  {8 {1863.88 25.64 1871 208.34}}
lappend channel_pso_list_$DM  {8 {1866.54  602.72  1872.93 684.62}}
#lappend channel_pso_list_$DM  {8 {1758.82 478.8 1765.4 786.24}}
#lappend channel_pso_list_$DM  {8 {1721.02 21.42 1729.56 787.5}}
#lappend channel_pso_list_$DM {8  {3079.58 2237.76 3084.34 2431.8}} 
#lappend channel_pso_list_$DM {8  {2883.72 2237.76 2891.28 2431.8}} 
#lappend channel_pso_list_$DM {8  {2687.02 2237.76 2695.0 2431.8}} 
#lappend channel_pso_list_$DM {8  {2004.94 2043.72 2012.08 2431.8}} 
#lappend channel_pso_list_$DM {8  {2200.38 2236.5 2207.66 2431.8}}



foreach i $channel_pso_list_PD_WLAN {
 addPowerSwitch -column -powerDomain $DM -globalSwitchCellName PEN_PGATBDRV_OW_6  \
               -skipRows [lindex $i 0] -area [lindex $i 1] -ignoreSoftBlockage -noEnableChain -horizontalPitch 56 \
               -leftOffset 0 -incremental -instancePrefix PSO_CH_${DM}_ -switchModuleInstance u_wlan_top
}

set all_pso_list_$DM [addPowerSwitch -getSwitchInstances  -powerDomain $DM]

rechainPowerSwitch -unchainByInstances -switchInstances $all_pso_list_PD_WLAN \
		   -enablePinIn EN -enablePinOut ENX 

rechainPowerSwitch -powerDomain $DM -enablePinIn EN -enablePinOut ENX -enableNetIn psw_en_wf -enableNetOut psw_en_wf_ack \
	           -switchInstances $all_pso_list_PD_WLAN   -backToBackChain RtoL  -chainByInstances  -chainDirectionX RtoL -chainDirectionY TtoB  \
                   -mergeDistanceX 26 

#######
set DM PD_BT
addPowerSwitch -column  -globalSwitchCellName PEN_PGATBDRV_OW_6   \
               -skipRows 14   -noEnableChain -horizontalPitch 56 \
               -leftOffset 0.56  -bottomOffset 3 -incremental -instancePrefix PSO_${DM}_ \
               -powerDomain $DM -switchModuleInstance u_bt_top

set channel_pso_list_$DM ""
lappend channel_pso_list_$DM {8 {3653.1 2800.16 3661.1 3014.36}} 
lappend channel_pso_list_$DM {8 {3160.5 2800.16 3167 3014.36 }} 
lappend channel_pso_list_$DM {8 {2596 2662.82 2603 3014.36 }} 
lappend channel_pso_list_$DM {8 {2349.68 2544.38 2536 3014.36 }} 
#lappend channel_pso_list_$DM {8 {2694.58 2818.62 2701.16 3013.92}} 
#lappend channel_pso_list_$DM {8 {2496.76 2818.62 2504.32 3013.92}} 
#lappend channel_pso_list_$DM {8 {2298.8 2818.62 2306.22 3013.92}}


foreach i $channel_pso_list_PD_BT {
 addPowerSwitch -column -powerDomain $DM -globalSwitchCellName PEN_PGATBDRV_OW_6  \
               -skipRows [lindex $i 0] -area [lindex $i 1] -ignoreSoftBlockage -noEnableChain -horizontalPitch 56 \
               -leftOffset 0 -incremental -instancePrefix PSO_CH_${DM}_ -switchModuleInstance u_bt_top
}

set all_pso_list_$DM [addPowerSwitch -getSwitchInstances  -powerDomain $DM]

rechainPowerSwitch -unchainByInstances -switchInstances $all_pso_list_PD_BT \
		   -enablePinIn EN -enablePinOut ENX 

rechainPowerSwitch -powerDomain $DM -enablePinIn EN -enablePinOut ENX -enableNetIn psw_en_bt -enableNetOut psw_en_bt_ack \
	           -switchInstances $all_pso_list_PD_BT   -backToBackChain RtoL  -chainByInstances  -chainDirectionX RtoL -chainDirectionY TtoB  \
                   -mergeDistanceX 26 


#######
#deletePowerSwitch -column -powerDomain PD_CODEC
deletePlaceBlockage ENDCAP_OBS_*

#####
set spgAddTapInBoundaryRow 1
set spgWellTapCheckVio 1
addWellTap -cell PEH_TAPPN  -cellInterval [expr 56 * 2]  -prefix WELLTAP -checkerBoard -powerDomain PD_ALLON
verifyWellTap -cell PEH_TAPPN -rule 29 -powerDomain PD_ALLON
addWellTap -cell PEH_TAPPN -cellInterval [expr 56 * 2] -prefix WELLTAP -checkerBoard -incremental PEH_TAPPN  -powerDomain PD_ALLON 

addWellTap -cell DCAP4_HVT_SNPS -fixedGap -checkerBoard -cellInterval [expr 56 * 2] -prefix DUMMYDCAP -powerDomain PD_ALLON
addWellTap -cell SEN_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 24.92  -startRowNum 10
addWellTap -cell SEN_FILL_ECO10  -cellInterval 112 -skipRow 88 -prefix FILLECO10 -fixedGap -inRowOffset 22.68  -startRowNum 12
addWellTap -cell SEN_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 27.16  -startRowNum 14

addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 22.68  -startRowNum 54
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 24.92 -startRowNum 54
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 30.52  -startRowNum 54
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 22.68  -startRowNum 56
addWellTap -cell SEH_FILL_ECO9  -cellInterval 112 -skipRow 88 -prefix FILLECO9 -fixedGap -inRowOffset 24.92  -startRowNum 56
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 30.52  -startRowNum 56
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 22.68  -startRowNum 58
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 24.92  -startRowNum 58
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 30.52  -startRowNum 58
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 22.68  -startRowNum 60
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 24.92  -startRowNum 60
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 30.52  -startRowNum 60


addWellTap -cell SEN_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 80.92  -startRowNum 50
addWellTap -cell SEN_FILL_ECO10  -cellInterval 112 -skipRow 88 -prefix FILLECO10 -fixedGap -inRowOffset 78.68  -startRowNum 52
addWellTap -cell SEN_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 83.16  -startRowNum 48

addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 78.68  -startRowNum 94
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 80.92  -startRowNum 94
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 86.52  -startRowNum 94
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 78.68  -startRowNum 96
addWellTap -cell SEH_FILL_ECO9  -cellInterval 112 -skipRow 88 -prefix FILLECO9 -fixedGap -inRowOffset 80.92  -startRowNum 96
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 86.52  -startRowNum 96
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 78.68  -startRowNum 98
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 80.92 -startRowNum 98
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 86.52  -startRowNum 98
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 78.68  -startRowNum 100
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 80.92  -startRowNum 100
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 86.52  -startRowNum 100



#addWellTap -cell DCAP4_HVT_SNPS -fixedGap -checkerBoard -cellInterval [expr 48.02 * 2] -inRowOffset 20 -prefix DUMMYHDDCAP -powerDomain PD_ALLON


foreach DM {PD_CODEC PD_MCU  PD_WLAN PD_BT } {
 addWellTap -cell PEN_TAPPN  -cellInterval [expr 56 * 2]  -prefix WELLTAP -checkerBoard -inRowOffset 4.48 -powerDomain $DM  ;#4.48 is endcap+PSO width
 verifyWellTap -cell PEN_TAPPN  -rule 29  -powerDomain $DM 
 addWellTap -cell PEN_TAPPN -cellInterval [expr 56 * 2] -prefix WELLTAP -checkerBoard -incremental PEN_TAPPN  -powerDomain $DM
 addWellTap -cell DCAP4_HVT_SNPS -fixedGap -checkerBoard -cellInterval [expr 56 * 2] -prefix DUMMYDCAP -inRowOffset 4.48 -powerDomain $DM
 #addWellTap -cell SEN_FILL_ECO5  -cellInterval 48.02 -skipRow 44 -prefix FILLECO5 -fixedGap -inRowOffset 25  -startRowNum 10  -powerDomain $DM
 #addWellTap -cell SEN_FILL_ECO10  -cellInterval 48.02 -skipRow 44 -prefix FILLECO10 -fixedGap -inRowOffset 22.8  -startRowNum 12  -powerDomain $DM
 #addWellTap -cell SEN_FILL_ECO3  -cellInterval 48.02 -skipRow 44 -prefix FILLECO3 -fixedGap -inRowOffset 27.28  -startRowNum 14  -powerDomain $DM
# addWellTap -cell DCAP4_HVT_SNPS -fixedGap -checkerBoard -cellInterval [expr 48.02 * 2] -inRowOffset 20 -prefix DUMMYHDDCAP -powerDomain $DM
addWellTap -cell SEN_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 24.92  -startRowNum 10 -powerDomain $DM
addWellTap -cell SEN_FILL_ECO10  -cellInterval 112 -skipRow 88 -prefix FILLECO10 -fixedGap -inRowOffset 22.68  -startRowNum 12 -powerDomain $DM
addWellTap -cell SEN_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 27.16  -startRowNum 14 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 22.68  -startRowNum 54 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 24.92 -startRowNum 54 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 30.52  -startRowNum 54 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 22.68  -startRowNum 56 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO9  -cellInterval 112 -skipRow 88 -prefix FILLECO9 -fixedGap -inRowOffset 24.92  -startRowNum 56 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 30.52  -startRowNum 56 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 22.68  -startRowNum 58 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 24.92  -startRowNum 58 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 30.52  -startRowNum 58 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 22.68  -startRowNum 60 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 24.92  -startRowNum 60 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 30.52  -startRowNum 60 -powerDomain $DM
addWellTap -cell SEN_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 80.92  -startRowNum 50 -powerDomain $DM
addWellTap -cell SEN_FILL_ECO10  -cellInterval 112 -skipRow 88 -prefix FILLECO10 -fixedGap -inRowOffset 78.68  -startRowNum 52 -powerDomain $DM
addWellTap -cell SEN_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 83.16  -startRowNum 48 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 78.68  -startRowNum 94 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 80.92  -startRowNum 94 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 86.52  -startRowNum 94 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 78.68  -startRowNum 96 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO9  -cellInterval 112 -skipRow 88 -prefix FILLECO9 -fixedGap -inRowOffset 80.92  -startRowNum 96 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4 -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 86.52  -startRowNum 96 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO3  -cellInterval 112 -skipRow 88 -prefix FILLECO3 -fixedGap -inRowOffset 78.68  -startRowNum 98 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 80.92 -startRowNum 98 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO5  -cellInterval 112 -skipRow 88 -prefix FILLECO5 -fixedGap -inRowOffset 86.52  -startRowNum 98 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 78.68  -startRowNum 100 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 80.92  -startRowNum 100 -powerDomain $DM
addWellTap -cell SEH_FILL_ECO4  -cellInterval 112 -skipRow 88 -prefix FILLECO4 -fixedGap -inRowOffset 86.52  -startRowNum 100 -powerDomain $DM

}
addWellTap -area {2125.12 2134.36 2185.73 2198.68} -cell DCAP4_HVT_SNPS -cellInterval 1.4  -prefix for_congestion_eco -powerDomain  PD_BT

##################
##ring
#setViaGenMode -optimize_cross_via true

#addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -type core_rings -jog_distance 2.5 -threshold 2.5 -nets {VSS VDD} -follow io -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.8      
#
#deselectAll
#selectObject Group PD_CODEC
#addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.5
#
#deselectAll
#selectObject Group PD_MCU
#addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.5
#
#deselectAll
#selectObject Group PD_WLAN
#addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.5
#
#deselectAll
#selectObject Group PD_BT
#addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.5

addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -type core_rings -jog_distance 2.5 -threshold 2.5 -nets {VSS VDD} -follow io -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.8      

deselectAll
selectObject Group PD_CODEC
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.3

deselectAll
selectObject Group PD_MCU
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.3

deselectAll
selectObject Group PD_WLAN
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.3

deselectAll
selectObject Group PD_BT
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VDD VSS} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 0.3

deselectAll

addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -type core_rings -jog_distance 2.5 -threshold 2.5 -nets {VNW VPW} -follow io -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 1 -spacing 0.25 -offset 3.3     

deselectAll
selectObject Group PD_CODEC
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VNW VPW} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 0.2 -spacing 0.2 -offset 2.8

deselectAll
selectObject Group PD_MCU
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VNW VPW} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 0.2 -spacing 0.2 -offset 2.8

deselectAll
selectObject Group PD_WLAN
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VNW VPW} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 0.2 -spacing 0.2 -offset 2.8

deselectAll
selectObject Group PD_BT
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -around power_domain -jog_distance 2.5 -threshold 2.5 -type block_rings -nets {VNW VPW} -stacked_via_bottom_layer M2 -layer {bottom M6 top M6 right M5 left M5} -width 0.2 -spacing 0.2 -offset 2.8

deselectAll



###put M1 on pso aon vdd pin for auto connectting to stripe VDD
foreach c [dbGet -p2 top.insts.cell.name PEN_PGATBDRV_OW_6 ] {
   if {[dbGet $c.orient] == "R0"} {
      dbCreateWire VDD [expr [dbGet $c.box_llx] + 0.5] [expr [dbGet $c.box_lly] + 0.635] [expr [dbGet $c.box_llx] + 0.5 + 2.3]  [expr [dbGet $c.box_lly] + 0.635+0.13] 1 0 STRIPE
   } else {
      dbCreateWire VDD [expr [dbGet $c.box_llx] + 0.5] [expr [dbGet $c.box_lly] + 0.495] [expr [dbGet $c.box_llx] + 0.5 + 2.3]  [expr [dbGet $c.box_lly] + 0.495+0.13] 1 0 STRIPE
   }
}

## put M2 on aon tap cell vdd pin for top/bottom aon-tap cells power auto connecting to stripe VDD
#foreach c [dbGet -p2 top.insts.cell.name PEN_TAPPN ] {
#   if {[dbGet $c.orient] == "R0" || [dbGet $c.orient] == "MY"  } {
#      dbCreateWire VPW  [expr [dbGet $c.box_llx] + 0 ]  [expr [dbGet $c.box_lly] + 0.915] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 1.045] 1 0 STRIPE
#      dbCreateWire VNW  [expr [dbGet $c.box_llx] + 0 ]  [expr [dbGet $c.box_lly] + 0.215] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 0.34] 1 0 STRIPE      
#   } else {
#      dbCreateWire VPW [expr [dbGet $c.box_llx] + 0] [expr [dbGet $c.box_lly] + 0.215] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 0.34] 1 0 STRIPE
#      dbCreateWire VNW [expr [dbGet $c.box_llx] + 0] [expr [dbGet $c.box_lly] + 0.915] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 1.045] 1 0 STRIPE
#   }
#}
#
#foreach c [dbGet -p2 top.insts.cell.name PEH_TAPPN ] {
#   if {[dbGet $c.orient] == "R0" || [dbGet $c.orient] == "MY"  } {
#      dbCreateWire VPW  [expr [dbGet $c.box_llx] + 0 ]  [expr [dbGet $c.box_lly] + 0.915] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 1.045] 2 0 STRIPE
#      dbCreateWire VNW  [expr [dbGet $c.box_llx] + 0 ]  [expr [dbGet $c.box_lly] + 0.215] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 0.34] 2 0 STRIPE
#   } else {
#      dbCreateWire VPW [expr [dbGet $c.box_llx] + 0] [expr [dbGet $c.box_lly] + 0.215] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 0.34] 2 0 STRIPE 
#      dbCreateWire VNW [expr [dbGet $c.box_llx] + 0] [expr [dbGet $c.box_lly] + 0.915] [expr [dbGet $c.box_llx] + 0.7]  [expr [dbGet $c.box_lly] + 1.045] 2 0 STRIPE
#   }
#}



#####stripe
###ALLON
setAddStripeMode -reset
#setAddStripeMode -ignore_block_check 0 -route_over_rows_only 0 -rows_without_stripes_only 0 -stop_at_last_wire_for_area 0 -trim_antenna_back_to_shape none -break_at { none } -extend_to_closest_target none -partial_set_thru_domain false
#addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 10.36 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4.27 -xleft_offset 4.025 -merge_stripes_value 2.5 -create_pins 0 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.91 -area {} -nets {VDD VSS} -stacked_via_bottom_layer M2 

#addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 2.52  -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.7 -merge_stripes_value 2.5 -direction horizontal -create_pins 0 -layer M2 -block_ring_bottom_layer_limit M5 -ybottom_offset 1.475 -width 0.13 -area {} -nets {VPW VNW} -stacked_via_bottom_layer M1 

#addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 2.52  -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.7 -merge_stripes_value 2.5 -direction horizontal -create_pins 0 -layer M2 -block_ring_bottom_layer_limit M5 -ybottom_offset 2.735 -width 0.13 -area {} -nets {VNW VPW} -stacked_via_bottom_layer M1

addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 21 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 0 -merge_stripes_value 2.5 -create_pins 0 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area {} -nets {VNW VPW} -stacked_via_bottom_layer M2 

addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 21 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4.27 -xleft_offset 4.025 -merge_stripes_value 2.5 -create_pins 0 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.91 -area {} -nets {VDD VSS} -stacked_via_bottom_layer M2 

###PD_CODEC
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring
deselectAll
selectObject Group PD_CODEC

#pso column
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.72 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area {} -nets VDD -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.1 -xleft_offset 0.81 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area {} -nets "VDD_SW_CODEC VDD_SW_CODEC" -stacked_via_bottom_layer M1

#M3 VDD for aon tap cell power connecting
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 28 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area {} -nets "VNW VPW" -stacked_via_bottom_layer M2


addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 4.94 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.97 -area {} -nets "VSS" -stacked_via_bottom_layer M2

#
setAddStripeMode -reset
deselectAll
foreach i $channel_pso_list_PD_CODEC {
  set area "[lindex [lindex $i 1] 0]  [expr [lindex [lindex $i 1] 1] -1.26]  [lindex [lindex $i 1] 2]  [ expr [lindex [lindex $i 1] 3] + 1.26] "
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.16 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area $area -nets VDD -stacked_via_bottom_layer M2

  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area $area -nets "VNW VPW" -stacked_via_bottom_layer M2
  
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.24 -xleft_offset 0.25 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area $area -nets "VDD_SW_CODEC VSS" -stacked_via_bottom_layer M2
}



#center
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring

deselectAll
selectObject Group PD_CODEC

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 15.645 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_CODEC VSS" -stacked_via_bottom_layer M2

#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 27.545 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_CODEC VSS" -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 35.245 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_CODEC VSS" -stacked_via_bottom_layer M2


###PD_MCU
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring
deselectAll
selectObject Group PD_MCU

#pso column
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.72 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area {} -nets VDD -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.1 -xleft_offset 0.81 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area {} -nets "VDD_SW_MCU VDD_SW_MCU" -stacked_via_bottom_layer M2

#M3 VDD for aon tap cell power connecting
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 28 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area {} -nets "VNW VPW" -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 4.94 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.97 -area {} -nets "VSS" -stacked_via_bottom_layer M2

#
setAddStripeMode -reset
deselectAll
foreach i $channel_pso_list_PD_MCU {
  set area "[lindex [lindex $i 1] 0]  [expr [lindex [lindex $i 1] 1] -1.26]  [lindex [lindex $i 1] 2]  [ expr [lindex [lindex $i 1] 3] + 1.26] "
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.16 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area $area -nets VDD -stacked_via_bottom_layer M2

  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area $area -nets "VNW VPW" -stacked_via_bottom_layer M2
  
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.24 -xleft_offset 0.25 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area $area -nets "VDD_SW_MCU VSS" -stacked_via_bottom_layer M2
}



#center
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring

deselectAll
selectObject Group PD_MCU

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 15.645 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_MCU VSS" -stacked_via_bottom_layer M2

#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 27.545 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_MCU VSS" -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 35.425 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_MCU VSS" -stacked_via_bottom_layer M2


###PD_WLAN
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring
deselectAll
selectObject Group PD_WLAN

#pso column
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.72 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area {} -nets VDD -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.1 -xleft_offset 0.81 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area {} -nets "VDD_SW_WLAN VDD_SW_WLAN" -stacked_via_bottom_layer M2

#M3 VDD for aon tap cell power connecting
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 28 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area {} -nets "VNW VPW" -stacked_via_bottom_layer M2

#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 48.02 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 4.52 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area {} -nets "VDD" -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 4.94 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.97 -area {} -nets "VSS" -stacked_via_bottom_layer M2

#
setAddStripeMode -reset
deselectAll
foreach i $channel_pso_list_PD_WLAN {
  set area "[lindex [lindex $i 1] 0]  [expr [lindex [lindex $i 1] 1] -1.26]  [lindex [lindex $i 1] 2]  [ expr [lindex [lindex $i 1] 3] + 1.26] "
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.16 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area $area -nets VDD -stacked_via_bottom_layer M2

  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area $area -nets "VNW VPW" -stacked_via_bottom_layer M2
 
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.24 -xleft_offset 0.25 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area $area -nets "VDD_SW_WLAN VSS" -stacked_via_bottom_layer M2
}



#center
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring

deselectAll
selectObject Group PD_WLAN

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 15.645 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_WLAN VSS" -stacked_via_bottom_layer M2

#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 27.545 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_WLAN VSS" -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 35.245 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_WLAN VSS" -stacked_via_bottom_layer M2


###PD_BT
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring
deselectAll
selectObject Group PD_BT

#pso column
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.72 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area {} -nets VDD -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.1 -xleft_offset 0.81 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area {} -nets "VDD_SW_BT VDD_SW_BT" -stacked_via_bottom_layer M2

#M3 VDD for aon tap cell power connecting
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 28 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area {} -nets "VNW VPW" -stacked_via_bottom_layer M2

#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 48.02 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 4.52 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area {} -nets "VDD" -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 4.94 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.97 -area {} -nets "VSS" -stacked_via_bottom_layer M2

#
setAddStripeMode -reset
deselectAll
foreach i $channel_pso_list_PD_BT {
  set area "[lindex [lindex $i 1] 0]  [expr [lindex [lindex $i 1] 1] -1.26]  [lindex [lindex $i 1] 2]  [ expr [lindex [lindex $i 1] 3] + 1.26] "
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 4 -xleft_offset 1.16 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 1.11 -area $area -nets VDD -stacked_via_bottom_layer M2
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.25 -xleft_offset 6.3 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.2 -area $area -nets "VNW VPW" -stacked_via_bottom_layer M2
  
  addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 2.24 -xleft_offset 0.25 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.7 -area $area -nets "VDD_SW_BT VSS" -stacked_via_bottom_layer M2
}



#center
setAddStripeMode -reset
setAddStripeMode -over_row_extension true -extend_to_closest_target ring

deselectAll
selectObject Group PD_BT

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 15.645 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_BT VSS" -stacked_via_bottom_layer M2

#addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 27.545 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_BT VSS" -stacked_via_bottom_layer M2

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M6 -padcore_ring_top_layer_limit M6 -spacing 0.21 -xleft_offset 35.245 -merge_stripes_value 2.5 -layer M5 -block_ring_bottom_layer_limit M5 -width 0.98 -area {} -nets "VDD_SW_BT VSS" -stacked_via_bottom_layer M2

############pso aon pin to VDD stripes
deselectAll
editSelect -net VDD -layer "M1 M5"
editPowerVia -skip_via_on_pin Standardcell -bottom_layer M1 -between_selected_wires 1 -add_vias 1 -top_layer M5

#editPowerVia -skip_via_on_pin Standardcell -bottom_layer M1  -add_vias 1 -top_layer M2 -orthogonal_only 0
editDelete -net VDD -layer M1
editDelete -net VDD -layer M2


############ M6
setAddStripeMode -reset
setAddStripeMode -ignore_nondefault_domains 1
addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 15.12 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.21 -merge_stripes_value 2.5 -direction horizontal -create_pins 0 -layer M6 -block_ring_bottom_layer_limit M5 -ybottom_offset 7.665 -width 0.98 -area {} -nets {VDD VSS} -stacked_via_bottom_layer M5

addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 90.72 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.21 -merge_stripes_value 2.5 -direction horizontal -create_pins 0 -layer M6 -block_ring_bottom_layer_limit M5 -ybottom_offset 11.165 -width 0.2 -area {} -nets {VNW VPW} -stacked_via_bottom_layer M5



setAddStripeMode -ignore_nondefault_domains 0 -domain_offset_from_core 1
deselectAll
selectObject Group PD_CODEC
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 15.12 -ybottom_offset 16.485 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.21 -merge_stripes_value 2.5 -direction horizontal -layer M6 -block_ring_bottom_layer_limit M5 -width 1.05 -area {} -nets VDD_SW_CODEC -stacked_via_bottom_layer M5

deselectAll
selectObject Group PD_MCU
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 15.12 -ybottom_offset 16.485 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.21 -merge_stripes_value 2.5 -direction horizontal -layer M6 -block_ring_bottom_layer_limit M5 -width 1.05 -area {} -nets VDD_SW_MCU -stacked_via_bottom_layer M5

deselectAll
selectObject Group PD_WLAN
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 15.12 -ybottom_offset 16.485 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.21 -merge_stripes_value 2.5 -direction horizontal -layer M6 -block_ring_bottom_layer_limit M5 -width 1.05 -area {} -nets VDD_SW_WLAN -stacked_via_bottom_layer M5

deselectAll
selectObject Group PD_BT
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M6 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M5 -set_to_set_distance 15.12 -ybottom_offset 16.485 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M6 -spacing 0.21 -merge_stripes_value 2.5 -direction horizontal -layer M6 -block_ring_bottom_layer_limit M5 -width 1.05 -area {} -nets VDD_SW_BT -stacked_via_bottom_layer M5


if {0} {
############# M7
##global VDD/VSS, leave 1 column for SW power
setAddStripeMode -reset
setAddStripeMode -ignore_nondefault_domains 1
addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 1.1 -xleft_offset 1 -merge_stripes_value 2.5 -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD VSS" -stacked_via_bottom_layer M6 -create_pins 0

addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 1.1 -xleft_offset [expr 1 + 16] -merge_stripes_value 2.5 -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD VSS" -stacked_via_bottom_layer M6 -create_pins 0

addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 1.1 -xleft_offset [expr 1 + 16+ 16.02] -merge_stripes_value 2.5 -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD VSS" -stacked_via_bottom_layer M6 -create_pins 0

## SW power fill into 1 empty column in 4 domain areas
setAddStripeMode -reset
setAddStripeMode -ignore_nondefault_domains 0 -domain_offset_from_core 1

deselectAll
selectObject Group PD_CODEC
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -xleft_offset 11.7 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 11.7 -merge_stripes_value 2.5  -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD_SW_CODEC VDD_SW_CODEC VDD_SW_CODEC" -stacked_via_bottom_layer M6

deselectAll
selectObject Group PD_MCU
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -xleft_offset 11.7 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 11.7 -merge_stripes_value 2.5  -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD_SW_MCU VDD_SW_MCU VDD_SW_MCU" -stacked_via_bottom_layer M6

deselectAll
selectObject Group PD_WLAN
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -xleft_offset 11.7 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 11.7 -merge_stripes_value 2.5  -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD_SW_WLAN VDD_SW_WLAN VDD_SW_WLAN" -stacked_via_bottom_layer M6


deselectAll
selectObject Group PD_BT
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4 -over_power_domain 1 -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -xleft_offset 11.7 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 11.7 -merge_stripes_value 2.5  -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD_SW_BT VDD_SW_BT VDD_SW_BT" -stacked_via_bottom_layer M6

##fill remain empty column with global VDD/VSS
setAddStripeMode -reset
setAddStripeMode -ignore_nondefault_domains 1
addStripe -skip_via_on_wire_shape Noshape -extend_to design_boundary -block_ring_top_layer_limit M7 -max_same_layer_jog_length 4  -padcore_ring_bottom_layer_limit M6 -set_to_set_distance 56 -xleft_offset 11.7 -skip_via_on_pin Standardcell -stacked_via_top_layer M7 -padcore_ring_top_layer_limit M7 -spacing 11.7 -merge_stripes_value 2.5 -layer M7 -block_ring_bottom_layer_limit M6 -width 4.3 -area {} -nets "VDD VSS VDD" -stacked_via_bottom_layer M6 -create_pins 0

}

################
#setSrouteMode -corePinReferToM1 true
sroute -connect { corePin } -layerChangeRange { M1 M5 } -corePinTarget { none } -allowJogging 0 -corePinLayer M2 \
       -crossoverViaLayerRange { M1 M5 } -nets { VDD VSS VDD_SW_CODEC VDD_SW_MCU VDD_SW_WLAN VDD_SW_BT } -allowLayerChange 0 -targetViaLayerRange { M1 M5 }

################
clearDrc
verify_drc -check_only special  -limit 1000000
fixVia -minStep
verifyConnectivity -type special -noAntenna -noUnroutedNet -error 1000000 -warning 50
#clearDrc

#source ./scripts/soft_blk.tcl

#########
attachIOBuffer  -baseName IOBUF_ \
                -in SEN_BUF_6 \
                -out SEN_BUF_6 \
                -markFixed \
                -excludeClockNet

saveDesign DBS/fp_final_$ver.enc -tcon
lefOut -noCutObs  -stripePin -specifyTopLayer 6 -PGpinLayers 6 fp_0401.lef
#source scripts/0330_add_M5_VNW_VPW_prects.tcl
#source scripts/0330_add_M5_VNW_VPW_only_route.tcl
