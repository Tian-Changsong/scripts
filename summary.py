#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import glob
corners=glob.glob("func*")+glob.glob("scan*")

summary_dict={}
for corner in corners:
    if corner not in summary_dict:
        summary_dict[corner]={}
    if "setup" not in corner and "hold" not in corner:
        continue
    timing_rpt=glob.glob(corner+"/timing_reports/*xtk*wo_io.rpt")
    if timing_rpt==[]:
        continue
    summary_dict[corner]["wns"]=0
    summary_dict[corner]["tns"]=0
    summary_dict[corner]["num"]=0
    for line in open(timing_rpt[0]):
        if "slack (VIOLATED)" in line:
            slack=float(line.split()[-1])
            summary_dict[corner]['tns']+=slack
            summary_dict[corner]['num']+=1
            if slack<summary_dict[corner]['wns']:
                summary_dict[corner]['wns']=slack
    constraint_rpt=glob.glob(corner+"/timing_reports/*rpt.cons")
    if constraint_rpt==[]:
        continue
    summary_dict[corner]["max_tran_num"]=0
    summary_dict[corner]["max_cap_num"]=0
    summary_dict[corner]["max_fanout_num"]=0
    start=0
    start2=0
    for line in open(constraint_rpt[0]):
        if "max_transition" in line and line.split()[0]=="max_transition":
            start=1
            key="max_tran_num"
        elif "max_fanout" in line and line.split()[0]=="max_fanout":
            start=1
            key="max_fanout_num"
        elif "max_capacitance" in line and line.split()[0]=="max_capacitance":
            start=1
            key="max_cap_num"
        if start2 and line.split()==[]:
            start=0
            start2=0
        if start2:
            summary_dict[corner][key]+=1
        if start and "---" in line:
            start2=1


setup_corners=[x for x in summary_dict if "setup" in x]
hold_corners=[x for x in summary_dict if "hold" in x]
corner_length=max([len(x) for x in summary_dict])+3
wns_length    = 20
tns_length    = 20
num_length    = 20
tran_length   = 20
cap_length    = 20
fanout_length = 20
print "CORNER".ljust(corner_length)+"WNS".ljust(wns_length)+"TNS".ljust(wns_length)+"NUMBER".ljust(num_length)+"MAX TRAN".ljust(tran_length)+"MAX FANOUT".ljust(fanout_length)+"MAX CAP".ljust(cap_length)
print "="*(wns_length+corner_length+tns_length+num_length+tran_length+cap_length+fanout_length)
for key in summary_dict:
    for k in ["wns","tns","num","max_cap_num","max_tran_num","max_fanout_num"]:
        if not summary_dict[key].has_key(k):
            summary_dict[key][k]="N/A"
        else:
            summary_dict[key][k]=str(summary_dict[key][k])

for c in sorted(setup_corners):
    print c.ljust(corner_length)+summary_dict[c]["wns"].ljust(wns_length)+summary_dict[c]['tns'].ljust(tns_length)+summary_dict[c]['num'].ljust(num_length)+summary_dict[c]["max_tran_num"].ljust(tran_length)+summary_dict[c]["max_fanout_num"].ljust(fanout_length)+summary_dict[c]["max_cap_num"].ljust(cap_length)
print "-"*(wns_length+corner_length+tns_length+num_length+tran_length+cap_length+fanout_length)
for c in sorted(hold_corners):
    print c.ljust(corner_length)+summary_dict[c]["wns"].ljust(wns_length)+summary_dict[c]['tns'].ljust(tns_length)+summary_dict[c]['num'].ljust(num_length)+summary_dict[c]["max_tran_num"].ljust(tran_length)+summary_dict[c]["max_fanout_num"].ljust(fanout_length)+summary_dict[c]["max_cap_num"].ljust(cap_length)
