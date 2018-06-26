#########################################################################
# Copyright (c) 2014 Spreadtrum Communication Inc. All rights reserved.
# Spreadtrum Communication Proprietary.
# Author      : Yafeng.Shi
# Date        : 2015-07-27 14:45:06
# Version     : Initial
# Description : 
#########################################################################
source DBS/signoff.enc
set op [open dont_touch_list w]
foreach inst [dbget top.insts.isDontTouch 1 -p] {
    set inst_name [dbget $inst.name]
    puts $op "$inst_name cell"
}

foreach net [dbget top.nets.isDontTouch 1 -p] {
    set net_name [dbget $net.name]
    puts $op "$net_name net"
}

close $op
puts "**INFO: Generating dont touch list file ----> dont_touch_list"
exit
