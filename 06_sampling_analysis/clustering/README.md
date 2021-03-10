This directory contains files and scripts for clustering .dcd data for each basin (here basin 1 is shown)  


clustering_temp.inp: GENESIS input file for performing clustering of data using analysis_tools  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin1_1.pdb (1..10): pdb file for the cluster #1 (1...10) center  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin1.idx: output file from clustering, assigning each frame to a cluster  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin1.out: GENESIS .log file for clustering analysis  
pdb_matrix_fitfree.tcl: script for calculating RMSD between all pairs of cluster centers .pdb (and also x-ray reference files)  
pdb_matrix_fitfree_files.out: output file for above script  
lidmix-basin1-pop.pdb: pdb file for most populated cluster in basin  
lidmix-basin1-sim.pdb: pdb file for cluster most similar to basin1 reference (x-ray) structure  
kmeans_genesis_anal.tcl: script for calculating statistics on clustering analysis  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_both_13000_m60p28_0_m50p0-41-43-45-basin1_stats.out: output file for the above script  
