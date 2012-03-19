#Avinash Ramu, WUSTL
#Create BCF files from bam files split by region, files are hard-coded in this example.

#! /bin/bash

for c in {1..22}
do
    echo "mpileup" $c
    time samtools mpileup -gDf ref_new.fa NA19238.$c.bam NA19239.$c.bam NA19240.$c.bam  > ../../bcfFiles/YRI.ngValdn.$c.bcf
    echo "index" $c
    time bcftools index ../../bcfFiles/YRI.ngValdn.$c.bcf
done


c=X
echo "mpileup X"
time samtools mpileup -gDf ref_new.fa NA19238.$c.bam NA19239.$c.bam NA19240.$c.bam  > ../../bcfFiles/YRI.ngValdn.$c.bcf
echo "index X"
time bcftools index ../../bcfFiles/YRI.ngValdn.$c.bcf