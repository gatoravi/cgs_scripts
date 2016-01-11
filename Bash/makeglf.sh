# Script to make GLF files from BAMs using a hybrid version of SamTools for Polymutt.
# ARG1 - BAM file

#! /bin/bash
ref=~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa
~/bin/samtools-hybrid view -bh $1 | ~/bin/samtools-hybrid calmd -Abr - $ref 2> /dev/null | ~/bin/samtools-hybrid pileup - -g -f $ref > ${1}.glf