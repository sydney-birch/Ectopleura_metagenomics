#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=braken
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
module load bracken


## Test bracken - works!
##bracken -d krak_DB_full -i kreports/CML_AAM_2.k2report -l S -t 10 \
##-o bracken_outputs/CML_AAM_2.bracken -w breports/CML_AAM_2.breport

## run a loop to processes all samples - SPECIES LEVEL 
for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    #echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    
    echo "line of code: bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l S -t 10 -o bracken_outputs/$SAMPLE.bracken -w breports/$SAMPLE.breport"
    bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l S -t 10 -o bracken_outputs/$SAMPLE.bracken -w breports/$SAMPLE.breport
    echo "moving to next sample" &
done

echo "moving to Genus Level"

## run a loop to processes all samples - GENUS LEVEL
for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    #echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    
    echo "line of code: bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l G -t 10 -o bracken_outputs_genus/$SAMPLE.bracken -w breport_genus/$SAMPLE.breport"
    bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l G -t 10 -o bracken_outputs_genus/$SAMPLE.bracken -w breports_genus/$SAMPLE.breport
    echo "moving to next sample" &
done

echo "moving to	Family Level"

## run a loop to processes all samples - FAMILY LEVEL
for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    #echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    
    echo "line of code: bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l F -t 10 -o bracken_outputs_family/$SAMPLE.bracken -w breports_family/$SAMPLE.breport"
    bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l F -t 10 -o bracken_outputs_family/$SAMPLE.bracken -w breports_family/$SAMPLE.breport
    echo "moving to next sample" &
done

