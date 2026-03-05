#! /bin/bash

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
    
    echo "$SAMPLE" >> species-Shannons_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a Sh >> species-Shannons_alpha.txt
    
    echo "$SAMPLE" >> species-Fishers_index_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a F >> species-Fishers_index_alpha.txt
    
    echo "$SAMPLE" >> species-Simpsons_diversity_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a Si >> species-Simpsons_diversity_alpha.txt
    
    echo "$SAMPLE" >> species-Inverse_Simpsons_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs/$SAMPLE.bracken -a ISi >> species-Inverse_Simpsons_alpha.txt
    
    echo "moving to next sample" &
done


## run a loop to processes all samples - GENUS
for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    #echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"

    #Run diversity script
    echo "$SAMPLE" >> genus-Berger-Parkers_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_genus/$SAMPLE.bracken -a BP >> genus-Berger-Parkers_alpha.txt
    
    echo "$SAMPLE" >> genus-Shannons_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_genus/$SAMPLE.bracken -a Sh >> genus-Shannons_alpha.txt
    
    echo "$SAMPLE" >> genus-Fishers_index_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_genus/$SAMPLE.bracken -a F >> genus-Fishers_index_alpha.txt
    
    echo "$SAMPLE" >> genus-Simpsons_diversity_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_genus/$SAMPLE.bracken -a Si >> genus-Simpsons_diversity_alpha.txt
    
    echo "$SAMPLE" >> genus-Inverse_Simpsons_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_genus/$SAMPLE.bracken -a ISi >> genus-Inverse_Simpsons_alpha.txt
    
    echo "moving to next sample" &
done


## run a loop to processes all samples - FAMILY
for F in ../CLEAN_ASSEMBLY/*_final-assembly.fasta; do
    #echo "current file:  $F"
    BASE=${F##*/}
    #echo "Base: $BASE"
    SAMPLE=${BASE%_*}
    echo "Sample: $SAMPLE"

    #Run diversity script
    echo "$SAMPLE" >> family-Berger-Parkers_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_family/$SAMPLE.bracken -a BP >> family-Berger-Parkers_alpha.txt
    
    echo "$SAMPLE" >> family-Shannons_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_family/$SAMPLE.bracken -a Sh >> family-Shannons_alpha.txt
    
    echo "$SAMPLE" >> family-Fishers_index_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_family/$SAMPLE.bracken -a F >> family-Fishers_index_alpha.txt
    
    echo "$SAMPLE" >> family-Simpsons_diversity_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_family/$SAMPLE.bracken -a Si >> family-Simpsons_diversity_alpha.txt
    
    echo "$SAMPLE" >> family-Inverse_Simpsons_alpha.txt
    python KrakenTools/DiversityTools/alpha_diversity.py -f bracken_outputs_family/$SAMPLE.bracken -a ISi >> family-Inverse_Simpsons_alpha.txt
    
    echo "moving to next sample" &
done
