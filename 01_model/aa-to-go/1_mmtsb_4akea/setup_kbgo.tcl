# creates a pdb/psf files for go model
# input: pdb file in kbgo format (from mmtsb)
# output: pdb/psf files in kbgo (res names G1, G2, ..., creates pdb/psf files, center at the COM)
###############################################################################################################
set PDB_NAME GO_4akea
###############################################################################################################
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

# inserts a string into a txt file name
# input: file name XXX.YYY
# input: str_add
# output: XXX_str_add.YYY
proc proc_file_name_insert_str {file_name str_add} {
	set list_file_name [split $file_name .]
	set file_name_add [lindex $list_file_name 0]_$str_add.[lindex $list_file_name 1]
	return $file_name_add
}

# open a pdb file
# input: pdb_name
# output: molecule
proc proc_pdb_open {pdb_name} {
	set mol_pdb [mol new $pdb_name]
	return $mol_pdb
}

# create a list of integers from first to last
# input: int_first, int_last
# output: list of integers from int_first to int_last, including
proc proc_get_list_int_first_last {int_first int_last} {
	set list_out {}
	for {set int_now $int_first} {$int_now<=$int_last} {incr int_now} {
		lappend list_out $int_now
	}
	return $list_out
}

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

# display a list, line per element
# input: list_tar
# output (screen): elements of list, line per element
proc proc_puts_list_el_per_line {list_tar} {
	foreach el $list_tar {
		puts $el
	}
}

# finds max val in list
# input: list_tar 
# output: max val in list_tar 
proc proc_list_get_max {list_tar} {
	set list_sort [lsort -integer $list_tar]
	set val_max [lindex $list_sort end]
	return $val_max
} 

# finds min val in list
# input: list_tar 
# output: min val in list_tar 
proc proc_list_get_min {list_tar} {
	set list_sort [lsort -integer $list_tar]
	set val_min [lindex $list_sort 0]
	return $val_min
} 
###############################################################################################################
# read pdb
set pdb_name_all $PDB_NAME.pdb
puts $pdb_name_all
mol load pdb $pdb_name_all

# replace residue names with G1, G2, G3, ...
set sel_all [atomselect top "all"]
set list_residue [lsort -unique -integer [$sel_all get resid]]
foreach i $list_residue {
    set resname_go [format "G%d" $i]
    set res [atomselect top "resid $i" frame all]
    $res set resname $resname_go
}

$sel_all writepdb tmp.pdb

# generate PSF and PDB files
package require psfgen
resetpsf
set top_name $PDB_NAME.top
topology $top_name

segment PROT {
 first none
 last none
 pdb tmp.pdb
}
regenerate angles dihedrals
coordpdb tmp.pdb PROT

# move system origin to center of mass
$sel_all moveby [vecinvert [measure center $sel_all weight mass]]

# write psf and pdb files
set list_pdb_name [split $PDB_NAME _]
set pdb_name_new go_[lindex $list_pdb_name 1].pdb
set psf_name_new go_[lindex $list_pdb_name 1].psf
writepsf $psf_name_new
writepdb $pdb_name_new

$sel_all delete
exit
