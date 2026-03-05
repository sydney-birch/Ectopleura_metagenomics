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
  - Run Kraken2: 3.C.1_Kraken.slurm
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
  - Run Bracken for abundance estimation at different taxonomic levels (only showing species): 3.C.2_Bracken.slurm
    ```
    ## run a loop to processes all samples - SPECIES LEVEL
    for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
        #echo "current file:  $F"
        BASE=${F##*/}
        #echo "Base: $BASE"
        SAMPLE=${BASE%_*}
        echo "Sample: $SAMPLE"
    
        echo "line of code: bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l S -t 10 -o bracken_outputs/$SAMPLE.bracken -w breports/$SAMPLE.breport"
        #bracken -d krak_DB_full -i kreports/$SAMPLE.k2report -l S -t 10 -o bracken_outputs/$SAMPLE.bracken -w breports/$SAMPLE.breport
    echo "moving to next sample" &
    done
    ```
  - Calculate alpha diversity using kraken tools (only showing species): 3.C.3_calc_alpha_div.sh
    ```
    #clone krakentools
    git clone https://github.com/jenniferlu717/KrakenTools

    ## run a loop to processes all samples - SPECIES
    for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
        #echo "current file:  $F"
        BASE=${F##*/}
        #echo "Base: $BASE"
        SAMPLE=${BASE%_*}
        echo "Sample: $SAMPLE"

        #Run diversity script
        echo "$SAMPLE" >> species-Berger-Parkers_alpha.txt
        python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a BP >> species-Berger-Parkers_alpha.txt
    
        $SAMPLE >> species-Shannons_alpha.txt
        python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a Sh >> species-Shannons_alpha.txt
    
        $SAMPLE >> species-Fishers_index_alpha.txt
        python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a F >> species-Fishers_index_alpha.txt
    
        $SAMPLE >> species-Simpsons_diversity_alpha.txt
        python KrakenTools/DiversityTools/alpha_diversity.py -f   bracken_outputs/$SAMPLE.bracken -a Si >> species-Simpsons_diversity_alpha.txt
    
        $SAMPLE >> species-Inverse_Simpsons_alpha.txt
        python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a ISi >> species-Inverse_Simpsons_alpha.txt
    
        echo "moving to next sample" &
    done
    ```
 - Calculate beta diversity using kraken tools (only showing species): 3.C.4_calc_beta_div.sh
   ```
   ## Species
   # All groups together
   python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/CML_AAM_2.bracken bracken_outputs/CML_AAM_5.bracken bracken_outputs/CML_AAM_9.bracken bracken_outputs/Wells_AAM_1.bracken bracken_outputs/Wells_AAM_6.bracken bracken_outputs/Wells_AAM_8.bracken bracken_outputs/York_AAM_10.bracken bracken_outputs/York_AAM_6.bracken bracken_outputs/York_AAM_9.bracken bracken_outputs/Wells_Biofilm_10.bracken bracken_outputs/Wells_Biofilm_6.bracken bracken_outputs/Wells_Biofilm_7.bracken bracken_outputs/York_Biofilm_3.bracken bracken_outputs/York_Biofilm_4.bracken bracken_outputs/CML_Biofilm_10.bracken bracken_outputs/CML_Biofilm_1.bracken --type bracken --level S >> beta_species_all_groups.txt

   # Only AAM
   python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/CML_AAM_2.bracken bracken_outputs/CML_AAM_5.bracken bracken_outputs/CML_AAM_9.bracken bracken_outputs/Wells_AAM_1.bracken bracken_outputs/Wells_AAM_6.bracken bracken_outputs/Wells_AAM_8.bracken bracken_outputs/York_AAM_10.bracken bracken_outputs/York_AAM_6.bracken bracken_outputs/York_AAM_9.bracken --type bracken --level S >> beta_species_AAM_groups.txt

   #Only Biofilm
   python KrakenTools/DiversityTools/beta_diversity.py -i bracken_outputs/Wells_Biofilm_10.bracken bracken_outputs/Wells_Biofilm_6.bracken bracken_outputs/Wells_Biofilm_7.bracken bracken_outputs/York_Biofilm_3.bracken bracken_outputs/York_Biofilm_4.bracken bracken_outputs/CML_Biofilm_10.bracken bracken_outputs/CML_Biofilm_1.bracken --type bracken --level S >> beta_species_Biofilm_groups.txt
   ```   
  - Graph alpha and beta diversity in R --> Ecto_AAM_Biofilm_diversity_stats.R
    
	
