#! /usr/bin/bash

#ARG1 - RG/Sample name
#ARG2 - Input BAM
#ARG3 - Output BAM name
 
java -Xmx4g -jar ~/bin/AddOrReplaceReadGroups.jar INPUT=$2 OUTPUT=$3 RGID=$1 RGLB=$1 RGPL=illumina RGSM=$1 RGPU=Einstein VALIDATION_STRINGENCY=SILENT