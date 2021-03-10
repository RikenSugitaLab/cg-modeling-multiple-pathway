This directory contains files for morphing runs for the "1akea-lidmix" (Closed to lid-closing intermediate subpathway)  

file list:   
#########  
1akea-lidmix.mor: morphing parameter files for the Closed -> lid-closing-intermediate subpath  
lidmix-1akea.mor: morphing parameter files for the lid-closing-intermediate subpath -> Closed subpath (reverse subpath)  
GO_1akea.pdb: structure file for Closed structure   
lidmix.pdb: structure file for the (estimated) lid-closing-intermediate structure  
GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed.grotop: triple-basin parameter file for the morphing simulation  
morph_3basin_temp.inp: template file of input file for morphing simulations   
run_morph_temp.sh: template file for submitting morphing runs   
mixing_check_climber.pl: script for extracting basin contribution data and transition quality from morphing simulations  

Sample files shown only for round03 (last round)  
round03:  
########  
setup-morph-runs.sh: a script file for setting a bunch of morphing runs with varying parameters  

Sample files for a single morphing runs (due to large data size only one file is shown)  
morph_1akea_lidmix_9000_150_0_m85.inp: sample input file for a single morphing run (parameters Tmix=9000, C1=150, C2=0,c C3=-85)  
morph_1akea_lidmix_9000_150_0_m85.log: sample log file for a single morphing run  
morph_1akea_lidmix_9000_150_0_m85.log.minlast: sample output file from "mixing_check_climber.pl"  

Plotting:  
plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed_1akea_lidmix_03.gnu  
plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed_1akea_lidmix_03.png  
plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed_lidmix_1akea_03.gnu  
plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed_lidmix_1akea_03.png  
plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed-round03.gnu  
plot_GO_DoME_TB_4akea_1akea_0p6dc_2p6cr_lid_intra_mixed-round03.png  

