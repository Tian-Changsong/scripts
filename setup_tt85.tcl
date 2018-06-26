set vars(ILM_flow) 0
set vars(design) bt1300_core
set vars(spef_dir) ~/project/bt1300/usr/tony/pr_arm/run_2/output
set vars(func_nd,signoff_sdc) ~/project/bt1300/usr/tony/signoff/output/all.sdc
set vars(func_od,signoff_sdc) ~/project/bt1300/usr/tony/signoff/output/all.sdc
set vars(func_ud,signoff_sdc) ~/project/bt1300/usr/tony/signoff/output/all.sdc
set vars(scan_nd,signoff_sdc) ~/project/bt1300/usr/tony/signoff/output/scan.sdc
set vars(scan_od,signoff_sdc) ~/project/bt1300/usr/tony/signoff/output/scan.sdc
set vars(scan_ud,signoff_sdc) ~/project/bt1300/usr/tony/signoff/output/scan.sdc
set vars(top_netlist) ~/project/bt1300/usr/tony/pr_arm/run_2/output/bt1300_core.0120_new.v.gz
foreach v [list nd] {
    foreach corner [list tt85] {
        switch  -- $v {
            "nd" {
                switch -- $corner {
                    "tt85" {
                        set voltage 0p90v
                        set temp 85c
                    }
                }
            }
        }
        
        if {$corner eq "tt85"} {
            set c_corner tt_ctypical
            set c_corner_std tt_ctypical_max
        }
        foreach type [list db lib] {
            set vars(${v}_${corner},$type) [glob \
                    /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_base_hvt_c35/r0p0/${type}-ccs-tn/sc7mcpp140z_cln28ht_base_hvt_c35_*${c_corner_std}_${voltage}_${temp}.${type}_ccs_tn\
                    /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_base_hvt_c40/r0p0/${type}-ccs-tn/sc7mcpp140z_cln28ht_base_hvt_c40_*${c_corner_std}_${voltage}_${temp}.${type}_ccs_tn\
                    /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_base_svt_c35/r0p0/${type}-ccs-tn/sc7mcpp140z_cln28ht_base_svt_c35_*${c_corner_std}_${voltage}_${temp}.${type}_ccs_tn\
                    /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_eco_svt_c35/r0p0/${type}-ccs-tn/sc7mcpp140z_cln28ht_eco_svt_c35_*${c_corner_std}_${voltage}_${temp}.${type}_ccs_tn\
                    /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_pmk_hvt_c40/r0p0/${type}-ccs-tn/sc7mcpp140z_cln28ht_pmk_hvt_c40_*${c_corner_std}_${voltage}_${temp}.${type}_ccs_tn\
                    /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_pmk_hvt_c35/r0p0/${type}-ccs-tn/sc7mcpp140z_cln28ht_pmk_hvt_c35_*${c_corner_std}_${voltage}_${temp}.${type}_ccs_tn\
                    /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_pmk_svt_c35/r0p0/${type}-ccs-tn/sc7mcpp140z_cln28ht_pmk_svt_c35_*${c_corner_std}_${voltage}_${temp}.${type}_ccs_tn\
                    /home/tony/project/bt1300/input/lib/memory/bt_rom_via_19456x32_3/bt_rom_via_19456x32_3_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/bt_rom_via_32768x32_0/bt_rom_via_32768x32_0_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/bt_rom_via_32768x32_1/bt_rom_via_32768x32_1_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/bt_rom_via_32768x32_2/bt_rom_via_32768x32_2_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/codec_rom_via_1536x18/codec_rom_via_1536x18_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/codec_rom_via_6400x22/codec_rom_via_6400x22_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/mcu_rom_via_32768x32_0/mcu_rom_via_32768x32_0_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/mcu_rom_via_32768x32_1/mcu_rom_via_32768x32_1_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/mcu_rom_via_32768x32_2/mcu_rom_via_32768x32_2_*${c_corner}_${voltage}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_1024x35/rf_sp_hde_1024x35_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_128x24/rf_sp_hde_128x24_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_160x32/rf_sp_hde_160x32_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_256x32_wm/rf_sp_hde_256x32_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_32x58_wm/rf_sp_hde_32x58_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_40x32/rf_sp_hde_40x32_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_512x40/rf_sp_hde_512x40_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_64x20/rf_sp_hde_64x20_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_64x58/rf_sp_hde_64x58_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_64x88_wm/rf_sp_hde_64x88_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_96x24/rf_sp_hde_96x24_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_12288x32_wm/sram_sp_hde_12288x32_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_16384x32_wm/sram_sp_hde_16384x32_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_2048x32_wm/sram_sp_hde_2048x32_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_4096x32_wm/sram_sp_hde_4096x32_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_8192x32_wm/sram_sp_hde_8192x32_wm_*${c_corner}_${voltage}*_${temp}.${type}\
                    /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_512x14/rf_sp_hde_512x14_*${c_corner}_${voltage}*_${temp}.${type} \
            ]
        }
    }
}
set vars(lef_files) [list \
        /home/bt/028n/lib/arm_tsmc/cln28ht/arm_tech/r1p0/lef/1p7m_5x1u_utalrdl/sc7mcpp140z_tech.lef \
        /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_base_hvt_c35/r0p0/lef/sc7mcpp140z_cln28ht_base_hvt_c35.lef \
        /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_base_hvt_c40/r0p0/lef/sc7mcpp140z_cln28ht_base_hvt_c40.lef \
        /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_base_svt_c35/r0p0/lef/sc7mcpp140z_cln28ht_base_svt_c35.lef \
        /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_eco_svt_c35/r0p0/lef/sc7mcpp140z_cln28ht_eco_svt_c35.lef \
        /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_pmk_hvt_c40/r0p0/lef/sc7mcpp140z_cln28ht_pmk_hvt_c40.lef \
        /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_pmk_hvt_c35/r0p0/lef/sc7mcpp140z_cln28ht_pmk_hvt_c35.lef \
        /home/tony/project/bt1300/input/lib/std/sc7mcpp140z_pmk_svt_c35/r0p0/lef/sc7mcpp140z_cln28ht_pmk_svt_c35.lef \
        /home/tony/project/bt1300/input/lib/TCD/FEOL/N28_DMY_TCD_FV_20100614.lef \
        /home/tony/project/bt1300/input/lib/TCD/FEOL/N28_DMY_TCD_FH_20100614.lef \
        /home/tony/project/bt1300/input/lib/TCD/BEOL_MX_6X/BEOL_small_FDM1_20110323.lef \
        /home/tony/project/bt1300/input/lib/TCD/BEOL_MX_6X/BEOL_small_FDM2_20110323.lef \
        /home/tony/project/bt1300/input/lib/TCD/BEOL_MX_6X/BEOL_small_FDM3_20110323.lef \
        /home/tony/project/bt1300/input/lib/TCD/BEOL_MX_6X/BEOL_small_FDM4_20110323.lef \
        /home/tony/project/bt1300/input/lib/TCD/BEOL_MX_6X/BEOL_small_FDM5_20110323.lef \
        /home/tony/project/bt1300/input/lib/TCD/BEOL_MX_6X/BEOL_small_FDM6_20110323.lef \
        /home/tony/project/bt1300/input/lib/memory/bt_rom_via_19456x32_3/bt_rom_via_19456x32_3.lef \
        /home/tony/project/bt1300/input/lib/memory/bt_rom_via_32768x32_0/bt_rom_via_32768x32_0.lef \
        /home/tony/project/bt1300/input/lib/memory/bt_rom_via_32768x32_1/bt_rom_via_32768x32_1.lef \
        /home/tony/project/bt1300/input/lib/memory/bt_rom_via_32768x32_2/bt_rom_via_32768x32_2.lef \
        /home/tony/project/bt1300/input/lib/memory/codec_rom_via_1536x18/codec_rom_via_1536x18.lef \
        /home/tony/project/bt1300/input/lib/memory/codec_rom_via_6400x22/codec_rom_via_6400x22.lef \
        /home/tony/project/bt1300/input/lib/memory/mcu_rom_via_32768x32_0/mcu_rom_via_32768x32_0.lef \
        /home/tony/project/bt1300/input/lib/memory/mcu_rom_via_32768x32_1/mcu_rom_via_32768x32_1.lef \
        /home/tony/project/bt1300/input/lib/memory/mcu_rom_via_32768x32_2/mcu_rom_via_32768x32_2.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_1024x35/rf_sp_hde_1024x35.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_128x24/rf_sp_hde_128x24.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_160x32/rf_sp_hde_160x32.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_256x32_wm/rf_sp_hde_256x32_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_32x58_wm/rf_sp_hde_32x58_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_40x32/rf_sp_hde_40x32.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_512x40/rf_sp_hde_512x40.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_64x20/rf_sp_hde_64x20.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_64x58/rf_sp_hde_64x58.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_64x88_wm/rf_sp_hde_64x88_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_96x24/rf_sp_hde_96x24.lef \
        /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_12288x32_wm/sram_sp_hde_12288x32_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_16384x32_wm/sram_sp_hde_16384x32_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_2048x32_wm/sram_sp_hde_2048x32_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_4096x32_wm/sram_sp_hde_4096x32_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/sram_sp_hde_8192x32_wm/sram_sp_hde_8192x32_wm.lef \
        /home/tony/project/bt1300/input/lib/memory/rf_sp_hde_512x14/rf_sp_hde_512x14.lef \
]
