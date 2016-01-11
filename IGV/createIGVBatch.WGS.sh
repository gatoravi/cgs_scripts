#Avinash Ramu, WUSTL
#ARG1 - list of chr\tpos\tMisc
#ARG2 - window size 

#! /usr/bin/bash

W=$2
echo new
echo load /home/dclab/aramu/files/20110915_CEUtrio/WGS/BAMFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12878.clean.dedup.recal.bam
echo load /home/dclab/aramu/files/20110915_CEUtrio/WGS/BAMFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12891.clean.dedup.recal.bam
echo load /home/dclab/aramu/files/20110915_CEUtrio/WGS/BAMFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12892.clean.dedup.recal.bam

#echo load ~/files/20110915_CEUtrio/WEx/bamFiles/CEUTrio.HiSeq.WEx.b37_decoy.NA12892.clean.dedup.recal.20120117.bam
#echo load /home/comp/exlab/aramu/files/20110915_CEUtrio/WGS/BAMFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12892.clean.dedup.recal.bam
#echo load ~/files/GTEx/Dat/BAM/NA12892.tophat.sorted.bam
#echo load ~/files/GTEx/Dat/BAM/NA12892.bwa.sorted.bam



echo snapshotDirectory .
echo genome hg19

awk -v w=$W '{ print "\ngoto "$1":"$2"-"$2+w"\nsort\ncollapse\nsnapshot" }' $1 

echo exit
