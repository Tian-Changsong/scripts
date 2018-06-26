#!/usr/bin/python2
# encoding: utf-8
#========================================================================
#   Author:         changsongtian
#   Created at:     2016-02-01 13:04:44
#   Description:    display server information of current server(use "lshosts" alternatively)
#   Usage:          
#========================================================================
import os,sys,re,commands,glob
os_verison=commands.getoutput("cat /etc/redhat-release | grep 'Red Hat'")
if os_verison == "":
    os_verison=commands.getoutput("cat /etc/centos-release | grep 'CentOS'")
total_physical_cpu_num=commands.getoutput("cat /proc/cpuinfo | grep 'physical id' | sort -u | wc -l")
cores_per_cpu=commands.getoutput("cat /proc/cpuinfo | grep 'cpu cores' | uniq").split()[-1]
total_physical_core_num=int(cores_per_cpu)*int(total_physical_cpu_num)
total_logic_cpu_num=commands.getoutput("cat /proc/cpuinfo | grep 'processor' | sort -u | wc -l")
logic_cpu_per_core=str(int(total_logic_cpu_num)/int(total_physical_core_num))
total_mem=commands.getoutput("cat /proc/meminfo | grep 'MemTotal'").split()[-2]
cpu_type=commands.getoutput("cat /proc/cpuinfo | grep 'model name'").split(":")[-1].strip()
print ""
print "OS version:".ljust(25),os_verison
print "CPU type:".ljust(25),cpu_type
print "Physical CPUs:".ljust(25),total_physical_cpu_num
print "Physical cores:".ljust(25),total_physical_core_num,"("+cores_per_cpu+" cores per CPU)"
print "Logical cores(Threads):".ljust(25),total_logic_cpu_num,"("+logic_cpu_per_core+" thread per core)"
print "Total memory:".ljust(25),int(total_mem)/1024/1024, "GB"
