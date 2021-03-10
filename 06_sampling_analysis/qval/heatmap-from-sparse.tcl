#!/usr/bin/tclsh
# prepares data to heatmap plot in gnuplot
# input: 2D data (3col: x,y,val), does not have to contain all xy values, x<y
# param: DATA_NON: value in xy without values (do not want to be plotted)
# output: a file to be read by gnuplot with all xy values (min/max) with populated values and with DATA_NON values whenever no value exists 
###############################################################################################################
set FILE_NAME_IN qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin3_basin3.out
set DATA_NON -1
set DATA_ZERO 0.0000000001
###############################################################################################################
# i/o
#####

# displays a variable with its name
# input: var_name
# output: var_name, var value
proc proc_var_disp {var_name} {
	set call [dict get [info frame -1] cmd]
	puts "[lindex $call 1]\t$var_name"
}

# txt files
###########

# reads a txt file into a list
# input: file with 1-col entries
# output: list with each line as an element
proc proc_file_read_to_list {file_name} {
	set file_in [open $file_name r]
	set list_out {}
	while {[gets $file_in line]>=0} {
		lappend list_out $line
	}
	close $file_in
	return $list_out
}

# read col-n from a file
# input: file_name
# input: col_n (from 0)
# output: list with all elements of col_n
proc proc_file_read_col_n {file_name col_n} {
	set file_in [open $file_name r]
	set list_col {}
	while {[gets $file_in line]>=0} {
		lappend list_col [lindex $line $col_n]
	}
	close $file_in
	return $list_col
}

# inserts a string into a txt file name
# input: file name XXX.YYY
# input: str_add
# output: XXX_str_add.YYY
proc proc_file_name_insert_str {file_name str_add} {
	set list_file_name [split $file_name .]
	set file_name_add [lindex $list_file_name 0]_$str_add.[lindex $list_file_name 1]
	return $file_name_add
}

# return file name without a path
# input: file name with path (../../XXX/../filename.txt)
# output: name of last file in path (filename.txt)
proc proc_file_name_no_path {str_path} {
	set list_str_path [split $str_path /]
	return [lindex $list_str_path end]
}

# returns a string without its ending
# input: XXX.YYY
# output: XXX
proc proc_str_no_end {str_full} {
	set list_str [split $str_full .]
	set str_no_end [lindex $list_str 0]
	return $str_no_end
}

# replaces ending of a file
# input: str_full: XXX.YYY
# param: new ending: ZZZ
# output: XXX.ZZZ
proc proc_str_new_end {str_full END_NEW} {
	set list_str [split $str_full .]
	set str_no_end [lindex $list_str 0]
	set str_new_end "${str_no_end}.${END_NEW}"
	return $str_new_end
}

# creating output files

# creating output file name from script file name and a given input file name
# input: input_name.xxx
# ouptut: SCRIPT_NAME_input_name.out
proc proc_file_out_name_script_param1 {input_name} {
	global SCRIPT_NAME
	set input_name_noend [proc_str_no_end $input_name]
	set file_out_name "${SCRIPT_NAME}_${input_name_noend}.out"
	return $file_out_name
}

# creating output file name from script file name and 2 given input file names
# input: input_name_1.xxx, input_name_2.xxx
# ouptut: SCRIPT_NAME_input_name.out
proc proc_file_out_name_script_param2 {input_name_1 input_name_2} {
	global SCRIPT_NAME
	set input_name_1_noend [proc_str_no_end $input_name_1]
	set input_name_2_noend [proc_str_no_end $input_name_2]
	set file_out_name "${SCRIPT_NAME}_${input_name_1_noend}_${input_name_2_noend}.out"
	return $file_out_name
}

# creating output file name from script file name and a dcd file name
# input: ""
# ouptut: SCRIPT_NAME_input_name.out (dcd without path)
proc proc_file_out_name_script_dcd {} {
	global SCRIPT_NAME
	global DCD_NAME
	set dcd_name_only [proc_file_name_no_path $DCD_NAME]
	set input_name_noend [proc_str_no_end $dcd_name_only]
	set file_out_name "${SCRIPT_NAME}_${input_name_noend}.out"
	return $file_out_name
}

# creating output file name from script file name, dcd file name, and a given param
# input: PARAM
# ouptut: SCRIPT_NAME_DCD_NAME_PARAM.out (dcd without path)
proc proc_file_out_name_script_dcd_param {param} {
	global SCRIPT_NAME
	global DCD_NAME
	set dcd_name_only [proc_file_name_no_path $DCD_NAME]
	set dcd_name_noend [proc_str_no_end $dcd_name_only]
	set file_out_name "${SCRIPT_NAME}_${dcd_name_noend}_${param}.out"
	return $file_out_name
}

