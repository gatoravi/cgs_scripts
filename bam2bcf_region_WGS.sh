#Avinash Ramu, WUSTL
#Summary - Generate variants in a bcf file using alignments.
#Arguments - $1 is the chromosome number where you want to generate the variant calls.


#! /usr/bin/bash
reg=$1
 
BAM_IN=/home/comp/exlab/aramu/files/20110915_CEUtrio/WGS/bamFiles
REF_IN=/home/comp/exlab/aramu/files/20110915_CEUtrio/WGS/ref
OP=/home/comp/exlab/aramu/files/20110915_CEUtrio/WGS/bcfFiles_temp

ref=$REF_IN/hs37d5.fa # reference file
f1=$BAM_IN/CEUTrio.HiSeq.WGS.b37_decoy.NA12878.clean.dedup.recal.bam_chr$reg.bam
f2=$BAM_IN/CEUTrio.HiSeq.WGS.b37_decoy.NA12891.clean.dedup.recal.bam_chr$reg.bam
f3=$BAM_IN/CEUTrio.HiSeq.WGS.b37_decoy.NA12892.clean.dedup.recal.bam_chr$reg.bam
op=$OP/CEU_WGS_chr$reg.bcf

echo "Start mpileup "$reg

#use samtools mpileup to generate variant calls
time samtools mpileup -ugf $ref -r $reg $f1 $f2 $f3 > $op

echo "Start index"

# All BCF files need to be indexed
bcftools index $op

echo "Done"