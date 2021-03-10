#!/bin/bash

# user-input parameters
###################################################################
file_pmf_2d=files_pmf_2d.txt
script_pmf_to_hist_2d=pmf_to_hist_2d_temp.tcl
script_kmeans=kmeans_clust_hist2d_predef_temp.tcl
list_center_kmeans="{{46 111} {65 111} {73 147}}"
file_out=kmeans.out
TEMP=200
###################################################################

# convert pmf to hist
echo "running ${script_pmf_to_hist_2d}"
while read -r line;
do
	file_name_in=$line
	script_pmf_to_hist_2d_exec=${script_pmf_to_hist_2d//temp/exec}
	cp $script_pmf_to_hist_2d $script_pmf_to_hist_2d_exec
	sed -i "s,xxxxx,${file_name_in},g" $script_pmf_to_hist_2d_exec
	sed -i "s,ttttt,${TEMP},g" $script_pmf_to_hist_2d_exec
	./$script_pmf_to_hist_2d_exec
done < $file_pmf_2d
echo ""

rm -f $file_out
touch $file_out
# calc ratio using kmeans
echo "running ${script_kmeans}"
echo ""
while read -r line;
do
	file_pmf_basename=$(basename $line)
	file_pmf_hist=${file_pmf_basename//.pmf/_hist.pmf}
	script_kmeans_exec=${script_kmeans//temp/exec}
	cp $script_kmeans $script_kmeans_exec
	sed -i "s,xxxxx,${file_pmf_hist},g" $script_kmeans_exec
	sed -i "s,ccccc,${list_center_kmeans},g" $script_kmeans_exec
	echo $file_pmf_hist
	./$script_kmeans_exec >> $file_out
	echo ""
done < $file_pmf_2d
: <<'END'
paste -d ";" ${file_pmf_1} ${file_pmf_2} ${file_pmf_2d} > file_temp_all.txt
while read -r line;
do
	# preparing input files
	IFS=";" read -r -a list_files_all <<< "$line"
	file_name_1=${list_files_all[0]}
	file_name_2=${list_files_all[1]}
	file_name_2d=${list_files_all[2]}
	file_name_1_out=$(basename $file_name_1)
	file_name_2_out=$(basename $file_name_2)
	file_name_2d_out=$(basename $file_name_2d)
	file_name_1_out=${file_name_1_out//.pmf/_max.pmf}
	file_name_2_out=${file_name_2_out//.pmf/_max.pmf}
	file_name_2d_out=${file_name_2d_out//.pmf/_hist.pmf}
	# run script
	script_basin_ratio_hist_2d_exec=${script_basin_ratio_hist_2d//temp/exec}
	cp $script_basin_ratio_hist_2d $script_basin_ratio_hist_2d_exec
	sed -i "s,fffff,${file_name_2d_out},g" $script_basin_ratio_hist_2d_exec
	sed -i "s,xxxxx,${file_name_1_out},g" $script_basin_ratio_hist_2d_exec
	sed -i "s,yyyyy,${file_name_2_out},g" $script_basin_ratio_hist_2d_exec
	./$script_basin_ratio_hist_2d_exec
done < file_temp_all.txt
END
