#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap4
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

## run a loop to processes all samples for module 4 binning 
for F in CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    mkdir INITIAL_BINNING/$SAMPLE
    #echo "line of code: metawrap binning -o INITIAL_BINNING/$SAMPLE -t 96 -a $F --metabat2 --maxbin2 --concoct CLEAN_READS/$SAMPLE*fastq"
    metawrap binning -o INITIAL_BINNING/$SAMPLE -t 96 -a $F --metabat2 --maxbin2 --concoct CLEAN_READS/$SAMPLE*fastq
    echo "moving to next sample" &
done
