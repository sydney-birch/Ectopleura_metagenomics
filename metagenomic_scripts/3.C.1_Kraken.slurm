#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap3
#SBATCH --nodes=1
#SBATCH --mem=480GB
#SBATCH --ntasks-per-node=20
#SBATCH --time=48:00:00


##Load modules 
module load anaconda3
module load metawrap
module load jellyfish
module load kraken2
module load checkm
module load spades
module load quast
module load megahit


## Test kraken2
##kraken2 --db krak_DB --threads 8 --report kreports/CML_AAM_2.k2report \
##--report-minimizer-data --paired --minimum-hit-groups 3 ../CLEAN_READS/CML_AAM_2_1.fastq \
##../CLEAN_READS/CML_AAM_2_2.fastq > kraken_outputs/CML_AAM_2.kraken2

## Test run 2 - works
##kraken2 --db krak_DB_full --threads 8 --report kreports/CML_AAM_2.k2report --report-minimizer-data --paired --minimum-hit-groups 3 ../CLEAN_READS/CML_AAM_2_1.fastq ../CLEAN_READS/CML_AAM_2_2.fastq > kraken_outputs/CML_AAM_2.kraken2


## run a loop to processes all samples 
for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    #echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    
    #echo "line of code: kraken2 --db krak_DB_full --threads 8 --report kreports/$SAMPLE.k2report --report-minimizer-data --paired --minimum-hit-groups 3 ../CLEAN_READS/${SAMPLE}_1.fastq ../CLEAN_READS/${SAMPLE}_2.fastq > kraken_outputs/$SAMPLE.kraken2"
    kraken2 --db krak_DB_full --threads 8 --report kreports/$SAMPLE.k2report --report-minimizer-data --paired --minimum-hit-groups 3 ../CLEAN_READS/${SAMPLE}_1.fastq ../CLEAN_READS/${SAMPLE}_2.fastq > kraken_outputs/$SAMPLE.kraken2
    echo "moving to next sample" &
done