## 4. MetaWrap Binning  
This will be the most time intensive step - using 3 binners: CONCOCT, MaxBin, and metaBAT   

A) Make an output dir    
`mkdir INITIAL_BINNING`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 4_binning.slurm: 

```
## run a loop to processes all samples for module 4 binning 
for F in CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"
    mkdir INITIAL_BINNING/$SAMPLE
    echo "line of code: metawrap binning -o INITIAL_BINNING -t 96 -a $F --metabat2 --maxbin2 --concoct CLEAN_READS/$SAMPLE*fastq"
    metawrap binning -o INITIAL_BINNING/$SAMPLE -t 96 -a $F --metabat2 --maxbin2 --concoct CLEAN_READS/$SAMPLE*fastq
    echo "moving to next sample" &
done	
```

## 5. MetaWrap Bin refinement  
Consolidat the three bins into a single stronger bin set    

A) Make an output dir    
`mkdir BIN_REFINEMENT`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 5_bin_refinement.slurm: 

```
## run a loop to processes all samples for module 5 bin refinement
for F in INITIAL_BINNING/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    echo "INITIAL_BINNING/$F/metabat2_bins/"
    echo "line of code: metawrap bin_refinement -o BIN_REFINEMENT/$b -t 96 -A INITIAL_BINNING/$F/metabat2_bins/ -B INITIAL_BINNING/$F/maxbin2_bins/ -C INITIAL_BINNING/$F/concoct_bins/ -c 80 -x 5"
    #metawrap bin_refinement -o BIN_REFINEMENT/$b -t 96 -A $F/metabat2_bins/ -B $F/maxbin2_bins/ -C $F/concoct_bins/ -c 80 -x 5
    echo "moving to next sample" &
done	
```

## 6. Visualize the community and the extracted bins with Blobology 
blobology will project the entire assembly onto a GC vs Abundance plane and annotate them with taxonomy and bin info    

A) Make an output dir    
`mkdir BLOBOLOGY`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 6_blobology.slurm: 

```
## run a loop to processes all samples for module 6 blobology
for F in BIN_REFINEMENT/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    echo "line of code: metawrap blobology -a ASSEMBLY/$b/final_assembly.fasta -t 96 -o BLOBOLOGY/$b --bins $F/metawrap_80_5_bins CLEAN_READS/$b*fastq"
    #metawrap blobology -a ASSEMBLY/$b/final_assembly.fasta -t 96 -o BLOBOLOGY/$b --bins $F/metawrap_80_5_bins CLEAN_READS/$b*fastq
    echo "moving to next sample" &
done	
```
C) Run script to move all the blobplots for export into a BLOB_PLOTS dir   
`mkdir BLOB_PLOTS`   
`./6.2_move_blobplots.sh`   

## 7. Find the abundaces of the draft genomes (bins) across the samples 
Find how the extracted genomes are distributed across the samples, and in what abundances each bin is present in each sample   

A) Make an output dir    
`mkdir QUANT_BINS`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 7_quant_bins.slurm: 