# creating output file name from script file name, dcd file name, file_name.xxx
# input: file_name.xxx
# ouptut: SCRIPT_NAME_input_name.out (dcd without path)
proc proc_file_out_name_script_input_dcd {file_name} {
	global SCRIPT_NAME
	global DCD_NAME
	set file_name_noend [proc_str_no_end $file_name]
	set dcd_name_only [proc_file_name_no_path $DCD_NAME]
	set input_name_noend [proc_str_no_end $dcd_name_only]
	set file_out_name "${SCRIPT_NAME}_${file_name_noend}_${input_name_noend}.out"
	return $file_out_name
}

# manipulating numbers
######################

# rounds a number to the desired decimal digits
# input: num_tar (eg 1.2345676)
# input: num_digit (eg 2)
# output: number rounded to num_digit decimal digits (1.23)
proc proc_num_round_dec {num_tar num_digit} {
	set num_pow_10 [expr 10**$num_digit]
	set num_round [expr double(round($num_pow_10*$num_tar))/$num_pow_10]
	return $num_round
}

# vectors num
#############

# calc delta val for a list
# input: list_vec
# output: delta of the elements (delta=sqrt(a^2+b^2+c^2...))
proc proc_vec_get_delta {list_vec} {
	set sum_sq 0
	foreach el $list_vec {
		set sum_sq [expr $sum_sq+$el*$el]
	}
	set delta_val [expr sqrt($sum_sq)]
	return $delta_val
}

# calc sq dist between vectors
# input: vec1, vec2
# output: sq dist between vec1-vec2: (x1-x2)^2+(y1-y2)^2+(z1-z2)^2
proc proc_vec_dist_sq {vec1 vec2} {
	set sum_sq 0
	foreach x1 $vec1 x2 $vec2 {
		set diff_12 [expr $x1-$x2]
		set diff_12_sq [expr $diff_12*$diff_12]
		set sum_sq [expr $sum_sq+$diff_12_sq]
	}
	return $sum_sq
}

# calc dist between vectors
# input: vec1, vec2
# output: dist between vec1-vec2: sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2)
proc proc_vec_dist {vec1 vec2} {
	set sum_sq 0
	foreach x1 $vec1 x2 $vec2 {
		set diff_12 [expr $x1-$x2]
		set diff_12_sq [expr $diff_12*$diff_12]
		set sum_sq [expr $sum_sq+$diff_12_sq]
	}
	set dist_12 [expr sqrt($sum_sq)]
	return $dist_12
}

# manipulating pdb/psf/dcd
##########################

# open a pdb file
# input: pdb_name
# output: molecule
proc proc_pdb_open {pdb_name} {
	set mol_pdb [mol new $pdb_name]
	return $mol_pdb
}

# open a dcd traj
# input: pdb, psf, dcd
# output: a molecule element
proc proc_dcd_open {pdb_name psf_name dcd_name} {
	set mol_dcd [mol new $psf_name]
	mol addfile $pdb_name $mol_dcd
	mol addfile $dcd_name waitfor all $mol_dcd
	return $mol_dcd
}

# lists
#######

# list edit

# display a list, line per element
# input: list_tar
# output (screen): elements of list, line per element
proc proc_puts_list_el_per_line {list_tar} {
	foreach el $list_tar {
		puts $el
	}
}

# writes a list to a file, line per element
proc proc_write_list_el_per_line {list_tar file_out} {
	foreach el $list_tar {
		puts $file_out $el
	}
}


# remove all empty elements from list
# input: list_tar
# output: list_tar without any empty elements
proc proc_list_clean_empty {list_tar} {
	set list_clean {}
	foreach el $list_tar {
		if {$el!={} && $el!=""} {
			lappend list_clean $el
		}
	}
	return $list_clean
}

# inverts a 2D list dimension
# input: list_list_dim1_dim2
# output: list_list_dim2_dim1
proc proc_list_invert_dimension {list_list_dim1_dim2} {
	set list_list_dim2_dim1 {}
	set list_tmp [lindex $list_list_dim1_dim2 0]
	set num_dim2 [llength $list_tmp]
	for {set ind 0} {$ind<$num_dim2} {incr ind} {
		set list_dim2 {}
		foreach list_dim1 $list_list_dim1_dim2 {
			lappend list_dim2 [lindex $list_dim1 $ind]
		}
		lappend list_list_dim2_dim1 $list_dim2
	}
	return $list_list_dim2_dim1
}

