#! /bin/bash


#ARG1 - Input BAM                                                                                                            
#ARG2 - Ref
#ARG3 - Output BAM name                                                                                                      

java -Xmx4g -jar ~/bin/ReorderSam.jar INPUT=$1 REFERENCE=$2  OUTPUT=$3 VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true SORT_ORDER=coordinate
