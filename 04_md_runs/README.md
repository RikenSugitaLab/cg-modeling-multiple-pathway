This directory contains input/output files for running one round of MD simulation with one set of parameters (for lid-closing pathway), and performing initial analysis  
scripts are executed in the following order:  
(output files are not described in the README but exist in the directory and appear in the description of the relevant script, also sample output files were placed in 00_important_files directory)  

run_DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.sh: execution script that initiates all the other scripts  
DoME_TB_4akea_1akea_0p6dc_2p6cr_lidmix_1akea_12000_m60p75_0_m50p5.inp: GENESIS .inp file for running MD simulation  
drms_to_1akea_4akea.inp: GENESIS .inp file for calculating dRMS using analysis_tools  
key-mult-single_exec.tcl: script for separating dRMS output file to two files (one for Open-reference, one for Closed-reference)  
theta_lid_exec.tcl: script for calculating lid angle from .dcd file 
theta_nmp_exec.tcl: script for calculating nmp angle from .dcd file  
pmf_1d_1_exec.inp: GENESIS .inp file for calculating 1D-pmf on dRMS data (1st dimension)  
pmf_1d_2_exec.inp: GENESIS .inp file for calculating 1D-pmf on dRMS data (2nd dimension)  
data_align_drms1_exec.inp: script for aligning pmf to zero (1st dimension)  
data_align_drms2_exec.inp: script for aligning pmf to zero (2nd dimension)  
pmf_2d_drms_exec.inp: GENESIS .inp file for calculating 2D dRMS  
pmf_2d_genesis_proc_drms_exec.tcl: converting 2D drms output file to matplotlib format  
pmf_2d_genesis_matplotlib_proc_drms_exec.tcl: converting 2D drms output file to matplotlib format  
pmf_1d_lid_exec.inp: GENESIS .inp file for calculating 1D-pmf on LID angle data  
pmf_1d_nmp_exec.inp: GENESIS .inp file for calculating 1D-pmf on NMP angle data  
data_align_lid_exec.inp: script for aligning pmf to zero (LID)  
data_align_nmp_exec.inp: script for aligning pmf to zero (NMP)  
pmf_2d_nmp_lid_exec.inp: GENESIS .inp file for calculating 2D pmf on LID,NMP angles  
pmf_2d_genesis_proc_nmplid_exec.tcl: converting 2D drms output file to matplotlib format  
pmf_2d_genesis_matplotlib_proc_nmplid_exec.tcl: converting 2D drms output file to matplotlib format  
pmf_2d_nmp_lid_half1_exec.inp: GENESIS .inp file for calculating pmf on first half of trajectory   
pmf_2d_nmp_lid_half2_exec.inp: GENESIS .inp file for calculating pmf on second half of trajectory  
pmf_2d_genesis_proc_nmplid_half1_exec.tcl: converting 2D drms output file to matplotlib format  
pmf_2d_genesis_proc_nmplid_half2_exec.tcl: converting 2D drms output file to matplotlib format  
pmf_2d_genesis_matplotlib_proc_nmplid_half1_exec.tcl: converting 2D drms output file to matplotlib format  
pmf_2d_genesis_matplotlib_proc_nmplid_half2_exec.tcl: converting 2D drms output file to matplotlib format  
