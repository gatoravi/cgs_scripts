#! /bin/bash

for bam in `ls *.bam`
do
    echo $bam
#    samtools index $bam
    qsub -P long -l h_vmem=8g ~/Scripts/indexBAM.sh $bam
done