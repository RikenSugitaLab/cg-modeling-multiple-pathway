# calc ang between COM of 2 groups of residues (batch)
# input: pdb, psf, dcd
# input: FILE_MASS: file with masses of AA: AA-name, mass (2col)
# param: TXT_SEL_1 (2, 3), selection text of residues to be included in each "point"
# param: PDB_AA_NAME: aa pdb file for residue name
# param: NAME_ANG (for output)
# output: fr per angle between COM of each group
###############################################################################################################
set PDB_NAME ../../GO_1akea.pdb
set PSF_NAME ../../GO_1akea.psf
set DCD_NAME DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.dcd
set FILE_MASS /home/shinobuai/cg_mix/adk/11-multibasin-mbar/03-mdruns-manual/scripts/mass-res.txt
set TXT_SEL_1 "resid 115 to 125"
set TXT_SEL_2 "resid 90 to 100"
set TXT_SEL_3 "resid 35 to 55"
#set TXT_SEL_1 "resid 179 to 185"
#set TXT_SEL_2 "resid 115 to 125"
#set TXT_SEL_3 "resid 125 to 153"
set PDB_AA_NAME /home/shinobuai/cg_mix/adk/11-multibasin-mbar/03-mdruns-manual/scripts/4ake_A.pdb
set SCRIPT_NAME ang-nmp
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

# finds difference between 2 strings with el separated by _ or -
# input: str1, str2 with components separated by _ or -, only one element is different between them
# output: only the different parts of the strings in a 2-element list
proc proc_str_diff_underscore {str1 str2} {
	set str1_all_under [string map {- _} $str1]
	set str2_all_under [string map {- _} $str2]
	set list_str1 [split $str1_all_under "_"]
	set list_str2 [split $str2_all_under "_"]
	foreach el1 $list_str1 el2 $list_str2 {
		if {$el1!=$el2} {
			set list_diff [list $el1 $el2]
		}
	}
	return $list_diff
}