# creating lists
 
# create a list of all integers between 2 integers, not including 
# input: int_begin, int_end
# output: list of integers between int_begin to int_end, not including the end integers
proc proc_get_list_int_between_beg_end_no_inc {int_begin int_end} {
	set list_out {}
	for {set int_now [expr $int_begin+1]} {$int_now<$int_end} {incr int_now} {
		lappend list_out $int_now
	}
	return $list_out
} 

# create a list of all integers between 2 integers, including ends
# input: int_begin, int_end
# output: list of integers between int_begin to int_end, including the end integers
proc proc_get_list_int_between_beg_end_yes_inc {int_begin int_end} {
	set list_out {}
	for {set int_now $int_begin} {$int_now<=$int_end} {incr int_now} {
		lappend list_out $int_now
	}
	return $list_out
} 

# calculations on lists

# finds max val in list
# input: list_tar 
# output: max val in list_tar 
proc proc_list_get_max {list_tar} {
	set list_sort [lsort -real $list_tar]
	set val_max [lindex $list_sort end]
	return $val_max
} 

# finds min val in list
# input: list_tar 
# output: min val in list_tar 
proc proc_list_get_min {list_tar} {
	set list_sort [lsort -real $list_tar]
	set val_min [lindex $list_sort 0]
	return $val_min
} 

# calc avg of elements in list
# input: list_tar
# output: avg val in list
proc proc_list_get_avg {list_tar} {
	set sum_el 0
	foreach el $list_tar {
		set sum_el [expr $sum_el+$el]
	}
	set avg_list [expr $sum_el*1.0/[llength $list_tar]]
	return $avg_list
}

# calc std of elements in list
# input: list_tar
# output: std of list
proc proc_list_get_std {list_tar} {
	set sum_diff_sq_el 0
	set avg_list [proc_list_get_avg $list_tar]
	foreach el $list_tar {
		set diff_avg [expr $el-$avg_list]
		set diff_avg_sq [expr $diff_avg*$diff_avg]
		set sum_diff_sq_el [expr $sum_diff_sq_el+$diff_avg_sq]
	}
	set std_sq [expr $sum_diff_sq_el*1.0/[llength $list_tar]]
	set std_list [expr sqrt($std_sq)]
	return $std_list
}

# calc standard error of elements in list
# input: list_tar
# output: se of list
proc proc_list_get_se {list_tar} {
	set std_list [proc_list_get_std $list_tar]
	set se_list [expr $std_list*1.0/sqrt([llength $list_tar])]
	return $se_list
}

# GO model related
##################

# turns a KBGO resname into a resid
# input: KBGO resname (e.g. G22)
# output: only resid (22)
proc proc_go_resname_to_resid {resname_go} {
	set resid_go [string trimleft $resname_go "G"]
	return $resid_go
}

###############################################################################################################
# read data
set list_x [proc_file_read_col_n $FILE_NAME_IN 0]
set list_y [proc_file_read_col_n $FILE_NAME_IN 1]
set list_v [proc_file_read_col_n $FILE_NAME_IN 2]
# find minmax
set list_xy [concat $list_x $list_y]
set min_xy [proc_list_get_min $list_xy]
set max_xy [proc_list_get_max $list_xy]
# out file
set file_name_out [proc_file_name_insert_str $FILE_NAME_IN heatmap]
set file_out [open $file_name_out w]
# create pair list
set list_pair_xy {}
foreach x $list_x y $list_y {
	set pair_xy [list $x $y]
	lappend list_pair_xy $pair_xy
}

# write data
for {set x $min_xy} {$x<=$max_xy} {incr x} {
	for {set y $min_xy} {$y<=$max_xy} {incr y} {
		set pair_all [list $x $y]
		set pair_all [lsort -integer $pair_all]
		if {[lsearch $list_pair_xy $pair_all]>-1} {
			set ind_pair_yes [lsearch $list_pair_xy $pair_all]
			set v_pair_yes [lindex $list_v $ind_pair_yes]
			if {$v_pair_yes==0} {
				set v_pair_yes $DATA_ZERO
			}
		} else {
			set v_pair_yes $DATA_NON
		}
		# write
		puts $file_out "$x\t$y\t$v_pair_yes"
	}
	puts $file_out ""
}

#
close $file_out
exit

















