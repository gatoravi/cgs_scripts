#!/bin/bash


#IN_PATH="~/tmp"
#REF_PATH="/ref"
#OUT_PATH="~/tmp"


samtools index $1
for chr in 8 X Y
do
    samtools view -b $1 $chr > $1.$chr.bam
    samtools index $1.$chr.bam
done


