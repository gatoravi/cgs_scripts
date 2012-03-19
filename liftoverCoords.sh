#Author - Avinash Ramu, WUSTL
#Convert files using hg18 co-ordinates to hg19 co-ordinates

#! /usr/bin/bash

awk '{if ($1==23) print "chrX\t"$2"\t"$2+1; else print "chr"$1"\t"$2"\t"$2+1}' $1 > $1_temp # the input file is of form "chr\tpos"

bash ~/scripts/callLiftOver.sh $1_temp

awk '{sub("chr", ""); sub("X", "23"); print $1"\t"$2 }' $1_temp_liftovered > $1_liftovered

rm $1_temp

rm $1_temp_liftovered

mv $1_temp_unmapped $1_unmapped