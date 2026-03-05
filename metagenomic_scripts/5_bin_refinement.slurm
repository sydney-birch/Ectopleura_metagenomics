#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap5
#SBATCH --nodes=5
#SBATCH --mem=480GB
#SBATCH --ntasks-per-node=5
#SBATCH --time=384:00:00


##Load modules 
module load anaconda3
module load metawrap
module load jellyfish
module load kraken2
module load checkm
module load spades
module load quast
module load megahit
module load metabat

source activate metawrap-1.3.2

## run a loop to processes all samples for module 5 bin refinement
for F in INITIAL_BINNING/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    #echo "INITIAL_BINNING/$F/metabat2_bins/"
    #echo "line of code: metawrap bin_refinement -o BIN_REFINEMENT/$b -t 96 -A $F/metabat2_bins/ -B $F/maxbin2_bins/ -C $F/concoct_bins/ -c 80 -x 5"
    metawrap bin_refinement -o BIN_REFINEMENT/$b -t 96 -A $F/metabat2_bins/ -B $F/maxbin2_bins/ -C $F/concoct_bins/ -c 80 -x 5
    echo "moving to next sample" &
done
