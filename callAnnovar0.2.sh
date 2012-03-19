#! /bin/bash
#Author- Avinash Ramu, WUSTL
#Summary - region based anno using bed files using Annovar
# $1 - list of variants to be annotated in Annovar acceptable format

#! /usr/bin/bash

#Simple repeats
~/scripts/annotate_variation.pl --buildver hg19 $1 ~/files/db -bedfile ucsc_simpleRepeats -dbtype bed -regionanno -outfile $1_avop1
awk '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' $1_avop1.hg19_bed > temp
cp temp $1_simpRep
mv temp $1_avop1
wc -l $1_simpRep

#SegDups
~/scripts/annotate_variation.pl --buildver hg19 $1 ~/files/db -bedfile ucsc_segDups -dbtype bed -regionanno -outfile $1_avop2
awk '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' $1_avop2.hg19_bed > temp
cp temp $1_segDup
mv temp $1_avop2
wc -l $1_segDup

#dbSNP
~/scripts/annotate_variation.pl --buildver hg19 $1 ~/files/db -bedfile dbsnp129_hg19 -dbtype bed -regionanno -outfile $1_avop3
awk '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' $1_avop3.hg19_bed > temp
cp temp $1_dbSNP
mv temp $1_avop3
wc -l $1_dbSNP

#CNVs
~/scripts/annotate_variation.pl --buildver hg19 $1 ~/files/db -bedfile ng42m_calls_qc_mid_090908.cnves_51_pos.txt_liftovered -dbtype bed -regionanno -outfile $1_avop4
awk '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' $1_avop4.hg19_bed > temp
cp temp $1_CNV
mv temp $1_avop4
wc -l $1_CNV


for i in {1..4}
do
    echo $1_avop$i
    cat $1_avop$i >> $1_dropped
    rm $1_avop$i
done

sort -u ${1}_dropped > temp 
awk '{print $1"\t"$2"\t"$3}' $1 > $1_regions
awk '{print $1"\t"$2"\t"$3}' temp > $1_dropped
sort -u $1_dropped > temp
mv temp $1_dropped
fgrep -x -f ${1}_dropped -v $1_regions > ${1}_remaining


#Genomic Superdups
#~/scripts/annotate_variation.pl --buildver hg19 $1 ~/files/db -dbtype segdup -regionanno -outfile $1_avop5
#awk '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' $1_avop5.hg19_genomicSuperDups > temp
#cp temp $1_superDup
#mv temp $1_avop5
#wc -l $1_superDup

#DGV
#~/scripts/annotate_variation.pl --buildver hg19 $1 ~/files/db -dbtype dgv -regionanno -outfile $1_avop6
#awk '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' $1_avop6.hg19_dgv > temp
#cp temp $1_DGV
#mv temp $1_avop6
#wc -l $1_DGV