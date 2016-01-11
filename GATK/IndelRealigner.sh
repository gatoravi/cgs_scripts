#Avinash Ramu, WUSTL
#Realign a BAM file using the GATK realigner.
#ARG1 - BAM file
#There are 2 steps to the realignment process:
#1. Determining (small) suspicious intervals which are likely in need of realignment (RealignerTargetCreator)
#2. Running the realigner over those intervals (see the IndelRealigner tool)

ref=/home/dclab/aramu/files/20110915_CEUtrio/WEx/ref/hs37d5.fa
ip=$1
GATK=/home/dclab/aramu/bin/GenomeAnalysisTK.jar


#Step1
java -Xmx4g -jar $GATK  -T RealignerTargetCreator  -R $ref  -I $ip  -o ${ip}.IR.intervals 
 
#Step2
java -Xmx4g -jar $GATK -T IndelRealigner -R $ref -I ${ip} -targetIntervals ${ip}.IR.intervals -o ${ip}.realignedBam.bam 
