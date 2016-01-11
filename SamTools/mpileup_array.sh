#Avinash Ramu, WUSTL

#! /usr/bin/bash
chr=$SGE_TASK_ID
ref=~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa

bam1=$1
bam2=$2
bam3=$3


echo $chr
bash ~/Scripts/SamToolsScripts/mpileup.sh $ref $bam1 $bam2 $bam3 $chr


