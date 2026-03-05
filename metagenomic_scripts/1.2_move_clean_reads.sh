#! /bin/bash

for i in READ_QC/*; do 
	b=${i#*/}
        echo "b: $b"
        #echo "command: ${i}/final_pure_reads_1.fastq CLEAN_READS/${b}_1.fastq"
	mv ${i}/final_pure_reads_1.fastq CLEAN_READS/${b}_1.fastq
	mv ${i}/final_pure_reads_2.fastq CLEAN_READS/${b}_2.fastq
done
	
