set pppr(site,height) 0.7
set pppr(site,width) 0.14
#set pppr(hunit) 5.6
set pppr(hunit) 4.2
#set pppr(vunit) 6.3
set pppr(vunit) 4.9
set pppr(site,std) sc7mcpp140z_cln28ht
set pppr(site,psw) sc7mcpp140z_cln28ht_pg
#set pppr(psw,core) HEADBUFBIAS41_X3M_A7PP140ZTH_C40
set pppr(psw,core) HEADBUFTIE41_X3M_A7PP140ZTH_C40
#set pppr(psw,core) HEADBUF29_X2M_A7PP140ZTH_C40
#set pppr(psw,channel) HEADBUFBIAS41_X3M_A7PP140ZTH_C40
set pppr(psw,channel) HEADBUFTIE41_X3M_A7PP140ZTH_C40
#set pppr(psw,channel) HEADBUF29_X2M_A7PP140ZTH_C40
set pppr(psw,channel_threshold) 40
#set pppr(psw,skip_row_channel) 17 ;# 8 | 17 | 35
set pppr(psw,skip_row_channel) 13 ;# 8 | 17 | 35
#set pppr(psw,skip_row_core) 17 ;# 8 | 17 | 35
set pppr(psw,skip_row_core) 13 ;# 8 | 17 | 35
set pppr(psw,horizontal_pitch_channel) [expr {$pppr(hunit)*18}] ;# 9 | 18 | 36
set pppr(psw,horizontal_pitch_core) [expr {$pppr(hunit)*18}]
set pppr(cell_width,psw_core) [dbGet [dbGet head.libCells.name $pppr(psw,core) -p].size_x]
set pppr(cell_width,psw_channel) [dbGet [dbGet head.libCells.name $pppr(psw,channel) -p].size_x]

set pppr(cell,welltap)  FILLBIASNW5_A7PP140ZTH_C40
#set pppr(cell,endcap)   ENDCAPTIE3_A7PP140ZTH_C40
set pppr(cell,endcap_LR)   ENDCAPBIASNW3_A7PP140ZTH_C40
set pppr(cell,endcap_TB)   [list FILLBIASNW5_A7PP140ZTH_C40 FILL2_A7PP140ZTH_C40 FILL3_A7PP140ZTH_C40]
set pppr(cell,endcap_RT_EDGE)    FILL3_A7PP140ZTH_C40
set pppr(cell,endcap_RB_EDGE)    FILL3_A7PP140ZTH_C40
set pppr(cell,eco_comb) ECOFABRICULDRV_A7PP140ZTS_C35
set pppr(cell,eco_dff) ECOFABRICSDFF_A7PP140ZTS_C35
set pppr(cell,decap)    FILLCAP4_A7PP140ZTH_C40
set pppr(cell_width,welltap) [dbGet [dbGet head.libCells.name $pppr(cell,welltap) -p].size_x]
set pppr(cell_width,endcap_LR) [dbGet [dbGet head.libCells.name $pppr(cell,endcap_LR) -p].size_x]
set pppr(power,aon) VDD
set pppr(power,sw) ""
set pppr(gnd) VSS

#FILLSGCAP3_A7PP140ZTH_C40/    0.42         
#FILLSGCAP4_A7PP140ZTH_C40/    0.56          
#FILLSGCAP8_A7PP140ZTH_C40/    1.12         
#FILLSGCAP16_A7PP140ZTH_C40/   2.24          
#FILLSGCAP32_A7PP140ZTH_C40/   4.48          
#FILLSGCAP64_A7PP140ZTH_C40/   8.96         
#FILLSGCAP128_A7PP140ZTH_C40  17.92


#INV_X2G_A7PP140ZTS_C35_ECOULDRV   0.84 
#NAND2_X2G_A7PP140ZTS_C35_ECOULDRV 0.84
#NOR2_X2G_A7PP140ZTS_C35_ECOULDRV  0.84
#MX2_X2G_A7PP140ZTS_C35_ECOHDRV    1.68
#SDFFRPQN_X2G_A7PP140ZTS_C35_ECOSDFF 4.2
#set pppr(width,M6)  0.45
set pppr(width,M6)  0.52
set pppr(width,M5)  0.25
set pppr(width,M4)  0.13
set pppr(width,M3)  0.13
#set pppr(pitch,M6)  12.6
set pppr(pitch,M6)  [expr $pppr(vunit)*2]
#set pppr(pitch,M5)  16.8
set pppr(pitch,M5)  [expr $pppr(hunit)*3]
set pppr(gnd_offset,M6) 1
set pppr(gnd_offset,M5) 1
set pppr(aon_offset,M6) [expr {$pppr(gnd_offset,M6)+$pppr(pitch,M6)/3}]
set pppr(aon_offset,M5) [expr {$pppr(gnd_offset,M5)+$pppr(pitch,M5)/3}]
set pppr(sw_offset,M6) [expr {$pppr(gnd_offset,M6)+$pppr(pitch,M6)*2/3}]
set pppr(sw_offset,M5) [expr {$pppr(gnd_offset,M5)+$pppr(pitch,M5)*2/3}]
set pppr(spacing,M6) [expr {$pppr(pitch,M6)-$pppr(width,M6)}]
set pppr(spacing,M5) [expr {$pppr(pitch,M5)-$pppr(width,M5)}]
