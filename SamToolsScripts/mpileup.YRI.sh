#! /bin/bash

ref=$1
b1=$2
b2=$3
b3=$4
chr=$5

echo -e $b1"\t"$b2"\t"$b3
samtools mpileup -gDf $ref $b1 $b2 $b3 -r $chr > YRI.$chr.bcf

bcftools index YRI.$chr.bcf