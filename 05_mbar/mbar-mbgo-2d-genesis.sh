#!/bin/bash

# user-input parameters
###################################################################
file_md_log=files_mdlog.txt	# file with md .log file names
file_cvreal1=files_cvreal1.txt	# file with cv (e.g. dRMS) vs. timestep of the md simulations (files should be listed in the same order as "file_md_log") 
file_cvreal2=files_cvreal2.txt	# file with cv (e.g. dRMS) vs. timestep of the md simulations (files should be listed in the same order as "file_md_log") 
file_targets=files_targets.txt	# file with target parameter sets in the form: tmix, c1, c2, ..., cn (a row for a target set, can contain as many rows as desired)
file_mbar_multibasin_input_data=mbar_multibasin_input_data_temp.tcl 		# this script should be contained
file_mbar_multibasin_input_target=mbar_multibasin_input_target_temp.tcl		# "
file_data_align=data_align_zero_single_temp.tcl					# "
file_pmf_genesis_proc=pmf-2d-genesis-proc_temp.tcl				# "
file_pmf_genesis_matplotlib_proc=pmf_2d_genesis_matplotlib_temp.tcl
file_mbar_input=mbar_input_temp.inp						# "
file_pmf_input=pmf-input_temp.inp						# "
file_pmf2d_input=pmf2d-input_temp.inp						# "
path_genesis=/home/shinobuai/genesis-ver/genesis-gromacs-amber_temporary-mbar-20200110/bin	#GENESIS installation path
temperature=200		# temperature of the MBGO simulation
min_pmf1=30		# lower bound of pmf bins
max_pmf1=90		# upper bound of pmf bins
bin_num1=60		# number of pmf bins + 1
min_pmf2=80		# lower bound of pmf bins
max_pmf2=200		# upper bound of pmf bins
bin_num2=120		# number of pmf bins + 1
###################################################################

rm -f *fene
rm -f *weight
rm -f *pmf

