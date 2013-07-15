bamList=$1
op=$2

 java -Xmx4g -jar ~/files/Src/GATK/GenomeAnalysisTK-2.1-8-g5efb575/GenomeAnalysisTK.jar -T UnifiedGenotyper -I ${bamList} -R ~/files/20110915_CEUtrio/WEx/ref/hs37d5.fa -o ${op} -nt 10