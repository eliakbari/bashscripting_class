#!/bin/bash

for i in $(seq 1 15)
do
	let M2=i%2
	let M3=i%3
	[ "$M2" -eq 0 ] || [ "$M3" -eq 0 ] && continue
	fact=1
	while [ $i -ne 0 ]
		do
			fact=$((fact * i)) 
			i=$((i - 1))     
		done

	echo $fact

done
