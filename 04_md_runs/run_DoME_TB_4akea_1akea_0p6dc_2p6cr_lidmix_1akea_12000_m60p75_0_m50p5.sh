#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -pe ompi8 8
#$ -q q2.q
#$ -j y

rm -i *.rst *.dcd

# set the number of OpenMP threads
export OMP_NUM_THREADS=2
ulimit -c 0

#echo "running MD"
#mpirun -np 4 -npernode 4 /home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/atdyn DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.inp | tee DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.out
#wait
#echo "done MD"

echo "runnning dRMS"
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/drms_analysis drms_to_1akea_4akea.inp | tee drms_to_1akea_4akea.out
wait
# separating drms
./key-mult-single_exec.tcl
# change names
mv DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.drms DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1_1.drms
mv DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_2.drms DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_2_1.drms
mv DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.drms DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.drms
echo "done dRMS"

echo "running theta-nmp/lid"
/home/shinobuai/usr/local/bin/vmd -dispdev text -e theta_nmp_exec.tcl | tee theta_nmp_exec.out
wait
/home/shinobuai/usr/local/bin/vmd -dispdev text -e theta_lid_exec.tcl | tee theta_lid_exec.out
wait
# changing names for pmf
awk '{print $2}' ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.out > tmp.out
paste ang-nmp_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.out tmp.out > ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.out
mv ang-nmp_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.out ang-nmp_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.out
mv ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.out ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.out
# making half-nmp-lid
cp ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.out ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_half1_1.out
cp ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.out ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_half2_1.out
line_num_fr=$(wc -l < "ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_half1_1.out")
line_half1_end=$(echo "$line_num_fr/2" | bc)
line_half2_start=$(echo "$line_half1_end+1" | bc)
sed -i "${line_half2_start},${line_num_fr}d" ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_half1_1.out
sed -i "1,${line_half1_end}d" ang-nmp_ang-lid_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_half2_1.out
echo "done theta-nmp-lid"

echo "running pmf drms 1d"
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_1d_1_exec.inp | tee pmf_1d_1_exec.out
wait
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_1d_2_exec.inp | tee pmf_1d_2_exec.out
wait
# align to zero
./data_align_drms1_exec.inp
./data_align_drms2_exec.inp
wait
echo "done pmf drms 1d"

echo "running pmf drms 2d"
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_2d_drms_exec.inp | tee pmf_2d_drms_exec.out
wait
./pmf_2d_genesis_proc_drms_exec.tcl
wait
./pmf_2d_genesis_matplotlib_proc_drms_exec.tcl
wait
echo "done pmf drms 2d"

echo "running pmf 1d nmp/lid"
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_1d_nmp_exec.inp | tee pmf_1d_nmp_exec.out
wait
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_1d_lid_exec.inp | tee pmf_1d_lid_exec.out
wait
# align to zero
./data_align_nmp_exec.inp
./data_align_lid_exec.inp
wait
echo "done pmf 1d nmp/lid"

echo "running pmf 2d nmp/lid"
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_2d_nmp_lid_exec.inp | tee pmf_2d_nmp_lid_exec.out
wait
./pmf_2d_genesis_proc_nmplid_exec.tcl
wait
./pmf_2d_genesis_matplotlib_proc_nmplid_exec.tcl
wait
echo "done pmf 2d nmp/lid"

echo "running pmf 2d nmp/lid half"
# half1
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_2d_nmp_lid_half1_exec.inp | tee pmf_2d_nmp_lid_half1_exec.out
wait
./pmf_2d_genesis_proc_nmplid_half1_exec.tcl
wait
./pmf_2d_genesis_matplotlib_proc_nmplid_half1_exec.tcl
#wait
echo "done pmf 2d nmp/lid half"
# half2
/home/shinobuai/genesis-ver/genesis-gat_cg_merged_final-mpiv400-20200123/bin/pmf_analysis pmf_2d_nmp_lid_half2_exec.inp | tee pmf_2d_nmp_lid_half2_exec.out
wait
./pmf_2d_genesis_proc_nmplid_half2_exec.tcl
wait
./pmf_2d_genesis_matplotlib_proc_nmplid_half2_exec.tcl
#wait
echo "done pmf 2d nmp/lid half"


#vmd -dispdev text -e theta_nmp_exec.tcl | tee theta_nmp_exec.out
#export PATH="$PATH:/home/shinobuai/usr/local/bin"
		# join for pmf 2d
