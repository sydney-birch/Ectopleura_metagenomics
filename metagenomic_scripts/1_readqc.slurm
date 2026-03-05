#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=metawrap1
#SBATCH --nodes=1
#SBATCH --mem=400GB
#SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00

conda init
conda deactivate 

##Load modules 
module load anaconda3
module load metawrap
module load jellyfish
module load kraken2
module load checkm
module load fastqc
module load trimmomatic

source activate metawrap-1.3.2

## run a loop to processes all samples for module 1 QC
for F in RAW_READS/*_1.fastq; do 
        echo "current file:  $F"
	R=${F%_*}_2.fastq
        #echo "R: $R"
	BASE=${F##*/}
        #echo "Base: $BASE"
	SAMPLE=${BASE%_*}
        echo "Sample: $SAMPLE"
        #echo "line of code: metawrap read_qc -1 $F -2 $R -t 24 -o READ_QC/$SAMPLE --skip-bmtagger"
	metawrap read_qc -1 $F -2 $R -t 24 -o READ_QC/$SAMPLE --skip-bmtagger
        echo "moving to next sample" &
done	 
