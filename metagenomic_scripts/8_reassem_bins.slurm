#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap8
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

## run a loop to processes all samples for module 8 reassemble_bins
for F in BIN_REFINEMENT/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    #echo "line of code: metawrap reassemble_bins -o BIN_REASSEMBLY/$b -1 CLEAN_READS/$b*1.fastq -2 CLEAN_READS/$b*2.fastq -t 96 -m 800 -c 50 -x 10 -b $F/metawrap_80_5_bins"
    metawrap reassemble_bins -o BIN_REASSEMBLY/$b -1 CLEAN_READS/$b*1.fastq -2 CLEAN_READS/$b*2.fastq -t 96 -m 800 -c 50 -x 10 -b $F/metawrap_80_5_bins
    echo "moving to next sample" &
done