# prepare permuted data
# replace with input file names in tcl script
echo mbar_multibasin_input_data.tcl
file_mbar_multibasin_input_data_exec=${file_mbar_multibasin_input_data//temp/exec}
cp $file_mbar_multibasin_input_data $file_mbar_multibasin_input_data_exec 
sed -i "s,xxxxx,${file_md_log},g" $file_mbar_multibasin_input_data_exec
./$file_mbar_multibasin_input_data_exec
wait
echo ""
echo mbar_multibasin_input_target.tcl
file_mbar_multibasin_input_target_exec=${file_mbar_multibasin_input_target//temp/exec}
cp $file_mbar_multibasin_input_target $file_mbar_multibasin_input_target_exec 
sed -i "s,xxxxx,${file_md_log},g" $file_mbar_multibasin_input_target_exec
sed -i "s,yyyyy,${file_targets},g" $file_mbar_multibasin_input_target_exec
./$file_mbar_multibasin_input_target_exec
wait
echo ""

###############################################################
# prepare cv-real files for pmf (change names)
# cvreal1
# find common name
num_files_cvreal1=$(wc -l < "$file_cvreal1")
file_cvreal_1=$(cat $file_cvreal1 | head -1 | tail -1)
file_cvreal_2=$(cat $file_cvreal1 | head -2 | tail -1)
file_cvreal_3=$(cat $file_cvreal1 | head -${num_files_cvreal1} | tail -1)
# 1-2
str_common_1_2=${file_cvreal_1:0:1}
char1=${file_cvreal_1:1:1}
char2=${file_cvreal_2:1:1}
ind=1
while [ $char1 == $char2 ]
do
	str_common_1_2=${str_common_1_2}${char1}
	let "ind=ind+1"
	char1=${file_cvreal_1:ind:1}
	char2=${file_cvreal_2:ind:1}
done
# 1-3
str_common_1_3=${file_cvreal_1:0:1}
char1=${file_cvreal_1:1:1}
char3=${file_cvreal_3:1:1}
ind=1
while [ $char1 == $char3 ]
do
	str_common_1_3=${str_common_1_3}${char1}
	let "ind=ind+1"
	char1=${file_cvreal_1:ind:1}
	char3=${file_cvreal_3:ind:1}
done
# 1-2-3
str_common_1_2_3=${str_common_1_2:0:1}
char2=${str_common_1_2:1:1}
char3=${str_common_1_3:1:1}
ind=1
len2=${#str_common_1_2}
len3=${#str_common_1_3}
if [ $len2 -lt $len3 ]; then
	min_len=$len2
else
	min_len=$len3
fi
while [[ $char2 == $char3 && $ind -lt $min_len ]];
do
	str_common_1_2_3=${str_common_1_2_3}${char2}
	let "ind=ind+1"
	char2=${str_common_1_2:ind:1}
	char3=${str_common_1_3:ind:1}
done
# prepare file
file_cvreal1_common=$(basename $str_common_1_2_3)
file_cvreal1_common=${file_cvreal1_common}_1
ind_file=1
echo cv-real file-name change
while read -r file_name_cvreal1;
do
	file_cv1_ind=${file_cvreal1_common}_${ind_file}.out
	cp $file_name_cvreal1 $file_cv1_ind
	echo copying $file_cv1_ind
	let "ind_file=ind_file+1"
done < $file_cvreal1
echo ""

# cvreal2
# find common name
num_files_cvreal2=$(wc -l < "$file_cvreal2")
file_cvreal_1=$(cat $file_cvreal2 | head -1 | tail -1)
file_cvreal_2=$(cat $file_cvreal2 | head -2 | tail -1)
file_cvreal_3=$(cat $file_cvreal2 | head -${num_files_cvreal2} | tail -1)
# 1-2
str_common_1_2=${file_cvreal_1:0:1}
char1=${file_cvreal_1:1:1}
char2=${file_cvreal_2:1:1}
ind=1
while [ $char1 == $char2 ]
do
	str_common_1_2=${str_common_1_2}${char1}
	let "ind=ind+1"
	char1=${file_cvreal_1:ind:1}
	char2=${file_cvreal_2:ind:1}
done
# 1-3
str_common_1_3=${file_cvreal_1:0:1}
char1=${file_cvreal_1:1:1}
char3=${file_cvreal_3:1:1}
ind=1
while [ $char1 == $char3 ]
do
	str_common_1_3=${str_common_1_3}${char1}
	let "ind=ind+1"
	char1=${file_cvreal_1:ind:1}
	char3=${file_cvreal_3:ind:1}
done
# 1-2-3
str_common_1_2_3=${str_common_1_2:0:1}
char2=${str_common_1_2:1:1}
char3=${str_common_1_3:1:1}
ind=1
len2=${#str_common_1_2}
len3=${#str_common_1_3}
if [ $len2 -lt $len3 ]; then
	min_len=$len2
else
	min_len=$len3
fi
while [[ $char2 == $char3 && $ind -lt $min_len ]];
do
	str_common_1_2_3=${str_common_1_2_3}${char2}
	let "ind=ind+1"
	char2=${str_common_1_2:ind:1}
	char3=${str_common_1_3:ind:1}
done
# prepare file
file_cvreal2_common=$(basename $str_common_1_2_3)
file_cvreal2_common=${file_cvreal2_common}_2
ind_file=1
echo cv-real file-name change
while read -r file_name_cvreal2;
do
	file_cv2_ind=${file_cvreal2_common}_${ind_file}.out
	cp $file_name_cvreal2 $file_cv2_ind
	echo copying $file_cv2_ind
	let "ind_file=ind_file+1"
done < $file_cvreal2
echo ""

# 2d
num_file=$ind_file
ind_file=1
file_cvreal12_common=${file_cvreal1_common}2
for ((ind_file=1;$ind_file<$num_file;ind_file++)) ;
do
	file_cv1_ind=${file_cvreal1_common}_${ind_file}.out
	file_cv2_ind=${file_cvreal2_common}_${ind_file}.out
	file_cv12_ind=${file_cvreal12_common}_${ind_file}.out
	awk '{print $2}' $file_cv2_ind > tmp.out
	paste $file_cv1_ind tmp.out > $file_cv12_ind
done

#########################################################
# mbar and pmf
# creating mbar_input files as the number of target sets
echo mbar and pmf
while read -r line;
do
	# create a string with target params
	IFS=" " read -r -a list_target_param <<< "$line"
	echo targets $line
	str_param=${list_target_param[0]}
	len_list_target_param=${#list_target_param[@]}
	for ((i=1;i<$len_list_target_param;i++));
	do
		c_i=${list_target_param[$i]}
		c_i_txt=${c_i//-/m}
		c_i_txt=${c_i_txt//./p}
		str_param=${str_param}_${c_i_txt}
	done
	# MBAR
	# create mbar input files
	file_input_mbar_target=${file_mbar_input//temp*/exec_${str_param}.inp}
	cp $file_mbar_input $file_input_mbar_target
	# replace content of mbar-input file
	# cv file
	file_cv_last=$(ls -rt *permute*out | tail -n 1)
	file_cv_common=${file_cv_last%_*}
	sed -i "s,aaaaa,${file_cv_common},g" $file_input_mbar_target
	# target files 
	file_target_last=$(ls -rt *target*out | tail -n 1)
	file_target_common=${file_target_last//target*/target}
	file_target_common_target=${file_target_common}_${str_param}
	sed -i "s,bbbbb,${file_target_common_target},g" $file_input_mbar_target
	# other param
	sed -i "s,ttttt,${temperature},g" $file_input_mbar_target
	num_replicas=$(wc -l < "$file_md_log")
	sed -i "s,nnnnn,${num_replicas},g" $file_input_mbar_target
	file_input_mbar_target_out=${file_input_mbar_target//.inp/.out}
	# execute mbar
	echo writing $file_input_mbar_target_out
	${path_genesis}/mbar_analysis $file_input_mbar_target > $file_input_mbar_target_out
	# PMF

	# 1d-cv1
	# create pmf input files
	file_input_pmf_target=${file_pmf_input//temp*/exec_1_${str_param}.inp}
	cp $file_pmf_input $file_input_pmf_target
	# replace content of pmf-input file
	file_target_common_target_1=${file_target_common_target}_1
	sed -i "s,aaaaa,${file_cvreal1_common},g" $file_input_pmf_target
	sed -i "s,bbbbb,${file_target_common_target},g" $file_input_pmf_target
	sed -i "s,ccccc,${file_target_common_target_1},g" $file_input_pmf_target
	sed -i "s,nnnnn,${num_replicas},g" $file_input_pmf_target
	sed -i "s,ttttt,${temperature},g" $file_input_pmf_target
	sed -i "s,mmmmm,${min_pmf1},g" $file_input_pmf_target
	sed -i "s,xxxxx,${max_pmf1},g" $file_input_pmf_target
	sed -i "s,iiiii,${bin_num1},g" $file_input_pmf_target
	# run pmf_analysis
	file_input_pmf_target_out=${file_input_pmf_target//.inp/.out}
	echo writing $file_input_pmf_target_out for cv-1
	${path_genesis}/pmf_analysis $file_input_pmf_target > $file_input_pmf_target_out
	# align to 0
	file_data_align_exec=${file_data_align//temp/exec}
	cp $file_data_align $file_data_align_exec
	file_pmf_target=${file_target_common_target}_1.pmf
	sed -i "s,xxxxx,${file_pmf_target},g" $file_data_align_exec
	echo "align to 0 cv1"
	./$file_data_align_exec

	# 1d-cv2
	# create pmf input files
	file_input_pmf_target=${file_pmf_input//temp*/exec_2_${str_param}.inp}
	cp $file_pmf_input $file_input_pmf_target
	# replace content of pmf-input file
	file_target_common_target_2=${file_target_common_target}_2
	sed -i "s,aaaaa,${file_cvreal2_common},g" $file_input_pmf_target
	sed -i "s,bbbbb,${file_target_common_target},g" $file_input_pmf_target
	sed -i "s,ccccc,${file_target_common_target_2},g" $file_input_pmf_target
	sed -i "s,nnnnn,${num_replicas},g" $file_input_pmf_target
	sed -i "s,ttttt,${temperature},g" $file_input_pmf_target
	sed -i "s,mmmmm,${min_pmf2},g" $file_input_pmf_target
	sed -i "s,xxxxx,${max_pmf2},g" $file_input_pmf_target
	sed -i "s,iiiii,${bin_num2},g" $file_input_pmf_target
	# run pmf_analysis
	file_input_pmf_target_out=${file_input_pmf_target//.inp/.out}
	echo writing $file_input_pmf_target_out for cv-2
	${path_genesis}/pmf_analysis $file_input_pmf_target > $file_input_pmf_target_out
	# align to 0
	file_data_align_exec=${file_data_align//temp/exec}
	cp $file_data_align $file_data_align_exec
	file_pmf_target=${file_target_common_target}_2.pmf
	sed -i "s,xxxxx,${file_pmf_target},g" $file_data_align_exec
	echo "align to 0 cv2"
	./$file_data_align_exec

	# 2d
	# create pmf input files
	file_input_pmf_target=${file_pmf2d_input//temp*/exec_${str_param}.inp}
	cp $file_pmf2d_input $file_input_pmf_target
	# replace content of mbar-input file
	sed -i "s,aaaaa,${file_cvreal12_common},g" $file_input_pmf_target
	sed -i "s,bbbbb,${file_target_common_target},g" $file_input_pmf_target
	sed -i "s,nnnnn,${num_replicas},g" $file_input_pmf_target
	sed -i "s,ttttt,${temperature},g" $file_input_pmf_target
	sed -i "s,mmmmm,${min_pmf1},g" $file_input_pmf_target
	sed -i "s,xxxxx,${max_pmf1},g" $file_input_pmf_target
	sed -i "s,iiiii,${bin_num1},g" $file_input_pmf_target
	sed -i "s,lllll,${min_pmf2},g" $file_input_pmf_target
	sed -i "s,yyyyy,${max_pmf2},g" $file_input_pmf_target
	sed -i "s,jjjjj,${bin_num2},g" $file_input_pmf_target
	# run pmf_analysis
	file_input_pmf_target_out=${file_input_pmf_target//.inp/.out}
	echo writing $file_input_pmf_target_out
	${path_genesis}/pmf_analysis $file_input_pmf_target > $file_input_pmf_target_out
	# align to 0
	file_pmf_genesis_proc_exec=${file_pmf_genesis_proc//temp/exec}
	cp $file_pmf_genesis_proc $file_pmf_genesis_proc_exec
	file_pmf_target=${file_target_common_target}_2d.pmf
	sed -i "s,xxxxx,${file_pmf_target},g" $file_pmf_genesis_proc_exec
	sed -i "s,yyyyy,${file_input_pmf_target_out},g" $file_pmf_genesis_proc_exec
	file_pmf_genesis_matplotlib_proc_exec=${file_pmf_genesis_matplotlib_proc//temp/exec}
	cp $file_pmf_genesis_matplotlib_proc $file_pmf_genesis_matplotlib_proc_exec
	sed -i "s,xxxxx,${file_pmf_target},g" $file_pmf_genesis_matplotlib_proc_exec
	sed -i "s,yyyyy,${file_input_pmf_target_out},g" $file_pmf_genesis_matplotlib_proc_exec
	echo "process 2d pmf"
	./$file_pmf_genesis_proc_exec
	./$file_pmf_genesis_matplotlib_proc_exec
	echo ""
done < $file_targets

for ((i=1;$i<$ind_file;i++));
do
	rm -f ${file_cvreal1_common}_${i}.out
	rm -f ${file_cvreal2_common}_${i}.out
	rm -f ${file_cvreal12_common}_${i}.out
done
rm -f tmp*out
