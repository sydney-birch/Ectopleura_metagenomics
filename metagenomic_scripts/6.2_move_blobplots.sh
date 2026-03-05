#! /bin/bash

for i in BLOBOLOGY/*; do 
	b=${i#*/}
	echo "b: $b"
	#echo "cp ${i}/final_assembly.binned.blobplot BLOB_PLOTS/${b}_final_assembly.binned.blobplot"
	#echo "cp ${i}/final_assembly.blobplot BLOB_PLOTS/${b}_final_assembly.blobplot"
	cp ${i}/final_assembly.binned.blobplot BLOB_PLOTS/${b}_final_assembly.binned.blobplot
	cp ${i}/final_assembly.blobplot BLOB_PLOTS/${b}_final_assembly.blobplot
	
done
