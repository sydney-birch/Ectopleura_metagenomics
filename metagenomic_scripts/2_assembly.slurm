#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap2
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

## run a loop to processes all samples for module 2 assembly
for F in CLEAN_READS/*_1.fastq; do 
    echo "current file:  $F"
    R=${F%_*}_2.fastq
    #echo "R: $R"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    #echo "line of code: metawrap assembly -1 $F -2 $R -m 400 -t 96 -o ASSEMBLY/$SAMPLE"
    metawrap assembly -1 $F -2 $R -m 400 -t 96 -o ASSEMBLY/$SAMPLE
    echo "moving to next sample" &
done	 
