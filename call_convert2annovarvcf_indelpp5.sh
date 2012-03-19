#! /bin/bash


awk '/DENOVO-INDEL/ {if($26>0.5) print $6"\t"$8"\t.\t"$10"\t"$12"\t"$26"\t.\t."}' $1 > $1.vcf

perl ~/scripts/convert2annovar.pl -format vcf4 $1.vcf -outfile $1.vcf.avinput