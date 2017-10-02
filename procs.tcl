proc insert_psw {args} \
{
    parse_proc_arguments -args $args results
}
define_proc_arguments insert_psw -info "Insert psw in core and channel" \
    -define_args {
        {-string "String help" "string_val" string optional}
        #"arg_name"  "option_help"  "value_help"  "data_type" "attributes"
        #data_type:string, list, boolean, int, integer, float, or one_of_string
        #attributes|required|optional|internal|value_help|values {allowable_values}|merge_duplicates
    }
proc get_channel_area {args} \
{
    parse_proc_arguments -args $args results
    set domain_name $results(-power_domain)
    set channel_width_half [expr $results(-width)/2]
    set power_domain [dbget $top.pds.name $domain_name]
    
    set domain_inst [dbget $power_domain.group.members.name]
    set macros [dbget top.insts.isHaloBlock 1 -p]
    set all_shape ""
    set all_shape_macro ""
    foreach macro $macros {
        set boxes [lindex [dbget $macro.boxes] 0]
        foreach box $boxes {
            set box_expand [dbShape $box SIZEX $channel_width_half]
            set all_shape [dbShape $box_expand OR $all_shape]
            set all_shape_macro [dbShape $box OR $all_shape_macro]
        }
    }
    set domain_boxes [lindex [dbget $power_domain.group.boxes] 0]
    set domain_boxes_expand [dbShape $domain_boxes SIZEX 0.001]
    set domain_boxes_ring [dbShape [dbShape $domain_boxes_expand ANDNOT $domain_boxes] SIZEX $channel_width_half]
    set all_shape [dbShape $box_expand OR $domain_boxes_ring]
    set all_shape [dbShape $all_shape SIZEX -$channel_width_half]
    set channel_shape [dbShape $all_shape ANDNOT $all_shape_macro]

}
define_proc_arguments get_channel_area -info "get_channel_area" \
    -define_args {
        {-power_domain "power domain name" domain_name string required}
        {-string "String help" "string_val" string optional}
        #"arg_name"  "option_help"  "value_help"  "data_type" "attributes"
        #data_type:string, list, boolean, int, integer, float, or one_of_string
        #attributes|required|optional|internal|value_help|values {allowable_values}|merge_duplicates
    }

