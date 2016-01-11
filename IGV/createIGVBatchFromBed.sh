#! /usr/bin/bash


#Create a batch file for IGV to take snapshots of regions in a BED file
#Argument - $1 is the BED file

echo new
echo load  ~/files/20110915_CEUtrio/WGS/g1k/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12878.clean.dedup.recal.bam_chr$1.bam
echo load  ~/files/20110915_CEUtrio/WGS/g1k/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12891.clean.dedup.recal.bam_chr$1.bam
echo load  ~/files/20110915_CEUtrio/WGS/g1k/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12892.clean.dedup.recal.bam_chr$1.bam
echo snapshotDirectory IGV_INDELS_noreads/
echo genome hg19
awk '{print "\ngoto "$1":"$2"-"$3"\nsort position "$1":"$2"-"$3"\ncollapse\nsnapshot"}' $1 


