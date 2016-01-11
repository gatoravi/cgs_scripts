#! /bin/bash

#Get the counts of calls which meet PP threshold.

for pp in 0.5 0.6 0.7 0.8 0.9 1.0
do
    echo -e $pp"\t" `awk -v pp=$pp '{ if($26>=pp) { print } }' $1 | wc -l`
done