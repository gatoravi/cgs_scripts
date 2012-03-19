#Avinash Ramu, WUSTL
#Summary: Calculate coverage of BAM files over positions specified
#NOTVALID- Arguments: $1 - list of BAM files where coverage is to be calculated, $2 - list of positions
#The positions are in the format chr:pos-pos

#! /usr/bin/bash

ref=~/files/20110915_CEUtrio/WEx/ref/hs37d5.fa
bamList=./ListFiles/ExomeBams.list
bam1=~/files/20110915_CEUtrio/WEx/bamFiles/CEUTrio.HiSeq.WEx.b37_decoy.NA12878.
bam2=~/files/20110915_CEUtrio/WEx/bamFiles/CEUTrio.HiSeq.WEx.b37_decoy.NA12891.
bam3=~/files/20110915_CEUtrio/WEx/bamFiles/CEUTrio.HiSeq.WEx.b37_decoy.NA12892.
somPosFile=./ListFiles/CEU_s
gerPosFile=./ListFiles/CEU_g
fpPosFile=./ListFiles/CEU_fp
gerOp=WEx_NGvalidatedSites_germCov
somOp=WEx_NGvalidatedSites_somCov
fpOp=WEx_NGvalidatedSites_fpCov

for chr in {1..22}
do
    echo $chr
    echo -e $bam1$chr.bam"\n"$bam2$chr.bam"\n"$bam3$chr.bam > $bamList
    java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$gerOp -I $bamList -L ${gerPosFile}_${chr}.list -baseCounts
    java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$somOp -I $bamList -L ${somPosFile}_${chr}.list -baseCounts
    java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$fpOp -I $bamList -L ${fpPosFile}_${chr}.list -baseCounts
    mv $chr* $chr* CovOP/
done

chr=X
echo $chr
echo -e $bam1$chr.bam"\n"$bam2$chr.bam"\n"$bam3$chr.bam > $bamList
java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$gerOp -I $bamList -L ${gerPosFile}_${chr}.list -baseCounts
java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$somOp -I $bamList -L ${somPosFile}_${chr}.list -baseCounts
java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage -o $chr.$fpOp -I $bamList -L ${fpPosFile}_${chr}.list -baseCounts
mv $chr* $chr* CovOP/