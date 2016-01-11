#Avinash Ramu, WUSTL
#Summary - Pull out required columns from DNG o/p

#! /usr/bin/bash

awk '/DENOVO-INDEL/ {print $6"\t"$8"\t"$26}' $1 > ./IndelAnalysis/$1_posns