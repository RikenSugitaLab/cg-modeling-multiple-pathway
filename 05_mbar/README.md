Example of a single MBAR calculation for a series of simulated data (LID-closing pathway, round )

mbar-mbgo-2d-genesis.sh: script file for initiating one round of MBAR calculation on a series of data

scripts are executed in the following order: 
############################################
mbar_multibasin_input_data_temp.tcl: calculates permutated energies for each MD run using mixing parameters of all other runs (various parameters)
mbar_multibasin_input_target_temp.tcl: calculates energies for rach MD run using target mixing parameters
mbar_input_temp.inp: template file for creating input files for calculating MBAR using GENESIS mbar_analysis (creates .weight file for each target parameter set with respect to each real simulation data)
pmf2d-input_temp.inp: template file for creating input files for calculating estimated 2D pmf using GENESIS pmf_analysis for target parameters using weight files from real simulation data
data_align_zero_single_temp.tcl: aligns pmf to zero
pmf-2d-genesis-proc_exec.tcl: converts pmf to a readable format (no "Infinity", aligns into 2 columns)
pmf-to-kmeans-ratio.sh: script file to execute the calculation of centers of data from pmf 
pmf_to_hist_2d_temp.tcl: converts a 2D pmf to a histogram
kmeans_clust_hist2d_predef_temp.tcl: clusters 2D histogram data into predefined (3) clusters with predefined centers and calculates the center


other input files: 
#################
files_mdlog.txt: list of concatenated GENESIS .log (output) file names 
files_cvreal1.txt: file with a list of timestep vs. LID angle files (1st dimension)
files_cvreal2.txt: file with a list of timestep vs. NMP angle files (2nd dimension)
files_targets.txt: file with target parameters tmix, C1, C2, C3 

* output files are not described in this README but they are included in the directory and their usage is detailed in the respective scripts

kmeans_simulation
################
This directory contains the same k-means analysis but for actual simulation data (LID-NMP 2D pmf from MD simulation rounds)
pmf_to_hist_2d_temp.tcl: converting pmf into histogram
kmeans_clust_hist2d_predef_temp.tcl: perform k-means clustering analysis
kmeans.out: output file for the above script, showing results of all iterations
