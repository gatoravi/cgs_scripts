#Avinash Ramu, WUSTL
#Summary: Calculate coverage of BAM files over positions specified
#Arguments: $1 - BAM file coverage is to be calculated, $2 - op file

#! /usr/bin/bash



ip=$1
op=$2
ref=$3

java -Xmx4g -jar ~/bin/GenomeAnalysisTK.jar -R $ref -T DepthOfCoverage --validation_strictness SILENT -o $op -I $ip -baseCounts -omitLocusTable -omitIntervals