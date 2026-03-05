#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap9
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

for F in BIN_REASSEMBLY/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    #echo "line of code: metawrap classify_bins -b $F/reassembled_bins -o BIN_CLASSIFICATION/$b -t 48"
    metawrap classify_bins -b $F/reassembled_bins -o BIN_CLASSIFICATION/$b -t 48
    echo "moving to next sample" &
done
