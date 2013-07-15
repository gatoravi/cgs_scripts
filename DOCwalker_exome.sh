#Avinash Ramu, WUSTL
#Summary: Calculate coverage of BAM files over positions specified
#NOTVALID- Arguments: $1 - list of BAM files where coverage is to be calculated, $2 - list of positions
#The positions are in the format chr:pos-pos

#! /usr/bin/bash

ref=~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa

bamList=./ListFiles/Bams.list
posList=./ListFiles/Pos.list


WG1=~/files/20110915_CEUtrio/WGS/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12878.clean.dedup.recal.bam_chr
WG2=~/files/20110915_CEUtrio/WGS/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12891.clean.dedup.recal.bam_chr
WG3=~/files/20110915_CEUtrio/WGS/bamFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12892.clean.dedup.recal.bam_chr

bam1=$WEx1
bam2=$WEx2
bam3=$WEx3

VNTRPosFile=_ucsc_SR.list
somPosFile=./ListFiles/CEU_s
gerPosFile=./ListFiles/CEU_g
fpPosFile=./ListFiles/CEU_fp

Op=DOCop
gerOp=WEx_NGvalidatedSites_germCov
somOp=WEx_NGvalidatedSites_somCov
fpOp=WEx_NGvalidatedSites_fpCov

#Use this for just a single BAM, POS file
#chr=4
#echo -e $bam1$chr.bam"\n"$bam2$chr.bam"\n"$bam3$chr.bam > $bamList
#java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$Op -I $bamList -L $posList -baseCounts
#mv $chr* CovOP/

#Use this for BAM and POS split by chromosome
for chr in {1..22}
do
    echo $chr
    echo -e $bam1$chr.bam"\n"$bam2$chr.bam"\n"$bam3$chr.bam > $bamList
    #Exome Stuff
    java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$gerOp -I $bamList -L ${gerPosFile}_${chr}.list -baseCounts
    java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$somOp -I $bamList -L ${somPosFile}_${chr}.list -baseCounts
    java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$fpOp -I $bamList -L ${fpPosFile}_${chr}.list -baseCounts
    mv $chr* CovOP/
done





chr=X
echo $chr
echo -e $bam1$chr.bam"\n"$bam2$chr.bam"\n"$bam3$chr.bam > $bamList
#Exome Stuff
java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$gerOp -I $bamList -L ${gerPosFile}_${chr}.list -baseCounts
java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$somOp -I $bamList -L ${somPosFile}_${chr}.list -baseCounts
java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$fpOp -I $bamList -L ${fpPosFile}_${chr}.list -baseCounts
mv $chr* CovOP/