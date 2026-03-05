#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap6
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

## run a loop to processes all samples for module 6 blobology
for F in BIN_REFINEMENT/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    #echo "line of code: metawrap blobology -a ASSEMBLY/$b/final_assembly.fasta -t 96 -o BLOBOLOGY/$b --bins $F/metawrap_80_5_bins CLEAN_READS/$b*fastq"
    metawrap blobology -a ASSEMBLY/$b/final_assembly.fasta -t 96 -o BLOBOLOGY/$b --bins $F/metawrap_80_5_bins CLEAN_READS/$b*fastq
    echo "moving to next sample" &
done
