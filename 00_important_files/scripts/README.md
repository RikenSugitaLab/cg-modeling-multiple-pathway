modeling:  
########  
DualbasinBD_v4_distcrit.pl: a script to convert two single-basin parameter files into one dual-basin parameter file 
dualbasin-to-multibasin-patch-mixed-intra.tcl: a script to convert a dual-basin parameter file into a multi-basin parameter file  
MT.info: Motion Tree output file required as input for "DualbasinBD_v4_distcrit.pl"  

md_runs:  
#######  
theta_lid_exec.tcl: script for calculating LID angle on .dcd trajectory  
theta_nmp_exec.tcl: script for calculating NMP angle on .dcd trajectory  
theta_lid_exec.tcl: script for calculating LID angle on .dcd trajectory  
theta_nmp_exec.tcl: script for calculating NMP angle on .dcd trajectory  

mbar:  
#######
mbar_multibasin_input_data_exec.tcl: script for calculating energies of each simulation with parameters of other simulations  
mbar_multibasin_input_target_exec.tcl: script for calculating energies of each simulation with parameters of target (unsimulated) conditions 
kmeans_clust_hist2d_predef_exec.tcl: script for clustering 2D pmf to a predefined (3) number of clusters and calculating their centers  

clustering:  
##########  
kmeans_genesis_anal.tcl: script for analyzing clutering results  
pdb_matrix_fitfree.tcl: script for calculating RMSD between all pairs of cluster centers  

qval:  
####### 
qval-ind-uniq-grotop.tcl: script for calculating Qval (fraction of native contacts from .dcd trajectory file)  
