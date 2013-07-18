#! /usr/bin/bash

#Jan 12, 2012
# Convert DNG op to VCF so that it can be used by annovar and other programs 
# $1 is the DNG op


awk '{ print "chr"$6"\t"$8"\t.\t"$10"\t"$12"\t.\t.\t." }' $1 > $1_vcf

# Convert the vcf to Annovar input
perl convert2annovar.pl -format vcf4 $1_vcf > avinput_$1