#!/bin/csh 

set mypath = `pwd`
rm -rf tmp ttmp ttttmp
echo $mypath > tmp
sed -e "s/\//\\\//g" tmp > ttmp
set aa = `awk '{print $0}' ttmp`
rm -rf tmp ttmp
mkdir -p $mypath/STA
cd $mypath/STA

set tech_file = $mypath/scripts/pt_tech_file.tcl


if ( -d temp_old ) then
	rm -rf temp_old
endif
mkdir -p temp_old
mv func_* scan_* ./temp_old/
mkdir -p ice_output
/bin/rm -fr ice_output/*

# nd: 0.9v od: 1.0v ud: 0.8v

set signoff_views = ( \
func_nd_lt_rcworst_m40c_hold \
func_nd_lt_cworst_m40c_hold \
func_nd_lt_rcbest_m40c_hold \
func_nd_lt_cbest_m40c_hold \
func_nd_lt0_rcworst_m0c_hold \
func_nd_lt0_cworst_m0c_hold \
func_nd_lt0_rcbest_m0c_hold \
func_nd_lt0_cbest_m0c_hold \
func_nd_ml_rcworst_125c_hold \
func_nd_ml_cworst_125c_hold \
func_nd_ml_rcbest_125c_hold \
func_nd_ml_cbest_125c_hold \
func_nd_wcl_rcworst_m40c_hold \
func_nd_wcl_cworst_m40c_hold \
func_nd_wc_rcworst_125c_hold \
func_nd_wc_cworst_125c_hold \
func_nd_wcl_rcworstT_m40c_setup \
func_nd_wcl_cworstT_m40c_setup \
func_nd_wc_rcworstT_125c_setup \
func_nd_wc_cworstT_125c_setup \
func_od_lt_rcworst_m40c_hold \
func_od_lt_cworst_m40c_hold \
func_od_lt_rcbest_m40c_hold \
func_od_lt_cbest_m40c_hold \
func_od_ml_rcworst_125c_hold \
func_od_ml_cworst_125c_hold \
func_od_ml_rcbest_125c_hold \
func_od_ml_cbest_125c_hold \
func_od_wcl_rcworst_m40c_hold \
func_od_wcl_cworst_m40c_hold \
func_od_wc_rcworst_125c_hold \
func_od_wc_cworst_125c_hold \
func_od_wcl_rcworstT_m40c_setup \
func_od_wcl_cworstT_m40c_setup \
func_ud_ml_rcworst_125c_hold \
func_ud_lt_cbest_m40c_hold \
scan_nd_lt_rcworst_m40c_hold \
scan_nd_lt_cworst_m40c_hold \
scan_nd_lt_rcbest_m40c_hold \
scan_nd_lt_cbest_m40c_hold \
scan_nd_lt0_rcworst_m0c_hold \
scan_nd_lt0_cworst_m0c_hold \
scan_nd_lt0_rcbest_m0c_hold \
scan_nd_lt0_cbest_m0c_hold \
scan_nd_ml_rcworst_125c_hold \
scan_nd_ml_cworst_125c_hold \
scan_nd_ml_rcbest_125c_hold \
scan_nd_ml_cbest_125c_hold \
scan_nd_wcl_rcworst_m40c_hold \
scan_nd_wcl_cworst_m40c_hold \
scan_nd_wc_rcworst_125c_hold \
scan_nd_wc_cworst_125c_hold \
)
set signoff_views = ( \
func_nd_lt_rcworst_m40c_hold \
func_nd_lt_cworst_m40c_hold \
func_nd_lt_rcbest_m40c_hold \
func_nd_lt_cbest_m40c_hold \
func_nd_ml_rcworst_125c_hold \
func_nd_ml_cworst_125c_hold \
func_nd_ml_rcbest_125c_hold \
func_nd_ml_cbest_125c_hold \
func_nd_wcl_rcworst_m40c_hold \
func_nd_wcl_cworst_m40c_hold \
func_nd_wc_rcworst_125c_hold \
func_nd_wc_cworst_125c_hold \
func_nd_wcl_rcworstT_m40c_setup \
func_nd_wcl_cworstT_m40c_setup \
func_nd_wc_rcworstT_125c_setup \
func_nd_wc_cworstT_125c_setup \
func_od_lt_rcworst_m40c_hold \
func_od_lt_cworst_m40c_hold \
func_od_lt_rcbest_m40c_hold \
func_od_lt_cbest_m40c_hold \
func_od_ml_rcworst_125c_hold \
func_od_ml_cworst_125c_hold \
func_od_ml_rcbest_125c_hold \
func_od_ml_cbest_125c_hold \
func_od_wcl_rcworst_m40c_hold \
func_od_wcl_cworst_m40c_hold \
func_od_wc_rcworst_125c_hold \
func_od_wc_cworst_125c_hold \
func_od_wcl_rcworstT_m40c_setup \
func_od_wcl_cworstT_m40c_setup \
func_ud_ml_rcworst_125c_hold \
func_ud_lt_cbest_m40c_hold \
scan_nd_lt_rcworst_m40c_hold \
scan_nd_lt_cworst_m40c_hold \
scan_nd_lt_rcbest_m40c_hold \
scan_nd_lt_cbest_m40c_hold \
scan_nd_ml_rcworst_125c_hold \
scan_nd_ml_cworst_125c_hold \
scan_nd_ml_rcbest_125c_hold \
scan_nd_ml_cbest_125c_hold \
scan_nd_wcl_rcworst_m40c_hold \
scan_nd_wcl_cworst_m40c_hold \
scan_nd_wc_rcworst_125c_hold \
scan_nd_wc_cworst_125c_hold \
)
##########################prepare pt env############################################3
foreach i ( $signoff_views )
    mkdir $i
    cd $i
    cp $tech_file tmp

    if ($i =~ *_od_*) then
        set voltMode = "od"
    else if ($i =~ *_nd_*) then
        set voltMode = "nd"
    else if ($i =~ *_ud_*) then
        set voltMode = "ud"
    endif
    set i_corner =  (`echo $i | sed 's/.*'${voltMode}'_.*_\(.*\)_\(.*\)_.*/\1_\2/'`)
    set i_mode =  (`echo $i | sed 's/\(.*\)_'${voltMode}'.*_.*_.*_.*/\1/'`)
    set i_temp =  (`echo $i | sed 's/.*_'${voltMode}'_\(.*\)_.*_.*_.*/\1/'`)
    sed -e "s/SETUPPATH\/setup.tcl/${aa}\/scripts\/setup.tcl/g" tmp > tmpa

    switch ( $i ) 
    case *_lt*_*_hold:
        sed -e "s/REPORT_TYPE/hold/g" tmpa > tmpb1
        sed -e "s/CON_MODE/$i_mode/g" tmpb1 > tmpb
        sed -e "s/RC_CORNER/$i_corner/g" tmpb > tmpc
        sed -e "s/DB_CORNER/$i_temp/g" tmpc > tmpc1
        sed -e "s/VOLTAGE_MODE/$voltMode/g" tmpc1 > tmpd
        sed -e "s/SDC_CONSTRAINT/${i_mode}_sdc/g" tmpd > tmpe
        sed -e "s/delay_type DELAY_TYPE/delay_type min/g" tmpe > $i.tcl
        breaksw
    case *_ml_*_*_hold:
        sed -e "s/REPORT_TYPE/hold/g" tmpa > tmpb1
        sed -e "s/CON_MODE/$i_mode/g" tmpb1 > tmpb
        sed -e "s/RC_CORNER/$i_corner/g" tmpb > tmpc
        sed -e "s/DB_CORNER/$i_temp/g" tmpc > tmpc1
        sed -e "s/VOLTAGE_MODE/$voltMode/g" tmpc1 > tmpd
        sed -e "s/SDC_CONSTRAINT/${i_mode}_sdc/g" tmpd > tmpe
        sed -e "s/delay_type DELAY_TYPE/delay_type min/g" tmpe > $i.tcl
        breaksw
    case *_wc_*_*_hold:
        sed -e "s/REPORT_TYPE/hold/g" tmpa > tmpb1
        sed -e "s/CON_MODE/$i_mode/g" tmpb1 > tmpb
        sed -e "s/RC_CORNER/$i_corner/g" tmpb > tmpc
        sed -e "s/DB_CORNER/$i_temp/g" tmpc > tmpc1
        sed -e "s/VOLTAGE_MODE/$voltMode/g" tmpc1 > tmpd
        sed -e "s/SDC_CONSTRAINT/${i_mode}_sdc/g" tmpd > tmpe
        sed -e "s/delay_type DELAY_TYPE/delay_type min/g" tmpe > $i.tcl
        breaksw
    case *_wcl_*_*_hold:
        sed -e "s/REPORT_TYPE/hold/g" tmpa > tmpb1
        sed -e "s/CON_MODE/$i_mode/g" tmpb1 > tmpb
        sed -e "s/RC_CORNER/$i_corner/g" tmpb > tmpc
        sed -e "s/DB_CORNER/$i_temp/g" tmpc > tmpc1
        sed -e "s/VOLTAGE_MODE/$voltMode/g" tmpc1 > tmpd
        sed -e "s/SDC_CONSTRAINT/${i_mode}_sdc/g" tmpd > tmpe
        sed -e "s/delay_type DELAY_TYPE/delay_type min/g" tmpe > $i.tcl
        breaksw
    case *_wc_*_*_setup:
        sed -e "s/REPORT_TYPE/setup/g" tmpa > tmpb1
        sed -e "s/CON_MODE/$i_mode/g" tmpb1 > tmpb
        sed -e "s/RC_CORNER/$i_corner/g" tmpb > tmpc
        sed -e "s/DB_CORNER/$i_temp/g" tmpc > tmpc1
        sed -e "s/VOLTAGE_MODE/$voltMode/g" tmpc1 > tmpd
        sed -e "s/SDC_CONSTRAINT/${i_mode}_sdc/g" tmpd > tmpe
        sed -e "s/delay_type DELAY_TYPE/delay_type max/g" tmpe > $i.tcl
        breaksw
    case *_wcl_*_*_setup:
        sed -e "s/REPORT_TYPE/setup/g" tmpa > tmpb1
        sed -e "s/CON_MODE/$i_mode/g" tmpb1 > tmpb
        sed -e "s/RC_CORNER/$i_corner/g" tmpb > tmpc
        sed -e "s/DB_CORNER/$i_temp/g" tmpc > tmpc1
        sed -e "s/VOLTAGE_MODE/$voltMode/g" tmpc1 > tmpd
        sed -e "s/SDC_CONSTRAINT/${i_mode}_sdc/g" tmpd > tmpe
        sed -e "s/delay_type DELAY_TYPE/delay_type max/g" tmpe > $i.tcl
        breaksw

    default:
        breaksw
    endsw

