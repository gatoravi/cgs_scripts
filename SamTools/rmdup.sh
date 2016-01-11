#Remove duplicates using Samtools
#Arg 1 - BAM, ARG2 - sample Name


samtools rmdup $1 ${2}.rmdup.bam