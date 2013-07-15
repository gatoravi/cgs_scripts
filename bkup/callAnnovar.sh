#! /bin/bash
#Author- Avinash Ramu, WUSTL
#Summary - region based anno using bed files using Annovar
# $1 - list of variants to be annotated in Annovar acceptable format

#! /usr/bin/bash


#Simple Repeats
~/scripts/annotate_variation.pl --buildver hg19 $1 ~/files/db -bedfile ucsc_simplerepeats -dbtype bed -regionanno

#SegDups
~/scripts/annotate_variation.pl --buildver hg19 ${1}2 ~/files/db -bedfile ucsc_segdups -dbtype bed -regionanno

#DbSNP
~/scripts/annotate_variation.pl --buildver hg19 ${1}3 ~/files/db -bedfile dbsnp129_hg19 -dbtype bed -regionanno

#CNVs
~/scripts/annotate_variation.pl --buildver hg19 ${1}4 ~/files/db -bedfile CNVs_hg19 -dbtype bed -regionanno



#Generic DB
# $1 - Database of annotations, $2 - variants
#./annotate_variation.pl --buildver hg19 -filter -dbtype generic -genericdbfile $1 $2 .

#Standard dbSNP database
#./annotate_variation.pl -filter --buildver hg19 -dbtype snp129 INDELS_pp0p1_formatted_annovar humandb/