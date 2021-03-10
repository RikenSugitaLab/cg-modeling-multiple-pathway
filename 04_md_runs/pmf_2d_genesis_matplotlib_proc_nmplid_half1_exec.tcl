#!/usr/bin/tclsh
# converts pmf from genesis "pmf_analysis" to a matplotlib format
# input: pmf file from GENESIS "pmf_analysis" (pmf at each xy): assumes data is not inverted
# input: pmf input file for GENESIS "pmf_analysis" (contains grids)
# output: file for grid-x, file for grid-y, file of inverted 2D pmf, aligned to minimum value with infinity values set to max values
##############################################################################################################
set FILE_NAME_PMF DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_half1_nmp_lid_2d.pmf
set FILE_NAME_OUTPUT pmf_2d_nmp_lid_half1_exec.out
set SCRIPT_NAME pmf_2d_genesis_matplotlib
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

# reads a 2D file into a list
# input: file_name of file with multi-row, multi-col
# output: list_list in which every row is a sublist in the complete list
proc proc_file_2d_read_to_list {file_name} {
	set file_in [open $file_name r]
	set list_list_ans {}
	while {[gets $file_in line]>=0} {
		lappend list_list_ans $line
	}
	close $file_in
	return $list_list_ans
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

# splits str into list with all possible splitter characters
# input: str_tar
# output: str_tar split into a list by all splitters: "-","_","."
proc proc_str_split_to_list_by_multi {str_tar} {
	# hyphen
	set list_str_hyphen [split $str_tar "-"]
	# underscore
	set list_str_under {}
	foreach str_hyphen $list_str_hyphen {
		set list_sub_str_under [split $str_hyphen "_"]
		lappend list_str_under $list_sub_str_under
	}
	set list_str_under [join $list_str_under]
	# period
	set list_str_period {}
	foreach str_under $list_str_under {
		set list_sub_str_period [split $str_under "."]
		lappend list_str_period $list_sub_str_period
	}
	set list_str_period [join $list_str_period]
	# return
	return $list_str_period
}

# compares 2 lists element by element, returns list with ind of different elements
# input: list1, list2 (same len)
# output: list of indexes of different elements
proc proc_list_compare_el_by_el {list1 list2} {
	set what_ind 0
	set list_ind_diff {}
	foreach el1 $list1 el2 $list2 {
		if {$el1!=$el2} {
			lappend list_ind_diff $what_ind
		}
		incr what_ind
	}
	return $list_ind_diff
}

# returns common part of 2 strings, the different part replaced by X
# input: 2 strings
# param: X_STR: string to put instead of different part
# output: 1 string, with different part replaced by X_STR
proc proc_str_unite_common {str1 str2 X_STR} {
	# obtain str common as list
	set list_str1 [proc_str_split_to_list_by_multi $str1]
	set list_str2 [proc_str_split_to_list_by_multi $str2]
	set list_ind_diff [proc_list_compare_el_by_el $list_str1 $list_str2]
	if {[llength $list_ind_diff]>0} {
		set ind_diff [lindex $list_ind_diff 0]
		set list_str_common [lreplace $list_str1 $ind_diff $ind_diff $X_STR]
	} else {
		set list_str_common $list_str1
	}
	# reproduce separators
	set list_str_char [split $str1 {}]
	set list_sep {}
	foreach char $list_str_char {
		if {[string is alnum $char]==0} {
			lappend list_sep $char
		}
	}
	# insert separators
	set str_final [lindex $list_str_common 0]
	set list_str_remain [lrange $list_str_common 1 end]
	foreach sep $list_sep strsub $list_str_remain {
		set str_final "${str_final}${sep}${strsub}"
	}
	return $str_final
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

# manipulating strings, format
##############################

# returns a list with number of spaces between each word in str
# input: str_tar
# output: list with number of spaces between each word-like element in string, starting from before 1st element
proc proc_str_list_spaces {str_tar} {
	set list_str [split $str_tar]
	set list_space_num {}
	foreach word $list_str {
		if {$word!=""} {
			lappend list_space_num $num_space
			set num_space 0
		}
		incr num_space
	}
	return $list_space_num
}

# returns a list as a formatted string according to given number of spaces
# input: list_tar
# input: list_num_space
# output: list written as string with correct number of spaces (starts from spaces)
proc proc_str_from_list_spaces {list_tar list_num_space} {
	set str_all ""
	foreach num_space $list_num_space el_tar $list_tar {
		set str_space ""
		set ind_space 0
		while {$ind_space<$num_space} {
			append str_all " "
			incr ind_space
		}
		append str_all $el_tar
	}
	return $str_all
}

# replaces all certain characters in string with a different char
# input: str_tar
# input: char_old
# input: char_new
# output: all char_old in str_tar replaced by char_new
proc proc_str_replace_char_by_char {str_tar char_old char_new} {
	set str_new $str_tar
	set pos 1
	while {$pos!=-1} {
		set pos [string first $char_old $str_new]
		if {$pos!=-1} {
			set str_new [string replace $str_new $pos $pos $char_new]
		}
	}
	return $str_new
}

# turns a list into tabbed string
# input: list_target
# output: string of list elements, separated by tabs
proc proc_list_to_str_tab {list_target} {
	set str_ans [lindex $list_target 0]
	for {set ind 1} {$ind<[llength $list_target]} {incr ind} {
		set el_now [lindex $list_target $ind]
		set str_ans "${str_ans}\t${el_now}"
	}
	return $str_ans
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

# scales a number to a desired range 
# input: min_now, max_now (min/max value of current range)
# input: min_tar, max_tar (min/max value of desired range)
# input: num_tar
# output: the number scaled between min_tar -> max_tar
proc proc_num_scale_to_range {min_now max_now min_tar max_tar num_tar} {
	set num_scaled [expr ($num_tar-$min_now)/($max_now-$min_now)*($max_tar-$min_tar)+$min_tar]
	return $num_scaled
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

# calc scalar product of lists
# input: list1 list2 (same dimension)
# output: scalar product of lists
# eg: {a b c} {d e f} -> {ad+be+cf}
proc proc_vec_scalar_prod {list1 list2} {
	set prod_scal 0
	foreach el1 $list1 el2 $list2 {
		set mult [expr $el1*$el2]
		set prod_scal [expr $prod_scal+$mult]
	}
	return $prod_scal
}

# calc length of vector
# input: vec
# output: length of vector (sqrt(x^2+y^2+z^2))
proc proc_vec_len {vec} {
	set sum_sq 0
	foreach el $vec {
		set sq_el [expr $el*$el]
		set sum_sq [expr $sum_sq+$sq_el]
	}
	set vec_len [expr sqrt($sum_sq)]
	return $vec_len
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

# calc scalar product of lists
# input: list1 list2 (same dimension)
# output: scalar product of lists
# eg: {a b c} {d e f} -> {ad+be+cf}
proc proc_vec_scalar_prod {list1 list2} {
	set prod_scal 0
	foreach el1 $list1 el2 $list2 {
		set mult [expr $el1*$el2]
		set prod_scal [expr $prod_scal+$mult]
	}
	return $prod_scal
}


# calc ang between 3 points
# input: p1, p2, p3
# output: angle between p1-p2-p3
proc proc_point_ang {p1 p2 p3} {
	set vec_a [proc_list_subtract_list $p1 $p2]
	set vec_b [proc_list_subtract_list $p3 $p2]
	# scalar prod
	set prod_scal [proc_vec_scalar_prod $vec_a $vec_b]
	# lengths
	set len_a [proc_vec_len $vec_a]
	set len_b [proc_vec_len $vec_b]
	# ang
	set ang_rad [expr acos($prod_scal*1.0/($len_a*$len_b))]
	set ang_deg [expr $ang_rad*57.2958]
	return $ang_deg
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

# open a dcd traj from fr_first to fr_last
# input: pdb, psf, dcd
# fr_first, fr_last
# output: a molecule element
proc proc_dcd_open_fr_first_last {pdb_name psf_name dcd_name fr_first fr_last} {
	set mol_dcd [mol new $psf_name]
	mol addfile $pdb_name $mol_dcd
	mol addfile $dcd_name first $fr_first last $fr_last waitfor all $mol_dcd
	return $mol_dcd
}

# open a dcd traj from fr_first to fr_last in steps of fr_step
# input: pdb, psf, dcd
# fr_first, fr_last, fr_step
# output: a molecule element
proc proc_dcd_open_fr_first_last_step {pdb_name psf_name dcd_name fr_first fr_last fr_step} {
	set mol_dcd [mol new $psf_name]
	mol addfile $pdb_name $mol_dcd
	mol addfile $dcd_name first $fr_first last $fr_last step $fr_step waitfor all $mol_dcd
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

# removes all alphabet elements from list
proc proc_list_clean_alpha {list_tar} {
	set list_ans {}
	foreach el $list_tar {
		if {[string is alpha $el]==0} {
			lappend list_ans $el
		}
	}
	return $list_ans
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

# returns indices of a list of elements in a list
# input: list_tar
# input: list_el
# output: list with index of each element in list_el (assuming el appears once in list)
proc proc_search_list_el {list_tar list_el} {
	set list_ind_el {}
	foreach el $list_el {
		set ind_el [lsearch $list_tar $el]
		lappend list_ind_el $ind_el
	}
	return $list_ind_el
}

# returns a list of elements from an index list (lindex for multiple)
# input: list_tar
# input: list_ind
# output: list with elements in indexes at list_ind 
proc proc_lindex_all_list {list_tar list_ind} {
	set list_el_all {}
	foreach ind $list_ind {
		lappend list_el_all [lindex $list_tar $ind]
	}
	return $list_el_all
}

# returns sublist index of an element
# input: list_list_sub: list of lists
# input: el_tar
# output: the index of the sublist to which el_tar belongs
proc proc_lsearch_sublist {list_list_sub el_tar} {
	for {set ind_sublist 0} {$ind_sublist<[llength $list_list_sub]} {incr ind_sublist} {
		set list_sub [lindex $list_list_sub $ind_sublist]
		if {[lsearch $list_sub $el_tar]>-1} {
			return $ind_sublist
		}
	}
	return -1
}

# subtracts a cont num from a list
# input: list_tar
# input: NUM_SUB
# output: each el in list, NUM_SUB subtracted from it
proc proc_list_subtract_const {list_tar num_sub} {
	set list_ans {}
	foreach el $list_tar {
		set el_sub [expr $el-$num_sub]
		lappend list_ans $el_sub
	}
	return $list_ans
}

# add a const num to a list
# input: list_tar
# input: NUM_ADD
# output: each el in list, NUM_ADD added to it
proc proc_list_add_const {list_tar num_add} {
	set list_ans {}
	foreach el $list_tar {
		set el_add [expr $el+$num_add]
		lappend list_ans $el_add
	}
	return $list_ans
}

# returns abs-val of list
# input: list_tar
# output: abs val of all el in list
proc proc_list_abs_val {list_tar} {
	set list_ans {}
	foreach el $list_tar {
		set abs_val [expr abs($el)]
		lappend list_ans $abs_val
	}
	return $list_ans
}


# adds two lists element by element
# input: list_1, list_2
# output: list_1+list_2, element-wise
proc proc_list_add_lists {list_1 list_2} {
	set list_sum {}
	foreach el1 $list_1 el2 $list_2 {
		set sum_el [expr $el1+$el2]
		lappend list_sum $sum_el
	}
	return $list_sum
}

# multiplies every element of list by MULT
# input: list_tar
# param: MULT
# output: each el in list multiplied by MULT
proc proc_list_mult_each_el {list_tar mult} {
	set list_ans {}
	foreach el $list_tar {
		lappend list_ans [expr $el*$mult]
	}
	return $list_ans
}

# returns every Nth element of list
# input: list_tar
# input: num_step
# output: list_tar with elements in steps of num_step, starting from first element
proc proc_list_skim_step {list_tar num_step} {
	set list_ans {}
	for {set ind 0} {$ind<[llength $list_tar]} {incr ind $num_step} {
		set el [lindex $list_tar $ind]
		lappend list_ans $el
	}
	return $list_ans
}

# returns avg of 2 adjacent elements in list
# input: list_tar
# output: list where each val is the avg of 2 adjacent elements in list_tar (contains 1 less element than list_tar)
proc proc_list_get_avg_adj {list_tar} {
	set list_first [lrange $list_tar 0 [expr [llength $list_tar]-2]]
	set list_second [lrange $list_tar 1 end]
	set list_avg {}
	foreach el_first $list_first el_second $list_second {
		set avg_val [expr ($el_first+$el_second)/2.0]
		lappend list_avg $avg_val
	}
	return $list_avg
}

# normalizes a histogram list
# input: list_tar
# output: normalized list: sum of elements = 1
proc proc_list_get_normalized {list_tar} {
	set sum_el 0
	foreach el $list_tar {
		set sum_el [expr $sum_el+$el]
	}
	set list_norm {}
	foreach el $list_tar {
		set el_norm [expr $el*1.0/$sum_el]
		lappend list_norm $el_norm
	}
	return $list_norm
}

# scales a list range to a desired range 
# input: min_now, max_now (min/max value of current range)
# input: min_tar, max_tar (min/max value of desired range)
# input: list_tar
# output: the list, where each element is scaled between min_tar -> max_tar
proc proc_list_scale_to_range {min_now max_now min_tar max_tar list_tar} {
	set list_scaled {}
	foreach el $list_tar {
		set el_scaled [expr ($el-$min_now)/($max_now-$min_now)*($max_tar-$min_tar)+$min_tar]
		lappend list_scaled $el_scaled
	}
	return $list_scaled
}

# returns whether there are common elements between 2 lists
# input: list1, list2
# output: "1" if there is a common element, "0" if not
proc proc_list_is_el_common {list1 list2} {
	foreach el1 $list1 {
		foreach el2 $list2 {
			if {$el1==$el2} {
				return 1
			}
		}
	}
	return 0
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

# create a list of given size with all elements el_tar 
# input: size_tar, el_tar
# output: list of size size_tar, all elements are el_tar
proc proc_get_list_size_el_uni {size_tar el_tar} {
	set ind_now 0
	set list_ans {}
	while {$ind_now<$size_tar} {
		lappend list_ans $el_tar
		incr ind_now
	}
	return $list_ans
}

# creates a list from within given borders and number of requested bins
# input: MIN, MAX, NUM_BINS
# output: list with NUM_BINS number of bins, written as borders of each bins (containing NUM_BINS+1 elements)
proc proc_get_list_min_max_num_bin {min max num_bins} {
	set diff_min_max [expr $max-$min]
	set size_bin [expr $diff_min_max*1.0/$num_bins]
	set list_bin_border {}
	lappend list_bin_border $min
	set now $min
	while {[llength $list_bin_border]<[expr $num_bins+1]} {
		set now [expr $now+$size_bin]
		lappend list_bin_border $now
	}
	return $list_bin_border
}

# create a list between 2 borders in requestd increments, including borders
# input: min, max, incr_bin
# output: list between min-incr_bin/2 and max+..., with increments INCR between elements
proc proc_get_list_min_max_incr {min max incr_bin} {
	set el_now [expr $min-$incr_bin*0.5]
	set list_ans {}
	lappend list_ans $el_now
	while {$el_now<$max} {
		set el_now [expr $el_now+$incr_bin]
		lappend list_ans $el_now
	}
	return $list_ans
}

# create a list between 2 borders in requested increments, first element is min, last is max
# input: min, max, resol
# output: list from min to max in increments of resol
proc proc_get_list_min_max_resol {min max resol} {
	set list_ans {}
	set el_now $min
	while {$el_now<$max} {
		lappend list_ans $el_now
		set el_now [expr $el_now+$resol]
	}
	return $list_ans
}

# create a list from start_el with the requested size with constant increments
# input: start_el, size_list, incr_el
# output: list from start_el, of size size_list, with increments of incr_el
proc proc_get_list_start_size_incr {start_el size_list incr_el} {
	set ind_last [expr $start_el+$size_list*$incr_el]
	set list_out {}
	for {set ind_now $start_el} {$ind_now<$ind_last} {incr ind_now $incr_el} {
		lappend list_out $ind_now
	}
	return $list_out
}

# creates a list of midpoints between adjacent elements of list
# input: list_tar
# output: list of length n-1 where each element is the midpoint between 2 adj elements
proc proc_get_list_midpoint_adj {list_tar} {
	set list_ans {}
	for {set ind 1} {$ind<[llength $list_tar]} {incr ind} {
		set ind_prev [expr $ind-1]
		set el_prev [lindex $list_tar $ind_prev]
		set el_now [lindex $list_tar $ind]
		set el_mid [expr ($el_prev+$el_now)*1.0/2]
		set str_len [string length $el_now]
		set prec_tar [expr $str_len-1]
		set el_mid_format [proc_num_round_dec $el_mid $prec_tar]
		lappend list_ans $el_mid_format
	}
	return $list_ans
}

# creates a list from 0 to 1 with requested number of elements (in equal spacing)
# input: num_bin
# output: list from 0 to 1 and all elements within, spaced equally, with size $NUM_BIN
proc proc_get_list_0_1_num_bin_spacing {num_bin} {
	set div [expr $num_bin-1]
	set incr_bin [expr 1.0/$div]
	set list_bin {}
	set bin_now 0
	lappend list_bin $bin_now
	while {[llength $list_bin]<$num_bin} {
		set bin_now [expr $bin_now+$incr_bin]
		lappend list_bin $bin_now
	}
	set list_bin [lreplace $list_bin end end 1]
	return $list_bin
}

# creates a list of pairs between all adjacent elements of a list
# input: list_tar
# output: list of sublist, each sublist contains adjacent elements of the list: {1 2 3 4} -> {{1 2} {2 3} {3 4}}
proc proc_get_list_pair_adj {list_tar} {
	set list_ans {}
	for {set ind 0} {$ind<[expr [llength $list_tar]-1]} {incr ind} {
		set el_now [lindex $list_tar $ind]
		set el_next [lindex $list_tar [expr $ind+1]]
		set list_pair [list $el_now $el_next]
		lappend list_ans $list_pair
	}
	return $list_ans
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

# finds location of max element in list
# input: list_key, list_val
# output: list of keys which contain the max values of list_val
proc proc_list_get_max_locs {list_key list_val} {
	set max_val [proc_list_get_max $list_val]
	set list_ind_key_max [lsearch -all $list_val $max_val]
	set list_val_max [proc_lindex_all_list $list_key $list_ind_key_max]
	return $list_val_max
} 

# returns ind of max val in list
# input: list_tar
# output: ind of max element
proc proc_list_get_ind_max_val {list_tar} {
	set max_val [lindex $list_tar 0]
	set max_ind 0
	for {set ind 0} {$ind<[llength $list_tar]} {incr ind} {
		set el_ind [lindex $list_tar $ind]
		if {$el_ind>$max_val} {
			set max_val $el_ind
			set max_ind $ind
		}
	}
	return $max_ind
}

# returns ind of min val in list
# input: list_tar
# output: ind of min element
proc proc_list_get_ind_min_val {list_tar} {
	set min_val [lindex $list_tar 0]
	set min_ind 0
	for {set ind 0} {$ind<[llength $list_tar]} {incr ind} {
		set el_ind [lindex $list_tar $ind]
		if {$el_ind<$min_val} {
			set min_val $el_ind
			set min_ind $ind
		}
	}
	return $min_ind
}

# counts appearences of element X in list
# input: list_tar
# input: el_tar
# output: number of times el_tar appears in list
proc proc_list_count_el_tar {list_tar el_tar} {
	set list_ind_el_tar [lsearch -all $list_tar $el_tar]
	set num_el_tar [llength $list_ind_el_tar]
	return $num_el_tar
}

# calc sum of all elements in list
# input: list_tar
# output: sum of all elements in list
proc proc_list_get_sum_elem {list_tar} {
	set ans_sum 0
	foreach el $list_tar {
		set ans_sum [expr $ans_sum+$el]
	}
	return $ans_sum
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

# calc weighted avg of elements in list
# input: list_tar
# input: weight of each element in list_tar
# output: weighted avg of list elements
proc proc_list_get_avg_weight {list_tar list_weight} {
	set sum_el 0
	foreach el $list_tar weight $list_weight {
		set sum_el [expr $sum_el+$el*$weight]
	}
	set avg [expr $sum_el*1.0/[proc_list_get_sum_elem $list_weight]]
	return $avg
}

# remove and element from an weighted avg of a list
# input: all_avg: the total weighted avg
# input: all_weight: sum of all elements in list
# input: el_tar, el_weight: element and weight of element to be removed
proc proc_list_remove_from_weight_avg {all_avg all_weight el_tar el_weight} {
	set sum_val_all [expr $all_avg*$all_weight]
	set sum_no_el_all [expr $sum_val_all-$el_tar*$el_weight]
	set all_no_el_weight [expr $all_weight-$el_weight]
	set avg_no_el [expr $sum_no_el_all*1.0/$all_no_el_weight]
	return $avg_no_el
}


# calc median of elements in list
# input: list_tar
# output: median val in list
proc proc_list_get_median {list_tar} {
	set list_sort [lsort -real $list_tar]
	set len_list [llength $list_sort]
	if {[expr $len_list%2==0]} {
		# even
		set ind_middle_up [expr $len_list/2]
		set ind_middle_down [expr $ind_middle_up-1]
		set list_middles [list [lindex $list_sort $ind_middle_down] [lindex $list_sort $ind_middle_up]]
		return [proc_list_get_avg $list_middles]
	} else {
		# odd
		set ind_middle [expr $len_list/2]
		return [lindex $list_sort $ind_middle]
	}
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

# subtract two lists
# input: list1, list2
# output: subtraction list1-list2, element by element 
proc proc_list_subtract_list {list1 list2} {
	set list_subt {}
	foreach el1 $list1 el2 $list2 {
		set subt [expr $el1-$el2]
		lappend list_subt $subt
	}
	return $list_subt
}

# calc sum of elements in list
# input: list_tar
# output: sum of elements in list
proc proc_list_sum_el {list_tar} {
	set sum_el 0
	foreach el $list_tar {
		set sum_el [expr $sum_el+$el]
	}
	return $sum_el
}

# returns avg val of 2 lists
# input: list1, list2
# output: avg of elements in list
proc proc_list1_list2_avg_el {list1 list2} {
	set list_ans {}
	foreach el1 $list1 el2 $list2 {
		set avg_val [expr ($el1+$el2)*0.5]
		lappend list_ans $avg_val
	}
	return $list_ans
}

# arranging lists
#################

# collecting a list of integers into sublists of continous elements
# input: list of sorted integers
# output: the list, divided into sublists, where in each sublist continuous elements appear
proc proc_list_to_contin_sublists {list_tar} {
	# initialize
	set list_list_ans {}
	set el_first [lindex $list_tar 0]
	set el_prev [expr $el_first-2]
	set list_sublist {}
	# 
	foreach el $list_tar {
		# checking if needs to start a new sublist
		if {[expr $el-$el_prev]>1} {
			lappend list_list_ans $list_sublist
			set list_sublist {}
			lappend list_sublist $el
		} else {
			lappend list_sublist $el
		}
		set el_prev $el
	}
	# last sublist
	lappend list_list_ans $list_sublist
	set list_list_ans [lrange $list_list_ans 1 end]
	return $list_list_ans
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

# creates a selection text for ranges of residues
# input: list with list of range pairs ({{beg1 end1} {beg2 end2} {beg3 end3} {...}})
# output: text to be used by atomselect command: resid beg1 to end1 beg2 to end2 beg3 to end3
proc proc_sel_txt_resid_range {list_pair_range} {
	set txt_sel "resid "
	foreach list_pair $list_pair_range {
		set resid_beg [lindex $list_pair 0]
		set resid_end [lindex $list_pair 1]
		set txt_sel "${txt_sel} ${resid_beg} to ${resid_end} "
	}
	return $txt_sel
}

# returns a list of nonbonded contacts in a param file (NBFIX) including distance
# input: file_param (charmm style, with NBFIX for non-bonded)
# output: list of contacts as resid1, resid2, dist
proc proc_contact_nonbond_dist_from_nbfix {file_param} {
	set file_in [open $file_param r]
	set list_triple_cont {}
	set is_read 0
	while {[gets $file_in line]>=0} {
		if {$is_read==1} {
			if {$line==""} {
				set is_read 0
				break
			}
			# only contact lines
			set resname1 [lindex $line 0]
			set resname2 [lindex $line 1]
			set dist_cont [lindex $line 3]
			set resid1 [proc_go_resname_to_resid $resname1]
			set resid2 [proc_go_resname_to_resid $resname2]
			if {$resid1<$resid2} {
				set resid_small $resid1
				set resid_large $resid2
			} else {
				set resid_small $resid2
				set resid_large $resid1
			}
			set list_cont_triple [list $resid_small $resid_large $dist_cont]
			lappend list_triple_cont $list_cont_triple
		}
		if {$line=="NBFIX"} {
			set is_read 1
		}
	}
	close $file_in
	return $list_triple_cont
}

# returns a list of nonbonded contacts in a param file (NBFIX)
# input: file_param (charmm style, with NBFIX for non-bonded)
# output: list of contacts as resid1, resid2
proc proc_contact_nonbond_from_nbfix {file_param} {
	set file_in [open $file_param r]
	set list_triple_cont {}
	set is_read 0
	while {[gets $file_in line]>=0} {
		if {$is_read==1} {
			if {$line==""} {
				set is_read 0
				break
			}
			# only contact lines
			set resname1 [lindex $line 0]
			set resname2 [lindex $line 1]
			set dist_cont [lindex $line 3]
			set resid1 [proc_go_resname_to_resid $resname1]
			set resid2 [proc_go_resname_to_resid $resname2]
			if {$resid1<$resid2} {
				set resid_small $resid1
				set resid_large $resid2
			} else {
				set resid_small $resid2
				set resid_large $resid1
			}
			set list_cont_triple [list $resid_small $resid_large]
			lappend list_triple_cont $list_cont_triple
		}
		if {$line=="NBFIX"} {
			set is_read 1
		}
	}
	close $file_in
	return $list_triple_cont
}

# from a list of nonbonded contacts for all molecule- returns only contacts between specified domains
# input: list_resid_dom1, list_resid_dom2
# input: list_list_cont_all
# output: the elements from list_list_cont_all which of only contacts between the sepcified domains
proc proc_contact_nonbond_dom1_dom2 {list_resid_dom1 list_resid_dom2 list_list_cont_all} {
	set list_list_cont_dom1_dom2 {}
	foreach list_cont $list_list_cont_all {
		set resid1 [lindex $list_cont 0]
		set resid2 [lindex $list_cont 1]
		if {([lsearch $list_resid_dom1 $resid1]>-1 && [lsearch $list_resid_dom2 $resid2]>-1) || ([lsearch $list_resid_dom1 $resid2]>-1 && [lsearch $list_resid_dom2 $resid1]>-1)} {
			lappend list_list_cont_dom1_dom2 $list_cont
		}
	}
	return $list_list_cont_dom1_dom2
}

# calc geometrical center of a list of Ca residues
# input: list of residue numbers
# input: mol_pdb: molecule in pdb
# output: geometrical center of the residue list
proc proc_center_geom_res_list {list_resnum mol_pdb} {
	set sel_res [atomselect $mol_pdb "resid $list_resnum"]
	set list_x_res [$sel_res get x]
	set list_y_res [$sel_res get y]
	set list_z_res [$sel_res get z]
	set x_avg [proc_list_get_avg $list_x_res]
	set y_avg [proc_list_get_avg $list_y_res]
	set z_avg [proc_list_get_avg $list_z_res]
	set list_center_geom [list $x_avg $y_avg $z_avg]
	$sel_res delete
	return $list_center_geom
}

# calc avg coor of given frames
# input: mol_target
# input: list_fr
# output: list of avg {x y z} coor ({{x} {y} {z}} where each sublist contains all atoms) 
proc proc_avg_coor_frames {mol_target list_fr} {
	set list_list_fr_atom_x {}
	set list_list_fr_atom_y {}
	set list_list_fr_atom_z {}
	# get all coor
	foreach fr $list_fr {
		set sel_fr [atomselect $mol_target "all" frame $fr]
		set list_x_fr [$sel_fr get x]
		set list_y_fr [$sel_fr get y]
		set list_z_fr [$sel_fr get z]
		lappend list_list_fr_atom_x $list_x_fr
		lappend list_list_fr_atom_y $list_y_fr
		lappend list_list_fr_atom_z $list_z_fr
		$sel_fr delete
	}
	set list_list_atom_fr_x [proc_list_invert_dimension $list_list_fr_atom_x]
	set list_list_atom_fr_y [proc_list_invert_dimension $list_list_fr_atom_y]
	set list_list_atom_fr_z [proc_list_invert_dimension $list_list_fr_atom_z]
	# calc avg
	set list_atom_avg_x {}
	set list_atom_avg_y {}
	set list_atom_avg_z {}
	foreach list_atom_fr_x $list_list_atom_fr_x {
		set avg_atom_x [proc_list_get_avg $list_atom_fr_x]
		lappend list_atom_avg_x $avg_atom_x
	}
	foreach list_atom_fr_y $list_list_atom_fr_y {
		set avg_atom_y [proc_list_get_avg $list_atom_fr_y]
		lappend list_atom_avg_y $avg_atom_y
	}
	foreach list_atom_fr_z $list_list_atom_fr_z {
		set avg_atom_z [proc_list_get_avg $list_atom_fr_z]
		lappend list_atom_avg_z $avg_atom_z
	}
	set list_list_all [list $list_atom_avg_x $list_atom_avg_y $list_atom_avg_z]
	return $list_list_all
}

## returns an atom index from resid 
# input: resid_tar
# input: pdb_tar
# output: index of the ca atom
proc proc_resid_to_ca_index {resid_tar pdb_tar} {
	set mol_proc [mol new $pdb_tar]
	set sel [atomselect $mol_proc "resid $resid_tar and name CA"]
	set ind_ca [$sel get index]
	$sel delete
	mol delete $mol_proc
	return $ind_ca
}

# vmd rep related
#################

# convert from color name to colorID
# input: color name
# ouptut: ColorID in VMD
proc proc_vmd_color_name_to_id {col_name} {
	set list_col_names {blue red grey orange yellow tan silver green white pink cyan purple lime mauve ochre iceblue black yellow2 yellow3 green2 green3 cyan2 cyan3 blue2 blue3 violet violet2 magenta magenta2 red2 red3 orange2 orange3}
	set list_col_id {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32}
	set ind_col_name [lsearch $list_col_names $col_name]
	set col_id [lindex $list_col_id $ind_col_name]
	return $col_id
}

###############################################################################################################
# read grid data
set list_line_setup_option [exec grep -n "Setup_Option" $FILE_NAME_OUTPUT]
set str_line_setup_option_1 [lindex $list_line_setup_option 0]
set str_line_setup_option_2 [lindex $list_line_setup_option 7]
set list_line_setup_option_1 [split $str_line_setup_option_1 :]
set list_line_setup_option_2 [split $str_line_setup_option_2 :]
set line_setup_option_1 [lindex $list_line_setup_option_1 0]
set line_setup_option_2 [lindex $list_line_setup_option_2 0]
set line_grid_1 [expr $line_setup_option_1+1]
set line_grid_2 [expr $line_setup_option_2+1]
set list_grid_1 [exec sed "${line_grid_1}q;d" $FILE_NAME_OUTPUT]
set list_grid_2 [exec sed "${line_grid_2}q;d" $FILE_NAME_OUTPUT]

# write to file
set file_name_x [proc_file_name_insert_str $FILE_NAME_PMF grid_x]
set file_name_x [proc_str_new_end $file_name_x txt]
set file_name_y [proc_file_name_insert_str $FILE_NAME_PMF grid_y]
set file_name_y [proc_str_new_end $file_name_y txt]
set file_out_x [open $file_name_x w]
set file_out_y [open $file_name_y w]
puts $file_out_x $list_grid_1
puts $file_out_y $list_grid_2
close $file_out_x
close $file_out_y

# process pmf data
set list_list_x_y_pmf [proc_file_2d_read_to_list $FILE_NAME_PMF]
#set list_list_x_y_pmf [proc_list_invert_dimension $list_list_y_x_pmf]

# find maxval
set list_xy_pmf_join [join $list_list_x_y_pmf]
set list_xy_pmf_sort [lsort -real -unique $list_xy_pmf_join]
set list_xy_pmf_sort [proc_list_clean_alpha $list_xy_pmf_sort]
set min_val [lindex $list_xy_pmf_sort 0]
set max_val [lindex $list_xy_pmf_sort end]

# aligns to min and sets infinity to max
set list_x_y_pmf_align {}
foreach list_x $list_list_x_y_pmf {
	set list_pmf_x {}
	foreach pmf_val $list_x {
		if {$pmf_val=="Infinity"} {
			set pmf_val $max_val
		}
		set pmf_val_align [expr $pmf_val-$min_val]
		lappend list_pmf_x $pmf_val_align
	}
	lappend list_x_y_pmf_align $list_pmf_x
}

# write to file
set file_name_pmf [proc_file_name_insert_str $FILE_NAME_PMF matplotlib]
set file_out [open $file_name_pmf w]
proc_write_list_el_per_line $list_x_y_pmf_align $file_out
close $file_out

#
exit



#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60_0_m46_nmp_lid_2d.pmf
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60_0_m46_pmf_2d_nmp_lid_exec.out
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60_0_m48_nmp_lid_2d.pmf
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60_0_m48_pmf_2d_nmp_lid_exec.out
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60_0_m50_nmp_lid_2d.pmf
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60_0_m50_pmf_2d_nmp_lid_exec.out
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m44_nmp_lid_2d.pmf
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m44_pmf_2d_nmp_lid_exec.out
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m46_nmp_lid_2d.pmf
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m46_pmf_2d_nmp_lid_exec.out
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m48_nmp_lid_2d.pmf
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m48_pmf_2d_nmp_lid_exec.out
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m50_nmp_lid_2d.pmf
#DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_12000_m60_0_m50_pmf_2d_nmp_lid_exec.out
