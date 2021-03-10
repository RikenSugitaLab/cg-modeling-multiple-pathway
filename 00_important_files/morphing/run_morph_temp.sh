#!/bin/bash
#$ -cwd
#$ -V
#$ -q q2.q
#$ -pe ompi 8
#$ -S /bin/bash
#$ -j y

export OMP_NUM_THREADS=2
#rm -f <header>.<num>.dcd
#rm -f <header>.<num>.rst
mpirun -npernode 4 -np 4 ggggg/bin/atdyn xxxxx.inp > xxxxx.log

