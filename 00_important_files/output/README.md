GENESIS md output files:  
#######################  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.out: sample GENESIS .out file  

* output files for MD simulations with final mixing parameters (separated into 3 parts), lidmix/nmpmix=LID/NMP-closing pathway, 1akea/4akea=Closed/Open initial structure  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_13000_m60p28_0_m50p0_41_43_45_rest.out
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_13000_m60p28_0_m50p0_41_43_45_rest.out
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_1akea_10850_m59p5_0_m13p8_74_75_77_rest.out
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_4akea_10850_m59p5_0_m13p8_74_75_77_rest.out

GENESIS analysis output files:  
#############################  
* drms_analysis sample output:   
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_1.drms  

* drms_analysis output for simulations with final mixing parameters. lidmix/nmpmix=LID/NMP-closing pathway, 1akea/4akea=Closed/Open initial structure  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_13000_m60p28_0_m50p0_41_43_45_1_1_contin.drms  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_13000_m60p28_0_m50p0_41_43_45_1_1_contin.drms  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_1akea_10850_m59p5_0_m13p8_74_75_77_1_1_contin.drms  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_4akea_10850_m59p5_0_m13p8_74_75_77_1_1_contin.drms  

* pmf_analysis sample output files (from pmf_analysis tool)  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_ang_lid_1d.pmf: 1D pmf on angle (LID) data
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_drms_1d_1.pmf: 1D pmf calculation on dRMS data
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_nmp_lid_2d.pmf: 2D pmf calculation on angle data
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5_drms_2d.pmf: 2D pmf calculation on dRMS data 

* 2D pmf output files in LID/NMP angle space for MD simulations with the final mixing parameters. lidmix/nmpmix=LID/NMP-closing pathway, 1akea/4akea=Closed/Open initial structure.
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_13000_m60p28_0_m50p0_41_43_45_nmp_lid_2d_matplotlib.pmf
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_13000_m60p28_0_m50p0_41_43_45_nmp_lid_2d_matplotlib.pmf
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_1akea_10850_m59p5_0_m13p8_74_75_77_nmp_lid_2d_matplotlib.pmf
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_4akea_10850_m59p5_0_m13p8_74_75_77_nmp_lid_2d_matplotlib.pmf

* mbar_analysis  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_xxx_12000_xxx_0_m50p5_ene_permute_6.out: sample output file for calculating energies of simulation #6 with conditions of all other simulations in the series (required for MBAR)
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_xxx_12000_xxx_0_m50p5_ene_target_14000_m60p80_0_m49p7_9.out: output file for calculating energies of simulation #9 under conditions of target (unsimulated ) parameters (Tmix=14000, C1=-60.80, C2=0, C3=-49.7) 

* kmeans_clustering output files assinging each frame to a cluster, for MD simulations with final mixing parameters. lidmix/nmpmix=LID/NMP-closing pathway, basin1/2/3=Open/Closed/Intermediate basins
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin1.idx
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin2.idx
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin3.idx
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin1.idx 
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin2.idx
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin3.idx

Other analysis scripts:   
#######################  
* Qval (fraction of native contacts) for MD simulations with final mixing parameters. lidmix/nmpmix=LID/NMP-closing pathway, basin1/2/3=Open/Closed/Intermediate basins
qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin1_basin1.out
qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin2_basin2.out
qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin3_basin3.out
qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin1_basin1.out
qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin2_basin2.out
qval-ind-uniq-grotop_DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_both_10850_m59p5_0_m13p8-74-75-77-basin3_basin3.out
* sample output file calculating LID/NMP angle:  
theta_lid_exec.out  
* sample output file for kmenas clustering of 2D pmf data into three centers for the Open, Closed, and the LID-closing intermediate basins  
kmeans.out  
