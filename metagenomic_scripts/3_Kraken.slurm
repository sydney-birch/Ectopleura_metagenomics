#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap3
#SBATCH --nodes=1
#SBATCH --mem=480GB
#SBATCH --ntasks-per-node=20
#SBATCH --time=168:00:00


##Load modules 
module load anaconda3
module load metawrap
module load jellyfish
module load kraken2
module load checkm
module load spades
module load quast
module load megahit


source activate metawrap-1.3.2

## run a loop to processes all samples for module 3 assembly
for F in CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    mkdir KRAKEN/$SAMPLE
    #echo "line of code: metawrap kraken -o KRAKEN -t 96 -s 1000000 CLEAN_READS/$SAMPLE*fastq $F"
    metawrap kraken2 -o KRAKEN/$SAMPLE -t 96 -s 1000000 CLEAN_READS/$SAMPLE*fastq $F
    echo "moving to next sample" &
done
