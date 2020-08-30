#!/bin/bash

echo -n -e "Please enter a number, Primer numbers up to entered value will be calculated and printed out\n your input: "
read num
for ((j=2;j<$num;j++))
do
	sqrt=$( echo "sqrt($j)" | bc )
	isprime="true"
	for i in $(seq 2 $sqrt)
	do
		let M2=$j%i
		[ "$M2" -eq 0 ] && isprime="false" && break
	done
	[ $isprime == "true" ] && echo "$j"
done
