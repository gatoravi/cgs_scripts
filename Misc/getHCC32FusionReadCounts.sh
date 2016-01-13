#! /bin/bash
#
#ARG1 - BAM
#ARG2 - chromosome
#ARG3 - breakpoint start
#ARG4 - breakpoint end

BAM=$1

samtools view $BAM 19:14220615-14222615 > t1
samtools view $BAM 19:14626887-14628887 > t2
echo "Number of encompassing reads "
cat t1 t2 | awk '$9>400000||$9<-400000' | sort -k1 | grep -v 'SA:' | cut -f1 | uniq -c | awk '$1==2' | wc -l   #this is the number of encompassing reads. = 117
echo "Number of spanning reads "
cat t1 t2 | grep 'SA:Z:19,14627888\|SA:Z:19,142' | cut -f1 | sort -u | wc -l #number of encompassing reads = 358