# finds common parts of 2 str, each separated to elements by _ or -
# input: str1, str2 with components separated by _ or -
# output: only the common parts of the strings, sep by _
proc proc_str_common_underscore {str1 str2} {
	set str1_all_under [string map {- _} $str1]
	set str2_all_under [string map {- _} $str2]
	set list_str1 [split $str1_all_under "_"]
	set list_str2 [split $str2_all_under "_"]
	set list_str_common {}
	foreach el1 $list_str1 el2 $list_str2 {
		if {$el1==$el2} {
			lappend list_str_common $el1
		}
	}
	set str_common [join $list_str_common _]
	return $str_common
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

# converts a number to a str only (no -/+, decimal points)
# input: num_tar (e.g. -1.3)
# output: number with minux sign replaced by m, decimal point replaced by "p" (-1.3 -> m1p3)
proc proc_num_to_str {num_tar} {
	set list_str_split [split $num_tar .]
	set num_tar_1 [lindex $list_str_split 0]
	set num_tar_2 [lindex $list_str_split 1]
	if {$num_tar<0} {
		set num_str "m${num_tar_1}p${num_tar_2}"
	} else {
		set num_str "${num_tar_1}p${num_tar_2}"
	}
	return $num_str
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

# remove all instances of str_rem from list
# input: list_tar
# input: str_rem
# output: list_tar without str_rem
proc proc_list_rem_el_tar {list_tar str_rem} {
	set list_ans {}
	foreach el $list_tar {
		if {$el!=$str_rem} {
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

# subtract a const num from each el in list
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

# calc sum of all elements in list
# input: list_tar
# output: sum of all elements in list_tar
proc proc_list_get_sum {list_tar} {
	set sum_el 0
	foreach el $list_tar {
		set sum_el [expr $sum_el+$el]
	}
	return $sum_el
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

# calc avg of elements in list, excluding "Infinity" values
# input: list_tar with possible "Infinity" values
# output: avg val in list, ignoring "Infinity" values
proc proc_list_get_avg_no_infinity {list_tar} {
	set sum_el 0
	set num_el 0
	foreach el $list_tar {
		if {$el!="Infinity"} {
			set sum_el [expr $sum_el+$el]
			incr num_el
		}
	}
	set avg_list [expr $sum_el*1.0/$num_el]
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

# calc std of elements in list, excluding "Infinity" values
# input: list_tar with possible "Infinity" values
# output: std of list, ignoring "Infinity" values
proc proc_list_get_std_no_infinity {list_tar} {
	# delete "Inifinity"
	set list_tar [proc_list_rem_el_tar $list_tar "Infinity"]
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

# calc standard error of elements in list, excluding "Infinity" values
# input: list_tar with possible "Infinity" values
# output: se of list, ignoring "Infinity" values
proc proc_list_get_se_no_infinity {list_tar} {
	set list_tar [proc_list_rem_el_tar $list_tar "Infinity"]
	set std_list [proc_list_get_std_no_infinity $list_tar]
	set se_list [expr $std_list*1.0/sqrt([llength $list_tar])]
	return $se_list
}

# returns val of a given key key-val paired lists
# input: list_key, list_val
# input: key_tar
# output: val of the element located at same position of key_tar
proc proc_key_val_get_val {list_key list_val key_tar} {
	set ind_key [lsearch $list_key $key_tar]
	set val_of_key [lindex $list_val $ind_key]
	return $val_of_key
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
# read mass file
set list_aa_name [proc_file_read_col_n $FILE_MASS 0]
set list_aa_mass [proc_file_read_col_n $FILE_MASS 1]

# list of masses for atoms in each group
set mol_aa [mol new $PDB_AA_NAME]
set mol_now [mol new $PDB_NAME]
set sel_group_1 [atomselect $mol_now $TXT_SEL_1]
set sel_group_2 [atomselect $mol_now $TXT_SEL_2]
set sel_group_3 [atomselect $mol_now $TXT_SEL_3]
# G1
set list_mass_group_1 {}
foreach resid1 [$sel_group_1 get resid] {
	set sel_aa_resid1 [atomselect $mol_aa "resid $resid1 and name CA"]
	set resname_resid1 [$sel_aa_resid1 get resname]
	set mass_resid1 [proc_key_val_get_val $list_aa_name $list_aa_mass $resname_resid1]
	lappend list_mass_group_1 $mass_resid1
	$sel_aa_resid1 delete
}
# G2
set list_mass_group_2 {}
foreach resid2 [$sel_group_2 get resid] {
	set sel_aa_resid2 [atomselect $mol_aa "resid $resid2 and name CA"]
	set resname_resid2 [$sel_aa_resid2 get resname]
	set mass_resid2 [proc_key_val_get_val $list_aa_name $list_aa_mass $resname_resid2]
	lappend list_mass_group_2 $mass_resid2
	$sel_aa_resid2 delete
}
# G3
set list_mass_group_3 {}
foreach resid3 [$sel_group_3 get resid] {
	set sel_aa_resid3 [atomselect $mol_aa "resid $resid3 and name CA"]
	set resname_resid3 [$sel_aa_resid3 get resname]
	set mass_resid3 [proc_key_val_get_val $list_aa_name $list_aa_mass $resname_resid3]
	lappend list_mass_group_3 $mass_resid3
	$sel_aa_resid3 delete
}
# sum of masses for each group
set sum_mass_group1 [proc_list_get_sum $list_mass_group_1]
set sum_mass_group2 [proc_list_get_sum $list_mass_group_2]
set sum_mass_group3 [proc_list_get_sum $list_mass_group_3]
# ending
$sel_group_1 delete
$sel_group_2 delete
$sel_group_3 delete
mol delete $mol_aa
mol delete $mol_now


	# file_out
	set dcd_no_path [proc_file_name_no_path $DCD_NAME]
	#set file_name_out [proc_file_out_name_script_dcd_param $NAME_ANG]
	set file_name_out [proc_file_out_name_script_dcd]
	set file_out [open $file_name_out w]
	# open traj
	set mol_now [proc_dcd_open $PDB_NAME $PSF_NAME $DCD_NAME]
	set num_fr [molinfo $mol_now get numframes]
	for {set what_fr 1} {$what_fr<$num_fr} {incr what_fr} {
		puts "$what_fr"
		set sel_group_1 [atomselect $mol_now $TXT_SEL_1 frame $what_fr]
		set sel_group_2 [atomselect $mol_now $TXT_SEL_2 frame $what_fr]
		set sel_group_3 [atomselect $mol_now $TXT_SEL_3 frame $what_fr]
		# get coor
		set list_x_g1 [$sel_group_1 get x]
		set list_x_g2 [$sel_group_2 get x]
		set list_x_g3 [$sel_group_3 get x]
		set list_y_g1 [$sel_group_1 get y]
		set list_y_g2 [$sel_group_2 get y]
		set list_y_g3 [$sel_group_3 get y]
		set list_z_g1 [$sel_group_1 get z]
		set list_z_g2 [$sel_group_2 get z]
		set list_z_g3 [$sel_group_3 get z]
		# calc com per group
		# numerator
		set prod_scal_x_g1_mass [proc_vec_scalar_prod $list_x_g1 $list_mass_group_1]
		set prod_scal_x_g2_mass [proc_vec_scalar_prod $list_x_g2 $list_mass_group_2]
		set prod_scal_x_g3_mass [proc_vec_scalar_prod $list_x_g3 $list_mass_group_3]
		set prod_scal_y_g1_mass [proc_vec_scalar_prod $list_y_g1 $list_mass_group_1]
		set prod_scal_y_g2_mass [proc_vec_scalar_prod $list_y_g2 $list_mass_group_2]
		set prod_scal_y_g3_mass [proc_vec_scalar_prod $list_y_g3 $list_mass_group_3]
		set prod_scal_z_g1_mass [proc_vec_scalar_prod $list_z_g1 $list_mass_group_1]
		set prod_scal_z_g2_mass [proc_vec_scalar_prod $list_z_g2 $list_mass_group_2]
		set prod_scal_z_g3_mass [proc_vec_scalar_prod $list_z_g3 $list_mass_group_3]
		# divide by mass sum
		set com_x_g1 [expr $prod_scal_x_g1_mass*1.0/$sum_mass_group1]
		set com_x_g2 [expr $prod_scal_x_g2_mass*1.0/$sum_mass_group2]
		set com_x_g3 [expr $prod_scal_x_g3_mass*1.0/$sum_mass_group3]
		set com_y_g1 [expr $prod_scal_y_g1_mass*1.0/$sum_mass_group1]
		set com_y_g2 [expr $prod_scal_y_g2_mass*1.0/$sum_mass_group2]
		set com_y_g3 [expr $prod_scal_y_g3_mass*1.0/$sum_mass_group3]
		set com_z_g1 [expr $prod_scal_z_g1_mass*1.0/$sum_mass_group1]
		set com_z_g2 [expr $prod_scal_z_g2_mass*1.0/$sum_mass_group2]
		set com_z_g3 [expr $prod_scal_z_g3_mass*1.0/$sum_mass_group3]
		# calc ang
		set list_com_g1 [list $com_x_g1 $com_y_g1 $com_z_g1]
		set list_com_g2 [list $com_x_g2 $com_y_g2 $com_z_g2]
		set list_com_g3 [list $com_x_g3 $com_y_g3 $com_z_g3]
		set ang_com [proc_point_ang $list_com_g1 $list_com_g2 $list_com_g3]
		# 
		puts $file_out "$what_fr\t$ang_com"
		# end
		$sel_group_1 delete
		$sel_group_2 delete
		$sel_group_3 delete
	}
	mol delete $mol_now
	close $file_out



# end
exit








