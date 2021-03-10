This directory contains files for MD runs for obtaining estimated structures for intermediate structures (required for morphing runs).
In these MD runs, triple-basin potential was used and the intermediate basin height was set to -100 so that it will be sampled exclusively.

runs: input/output file for MD runs for each intermediate starting from both Open (1akea) and Closed (4akea) intial structures
#####
lid-closing-inter-1akea
lid-closing-inter-4akea
nmp-closing-inter-1akea
nmp-closing-inter-4akea

structures: final structures for intermediate states obtained by clustering analysis
##########
clustering_temp.inp
lidmix.pdb
nmpmix.pdb
