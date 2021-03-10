#!/bin/bash

# user-defined params
round=03
list_tmix=(2000 1000 13)
list_c1=(150 0 1)
list_c2=(0 0 1)
list_c3=(-100 15 10)
list_pdb=(GO_1akea lidmix)
file_grotop=GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed.grotop
file_morph=morph_3basin_temp.inp
file_run=run_morph_temp.sh
#path_genesis=/home/shinobuai/genesis-ver/genesis_GAT_CG_2018_merged_Cafemol_neweelmpi_20191219
#path_genesis=/home/shinobuai/genesis-ver/genesis_GAT_CG_2018_merged_Cafemol_neweelmpi_20200123/bin/atdyn
path_genesis=/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123

# check if directory already exists
if [[ -d "round${round}" ]]
then
	echo "directory exists"
	exit 1
fi

# only if directory does not exist
mkdir round${round}
cd round${round}

# create expanded list of parameters
# tmix
el_start=${list_tmix[0]}
d_el=${list_tmix[1]}
num_el=${list_tmix[2]}
el_now=$el_start
for ((i=0;i<$num_el;i++));
do
	list_tmix_all[$i]=$el_now
	el_now=$(echo "$el_now + $d_el" | bc)
done
# c1
el_start=${list_c1[0]}
d_el=${list_c1[1]}
num_el=${list_c1[2]}
el_now=$el_start
for ((i=0;i<$num_el;i++));
do
	list_c1_all[$i]=$el_now
	el_now=$(echo "$el_now + $d_el" | bc)
done
# c2
el_start=${list_c2[0]}
d_el=${list_c2[1]}
num_el=${list_c2[2]}
el_now=$el_start
for ((i=0;i<$num_el;i++));
do
	list_c2_all[$i]=$el_now
	el_now=$(echo "$el_now + $d_el" | bc)
done
# c3
el_start=${list_c3[0]}
d_el=${list_c3[1]}
num_el=${list_c3[2]}
el_now=$el_start
for ((i=0;i<$num_el;i++));
do
	list_c3_all[$i]=$el_now
	el_now=$(echo "$el_now + $d_el" | bc)
done

# create reverse pdb array
pdb1=${list_pdb[0]}
pdb2=${list_pdb[1]}
list_pdb_rev=(${pdb2} ${pdb1})

# do for each pdb-ref
for i in {0..1}
do
	pdb_start=${list_pdb[i]}
	pdb_ref=${list_pdb_rev[i]}
	pdb_start_nopre=${pdb_start//GO_/}
	pdb_ref_nopre=${pdb_ref//GO_/}
	# perform permutations on all tmix, cn
	for tmix_now in "${list_tmix_all[@]}"
	do
		tmix_txt=$tmix_now
		for c1_now in "${list_c1_all[@]}"
		do
			c1_txt=${c1_now//-/m}
			c1_txt=${c1_txt//./p}
			for c2_now in "${list_c2_all[@]}"
			do
				c2_txt=${c2_now//-/m}
				c2_txt=${c2_txt//./p}
				for c3_now in "${list_c3_all[@]}"
				do
					c3_txt=${c3_now//-/m}
					c3_txt=${c3_txt//./p}
					# here all variables are defined
					# .inp file
					file_morph_now=morph_${pdb_start_nopre}_${pdb_ref_nopre}_${tmix_txt}_${c1_txt}_${c2_txt}_${c3_txt}
					file_morph_inp=${file_morph_now}.inp
					cp ../$file_morph $file_morph_inp
					sed -i "s,ggggg,${file_grotop},g" $file_morph_inp
					sed -i "s,ppppp,${pdb_start},g" $file_morph_inp
					sed -i "s,rrrrr,${pdb_ref},g" $file_morph_inp
					sed -i "s,mmmmm,${pdb_start_nopre}-${pdb_ref_nopre},g" $file_morph_inp
					sed -i "s,xxxxx,${file_morph_now},g" $file_morph_inp
					sed -i "s,ttttt,${tmix_now},g" $file_morph_inp
					sed -i "s,aaaaa,${c1_now},g" $file_morph_inp
					sed -i "s,bbbbb,${c2_now},g" $file_morph_inp
					sed -i "s,ccccc,${c3_now},g" $file_morph_inp
					# .sh file
					file_morph_sh=${file_morph_now}.sh
					cp ../$file_run $file_morph_sh
					sed -i "s,ggggg,${path_genesis},g" $file_morph_sh
					sed -i "s,xxxxx,${file_morph_now},g" $file_morph_sh
				done
			done
		done
	done
done
cp ../setup-morph-runs.sh .

cd ..



