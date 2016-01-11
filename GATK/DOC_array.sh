#Avinash Ramu, WUSTL
#Summary: Calculate coverage of BAM files over positions specified
#NOTVALID- Arguments: $1 - list of BAM files where coverage is to be calculated, $2 - list of positions
#The positions are in the format chr:pos-pos

#! /usr/bin/bash

ref=~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa

WG1=~/files/20110915_CEUtrio/WGS/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12878.clean.dedup.recal.bam_chr
WG2=~/files/20110915_CEUtrio/WGS/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12891.clean.dedup.recal.bam_chr
WG3=~/files/20110915_CEUtrio/WGS/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12892.clean.dedup.recal.bam_chr

bam1=$WG1
bam2=$WG2
bam3=$WG3


#Use this for BAM and POS split by chromosome

#for chr in {1..22}
#do
    chr=$SGE_TASK_ID
    echo $chr
    bamList=ListFiles/WGS.${chr}.list
    echo -e $bam1$chr.bam"\n"$bam2$chr.bam"\n"$bam3$chr.bam > $bamList
    bash ~/Scripts/DOCwalker.sh $bamList WGS_${chr}_DOC $ref $chr
#done

