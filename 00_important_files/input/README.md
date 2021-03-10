GENESIS .inp files for running MD simulations in the triple basin potential:  
##################  
* Sample input file:   
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.inp  

* Input files for simulations with final mixing parameters (runs were concatenated into 3 parts), lidmix/nmpmix=LID/NMP-closing pathway, 1akea/4akea=initial structure (Closed/Open)  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_13000_m60p28_0_m50p0_part1.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_13000_m60p28_0_m50p0_part2.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_13000_m60p28_0_m50p0_part3.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_13000_m60p28_0_m50p0_part1.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_13000_m60p28_0_m50p0_part2.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_4akea_13000_m60p28_0_m50p0_part3.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_1akea_10850_m59p5_0_m13p8_part1.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_1akea_10850_m59p5_0_m13p8_part2.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_1akea_10850_m59p5_0_m13p8_part3.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_4akea_10850_m59p5_0_m13p8_part1.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_4akea_10850_m59p5_0_m13p8_part2.inp  
DoME_TB_4akea_1akea_0p6dc_2p6cr_nmpmix_4akea_10850_m59p5_0_m13p8_part3.inp  

Analysis .inp files for GENESIS analysis_tools  
###################  
* pmf_analysis files:   
pmf_1d_1_exec.inp: 1D pmf in dRMS space  
pmf_1d_lid_exec.inp: 1D pmf in LID angle space  
pmf_2d_drms_exec.inp: 2D pmf in dRMS space 
pmf_2d_nmp_lid_exec.inp: 2D pmf in LID/NMP angle space 
pmf2d-input_exec_14000_m60p80_0_m49p7.inp: 2D pmf using weights calculated with MBAR  

* mbar_analysis:  
mbar_input_exec_14000_m60p80_0_m49p7.inp  

* drms_analysis  
drms_to_1akea_4akea.inp  

* kmeans_clustering sample .inp file  
clustering_temp.inp  
