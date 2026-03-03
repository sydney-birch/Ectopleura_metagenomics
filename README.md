# *Ectopleura* Biofilm and Adult-Associated Microbe Metagenomic Study - Overview
This repository contains the metagenomics analysis of Biofilm and Adult-Associated Microbes (AAM) collected from three locations/populations for my NSF PRFB study. 

## Study Info and Sample structure
The overarching hypothesis of my PRFB work is: Distinct populations of *E. crocea* larvae are locally adapted to specfic biofilms, where larvae are cueing in on adult-associated microbes (AAM). 

<ins>To examine this I have conducted: </ins>
  - A recipricol transplant larval settlement study to examine the settlement phenotype across 3 locations/populations in the Gulf of Maine *(data in [sydney-birch/Ectopleura_pop_gen repository](https://github.com/sydney-birch/Ectopleura_Population_genetics)*
    
  - A metagenomics study examining the biofilm from each location and Adult-Associated Microbes (AAM) from polyps (adults) from each location *(data in this repository)*
    
  - A ddRAD pop gen study to examine the population structure and genetic variation across locations *(data in [sydney-birch/Ectopleura_pop_gen repository](https://github.com/sydney-birch/Ectopleura_Population_genetics))*
    
  - I'm currently sequencing the genome to aid in the ddRAD analysis *(data coming soon)*    
    
*All samples across all studies were collected on the same day*    

This metagenomics study is assessing two questions: (1) Do the biofilms collected from the three locations (CML: New Castle NH; York ME; Wells ME) differ (characterize biofilm); and (2) Do the adult polyps associate with different bacteria across locations (characterize adult-associated microbes). We collected 8 samples for each type of sample (Biofilm or AAM) from each location - totaling 48 samples during analysis. We chose to follow the [MetaWrap](https://github.com/bxlab/metaWRAP?tab=readme-ov-file) analysis pipeline. 

## Overview of Pipeline: 
1. Download data and prep work (count reads, adjust names)
2. QC samples and trimm reads (fastqc, trimmommatic)
3. Assemble metagenomes (megahit)
4. Run Kraken2 to get taxonomic composition (Kraken2 and Krona)
    - Run Bracken for abundance estimation
    - Calculate alpha diversity using KrakenTools
    - Graph alpha and beta diversity in R
5. Bin the assemblies with 3 algorithms (CONCOCT, MaxBin, and metaBAT)
6. Consolidate bins
7. Visualize the community and the extracted bins
8. Find the abundances of the draft genomes (bins) across the samples
9. Re-assemble the consolidated bin set
10. Determine the taxonomy of each bin
11. functionally annotate bins with PROKKA