#    rm -rf tmp tmpa tmpb tmpc tmpc1 tmpd tmpe tmpb1

    cd $mypath/STA                                                                                                                                                                 

end 

set view_num = 1

foreach i ( $signoff_views )
	cd $i
	echo \#\!\/bin\/csh \-f > do_pt_si.csh
	echo "" >> do_pt_si.csh
	echo "	cd  $mypath/STA/$i" >> do_pt_si.csh
	echo "	mkdir log" >> do_pt_si.csh
	echo "	mkdir timing_reports" >> do_pt_si.csh
	echo "	"set myhost = \`hostname\` >> do_pt_si.csh
	set myT = ${view_num}::PT::$i@\$myhost
	#echo "	pt_shell -f $i.tcl -output_log_file pt.log" >> do_pt_si.csh
	echo "	pt_shell -f $i.tcl | tee pt.log" >> do_pt_si.csh
	echo "	touch pt_shell.log" >> do_pt_si.csh
	echo "	echo ------------------------- >> pt_shell.log" >> do_pt_si.csh
	echo "	echo $i >> pt_shell.log" >> do_pt_si.csh
	echo "	echo read_spef >> pt_shell.log" >> do_pt_si.csh
	echo "	grep 'error(s)' log/read_spef.log >> pt_shell.log" >> do_pt_si.csh
	echo "	echo ------------------------- >> pt_shell.log" >> do_pt_si.csh
	echo "	echo '' >> pt_shell.log" >> do_pt_si.csh
	echo "	touch done" >> do_pt_si.csh
	echo "" >> do_pt_si.csh
	echo "cd $mypath" >> do_pt_si.csh

	chmod 750 do_pt_si.csh
	@ view_num ++
	cd ..
end


set count = 0
if ( 1 ) then
    foreach i ( $signoff_views )
        @ count ++
        #if ( $count < 16) then
        #    xterm -T "[$count] $i" -e ssh  pr5 $mypath/STA/$i/do_pt_si.csh &
        #else if ( $count < 31 ) then
        #    xterm -T "[$count] $i" -e ssh  pr6 $mypath/STA/$i/do_pt_si.csh &
        #else
        #    xterm -T "[$count] $i" -e ssh  pr7 $mypath/STA/$i/do_pt_si.csh &
        #endif
        if ( $count < 16) then
            ssh -X pr5 xterm -T "[$count]\ $i" -e $mypath/STA/$i/do_pt_si.csh &
        else if ( $count < 31 ) then
            ssh -X pr6 xterm -T "[$count]\ $i" -e $mypath/STA/$i/do_pt_si.csh &
        else
            ssh -X pr7 xterm -T "[$count]\ $i" -e $mypath/STA/$i/do_pt_si.csh &
        endif

        sleep 1
    end

    cd $mypath


    while 1
        set process = 1
        foreach i ( $signoff_views )
            if ( -e STA/$i/done ) continue
            set process = 0
        end

        if ($process == 1) then
            break
        else
            echo "pt is running ..."
            sleep 60
        endif
    end
    echo "ALL pt are finished."
endif

cd $mypath/STA
echo `date` >> $mypath/pt_summary.rpt
/home/tony/project/bt1300/usr/tony/pr_arm/run_2/scripts/summary.py >> $mypath/pt_summary.rpt
echo "" >> $mypath/pt_summary.rpt