```
## run a loop to processes all samples for module 7 quant bins
for F in BIN_REFINEMENT/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    echo "line of code: metawrap quant_bins -b BIN_REFINEMENT/metawrap_80_5_bins -o QUANT_BINS/$b -a ASSEMBLY/$b/final_assembly.fasta CLEAN_READS/$b*fastq"
    #metawrap quant_bins -b $F/metawrap_80_5_bins -o QUANT_BINS/$b -a ASSEMBLY/$b/final_assembly.fasta CLEAN_READS/$b*fastq
    echo "moving to next sample" &
done	
```

## 8. Re-asssemble the consolidated bin set with the Reassemble_bins module 

A) Make an output dir    
`mkdir BIN_REASSEMBLY`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 8_reassem_bins.slurm: 

```
## run a loop to processes all samples for module 8 reassemble_bins
for F in BIN_REFINEMENT/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    echo "line of code: metawrap reassemble_bins -o BIN_REASSEMBLY/$b -1 CLEAN_READS/$b*1.fastq -2 CLEAN_READS/$b*2.fastq -t 96 -m 800 -c 50 -x 10 -b $F/metawrap_80_5_bins"
    #metawrap reassemble_bins -o BIN_REASSEMBLY/$b -1 CLEAN_READS/$b*1.fastq -2 CLEAN_READS/$b*2.fastq -t 96 -m 800 -c 50 -x 10 -b $F/metawrap_80_5_bins
    echo "moving to next sample" &
done	
```
C) Copy over the reassembly pngs and stats to a new dir to scp to local computer `./8.2_move_reassem_stats.sh`
```
mkdir BIN_REASSEMBLY_Info

for i in BIN_REASSEMBLY/*; do 
	b=${i#*/}
	echo "b: $b"
	echo "i: $i"
	echo "cp ${i}/reassembled_bins.png BIN_REASSEMBLY_Info/${b}_reassembled_bins.png"
	echo "cp ${i}/reassembly_results.png BIN_REASSEMBLY_Info/${b}_reassembly_results.png"
	echo "cp ${i}/reassembled_bins.stats BIN_REASSEMBLY_Info/${b}_reassembled_bins.stats"
	#cp ${i}/reassembled_bins.png BIN_REASSEMBLY_Info/${b}_reassembled_bins.png
	#cp ${i}/reassembly_results.png BIN_REASSEMBLY_Info/${b}_reassembly_results.png
	#cp ${i}/reassembled_bins.stats BIN_REASSEMBLY_Info/${b}_reassembled_bins.stats
	
done
```

## 9. Determine the taxonomy of each bin with the Classify_bins module   

A) Make an output dir    
`mkdir BIN_CLASSIFICATION`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 9_bin_class.slurm: 

```
## run a loop to processes all samples for module 9 bin_classification 
for F in BIN_REASSEMBLY/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    echo "line of code: metawrap classify_bins -b $F/reassembled_bins -o BIN_CLASSIFICATION/$b -t 48"
    #metawrap classify_bins -b $F/reassembled_bins -o BIN_CLASSIFICATION/$b -t 48
    echo "moving to next sample" &
done
```

## 10. Functionally annotate bins with the Annotate_bins module  

A) Make an output dir    
`mkdir Funct_ANNOT`   

B) submit slurm to loop through all raw reads to use metawrap read_qc module (trimmomatic and fastqc):
  - 10_funct_annot.slurm: 

```
## run a loop to processes all samples for module 10 annotate function 
for F in BIN_REASSEMBLY/*; do
    echo "F current dir: $F"
    b=${F#*/}
    echo "b:  $b"
    echo "line of code: metawrap annotate_bins -o FUNCT_ANNOT/$b -t 96 -b $F/reassembled_bins"
    #metawrap annotate_bins -o FUNCT_ANNOT/$b -t 96 -b $F/reassembled_bins
    echo "moving to next sample" &
done
```
C) Run Clean reads through Metacerberus to get functional annotations across multiple orthology databases: 10.2_metacerb.slurm
`metacerberus.py --prodigal ../CLEAN_READS --illumina --meta --dir_out AAM_Biofilm_metacerb_output `
