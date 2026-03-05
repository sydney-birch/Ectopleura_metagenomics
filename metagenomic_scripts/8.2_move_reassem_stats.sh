#! /bin/bash

for i in BIN_REASSEMBLY/*; do 
	b=${i#*/}
	echo "b: $b"
	echo "i: $i"
	#echo "cp ${i}/reassembled_bins.png BIN_REASSEMBLY_Info/${b}_reassembled_bins.png"
	#echo "cp ${i}/reassembly_results.png BIN_REASSEMBLY_Info/${b}_reassembly_results.png"
	#echo "cp ${i}/reassembled_bins.stats BIN_REASSEMBLY_Info/${b}_reassembled_bins.stats"
	cp ${i}/reassembled_bins.png BIN_REASSEMBLY_Info/${b}_reassembled_bins.png
	cp ${i}/reassembly_results.png BIN_REASSEMBLY_Info/${b}_reassembly_results.png
	cp ${i}/reassembled_bins.stats BIN_REASSEMBLY_Info/${b}_reassembled_bins.stats
	
done

