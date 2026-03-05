#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap10
#SBATCH --nodes=1
#SBATCH --mem=480GB
#SBATCH --ntasks-per-node=12
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
module load R

source activate metawrap-1.3.2

## run a loop to processes all samples for module 10 annotate function 
for F in BIN_REASSEMBLY/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    #echo "line of code: metawrap annotate_bins -o FUNCT_ANNOT/$b -t 96 -b $F/reassembled_bins"
    metawrap annotate_bins -o FUNCT_ANNOT/$b -t 96 -b $F/reassembled_bins
    echo "moving to next sample" &
done

