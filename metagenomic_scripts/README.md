# *Ectopleura* Metagenomic Workflow

For the metagenomic workflow, we are following the [MetaWrap tutorial](https://github.com/bxlab/metaWRAP/blob/master/Usage_tutorial.md)    

## Prep work: 

A) Download data using ftp  

B) Change the names of the raw reads   
  - 0_count_reads_in_zipped_fastqs.slurm --> This runs `./0_count_reads_in_zipped_fastqs.py -a raw_reads_5-13-25`
  
## 1. MetaWrap QC   
A) Make an output dir    
`mkdir READ_QC`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 1_readqc.slurm: 

```
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
```
C) Move clean reads into a new dir: `./1.2_move_clean_reads.sh`
```
mkdir CLEAN_READS
for i in READ_QC/*; do 
	b=${i#*/}
	mv ${i}/final_pure_reads_1.fastq CLEAN_READS/${b}_1.fastq
	mv ${i}/final_pure_reads_2.fastq CLEAN_READS/${b}_2.fastq
done
```

## 2. Assemble metagenomes using MegaHit  
A) Make an output dir    
`mkdir ASSEMBLY`   

B) submit slurm to loop through all clean reads to use metawrap assembly module:
  - I'm assembling each sample separetly so we have replicate assemblies 
  - 2_assembly.slurm : 

```
## run a loop to processes all samples for module 2 assembly
for F in CLEAN_READS/*_1.fastq; do 
    echo "current file:  $F"
	R=${F%_*}_2.fastq
    echo "R: $R"
	BASE=${F##*/}
    echo "Base: $BASE"
	SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    echo "line of code: metawrap assembly -1 $F -2 $R -m 200 -t 96 --metaspades -o ASSEMBLY/$SAMPLE"
	metawrap assembly -1 $F -2 $R -m 200 -t 96 --metaspades -o ASSEMBLY/$SAMPLE
    echo "moving to next sample" &
done	 
```
C) Move assemblies into a new dir: `./2.2_move_clean_assemblies.sh`
```
mkdir CLEAN_ASSEMBLY
for i in ASSEMBLY/*; do 
	b=${i#*/}
	echo "b: $b"
	echo "mv ${i}/final_assembly.fasta CLEAN_ASSEMBLY/${b}_final-assembly.fasta"
	cp ${i}/final_assembly.fasta CLEAN_ASSEMBLY/${b}_final-assembly.fasta
done
```
D) Move assembly reports into a new dir: `./2.3_move_assembly_reports.sh`
```
mkdir ASSEMBLY_REPORTS

for i in ASSEMBLY/*; do 
	b=${i#*/}
	echo "b: $b"
	echo "cp ${i}/assembly_report.html ASSEMBLY_REPORTS/${b}_assembly-report.html"
	#cp ${i}/assembly_report.html ASSEMBLY_REPORTS/${b}_assembly-report.html
	
done
```

## 3. Run Kraken2   
A) Make an output dir    
`mkdir KRAKEN`   

B) submit slurm to loop through all clean assemblies and reads  to use metawrap kraken module:
  - 3_Kraken.slurm: 

```
## run a loop to processes all samples for module 3 on assemblies
for F in CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    mkdir KRAKEN/$SAMPLE
    #echo "line of code: metawrap kraken -o KRAKEN/$SAMPLE -t 96 -s 1000000 CLEAN_READS/$SAMPLE*fastq $F"
    metawrap kraken2 -o KRAKEN/$SAMPLE -t 96 -s 1000000 CLEAN_READS/$SAMPLE*fastq $F
    echo "moving to next sample" &
done	
```
  - Copy over krona files to inspect in web browser
    
C) Follow another [tutorial](https://www.nature.com/articles/s41596-022-00738-y#Sec18) using kraken2 and Braken. First download databases and run Kraken2: 
  - Download kraken [database](https://benlangmead.github.io/aws-indexes/k2)
    ```
    #Download full standard database
    wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_16_GB_20250714.tar.gz

    #Extract archive content
    tar -xvzf k2_standard_20250714.tar.gz
    ```
  - Run Kraken2
    ```
    #Make dirs:
    mkdir kraken_outputs
    mkdir kreports

    ## run a loop to processes all samples 
    for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
        echo "current file:  $F"
        BASE=${F##*/}
        #echo "Base: $BASE"
        SAMPLE=${BASE%_*}
        echo "Sample: $SAMPLE"
    
        echo "line of code: kraken2 --db krak_DB_full --threads 8 --report kreports/$SAMPLE.k2report --report-minimizer-data --paired --minimum-hit-groups 3 ../CLEAN_READS/${SAMPLE}_1.fastq ../CLEAN_READS/${SAMPLE}_2.fastq > kraken_outputs/$SAMPLE.kraken2"
        #kraken2 --db krak_DB_full --threads 8 --report kreports/$SAMPLE.k2report --report-minimizer-data --paired --minimum-hit-groups 3 ../CLEAN_READS/${SAMPLE}_1.fastq ../CLEAN_READS/${SAMPLE}_2.fastq > kraken_outputs/$SAMPLE.kraken2
    echo "moving to next sample" &
    done

    ```


	
```
mkdir CLEAN_READS
for i in READ_QC/*; do 
	b=${i#*/}
	mv ${i}/final_pure_reads_1.fastq CLEAN_READS/${b}_1.fastq
	mv ${i}/final_pure_reads_2.fastq CLEAN_READS/${b}_2.fastq
done
```







