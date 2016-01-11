GATK=~/files/Src/GATK/GenomeAnalysisTK-2.1-8-g5efb575/GenomeAnalysisTK.jar
REF=~/files/20110915_CEUtrio/WEx/ref/hs37d5.fa
VCF=$1

echo $VCF

java -Xmx4g -jar ${GATK} \
   -T VariantRecalibrator \
   -R ${REF} \
   --input ${VCF} \
   -an QD -an HaplotypeScore -an MQRankSum -an ReadPosRankSum -an FS -an MQ  \
   -mode SNP \
   -recalFile ${VCF}.recal \
   -tranchesFile ${VCF}.tranches \
   -rscriptFile ${VCF}.plots.R \
   -nt 10 \
   -resource:hapmap,known=false,training=true,truth=true,prior=15.0 ~/Dat/hapmap_3.3.b37.vcf \
   -resource:omni,known=false,training=true,truth=false,prior=12.0 ~/Dat/1000G_omni2.5.b37.vcf \
   -resource:dbsnp,known=true,training=false,truth=false,prior=6.0 ~/Dat/dbsnp_137.b37.vcf \
