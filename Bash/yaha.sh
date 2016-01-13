#! /bin/bash
ref=$1
fastq1=$2
fastq2=$3
bam=$4
./yaha -q $fastq1 -q $fastq2 -x $ref -oss stdout | samtools view -Sb - > $bam 
