#! /bin/bash

for i in ASSEMBLY/*; do 
	b=${i#*/}
	echo "b: $b"
	echo "cp ${i}/assembly_report.html ASSEMBLY_REPORTS/${b}_assembly-report.html"
	cp ${i}/assembly_report.html ASSEMBLY_REPORTS/${b}_assembly-report.html
	
done
