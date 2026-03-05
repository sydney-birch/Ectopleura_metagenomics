#! /bin/bash

for i in ASSEMBLY/*; do 
	b=${i#*/}
	echo "b: $b"
	#echo "cp ${i}/final_assembly.fasta CLEAN_ASSEMBLY/${b}_final_assembly.fasta"
	cp ${i}/final_assembly.fasta CLEAN_ASSEMBLY/${b}_final-assembly.fasta
	
done	
