cutRow
set  endcaps  [dbget  top.insts.cell.name ENDCAPBIASNW*  -p2]
set  left_endcaps  ""
set  right_endcaps  ""
foreach  inst  $endcaps  {
    set  inst_box  [lindex  [dbget  $inst.box]  0]
    set  row  [lindex  [dbQuery  -objType  row  -area  [dbShape $inst_box SIZEY  -0.1]]  0]
    set  row_box  [lindex  [dbGet  $row.box]  0]
    scan $row_box  {%f %f %f %f}  row_llx  row_lly  row_urx  row_ury
    scan $inst_box  {%f %f %f %f}  inst_llx inst_lly  inst_urx inst_ury
    if  {[expr $row_llx+$row_urx]<[expr $inst_llx+$inst_urx]}  {
        lappend  right_endcaps $inst
    }  else  {
        lappend  left_endcaps $inst
    }
}
deselectAll
foreach  inst  $right_endcaps  {
    dbSelectObj  $inst
    set orient [dbget $inst.orient]
    if {$orient eq "MX"} {
        dbSet  $inst.orient  R180
    } elseif {$orient eq "R0"} {
        dbSet  $inst.orient  MY
    }
    
}
