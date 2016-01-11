#! /bin/bash                                                                                                                            
#Author- Avinash Ramu, WUSTL                                                                                                            
#Summary - region based anno using bed files using Annovar                                                                              
# $1 - list of variants to be annotated in Annovar acceptable format                                                                    
#                                                                                                                                       
#! /usr/bin/bash                                                                                                                        

DB=~/Dat/Annovar/BED/
simpleRepeats=ucsc_simpleRepeats.hg19.bed
segDups=ucsc_segDups.hg19.bed
dbSNP=snp131.hg19.bed
dgv=dgv.hg19.bed
conradCNV=ng42m_calls_qc_mid_090908.cnves_51_pos.txt_liftovered.bed

#Simple repeats                                                                                                                         
~/scripts/annotate_variation.pl --buildver hg19 $1 $DB -bedfile ucsc_simpleRepeats -dbtype bed -regionanno -outfile $1_avop1
awk '{print $3"\t"$4"\t"$5"\t"$6"\t"$7}' $1_avop1.hg19_bed > temp
cp temp $1_simpRep
mv temp $1_avop1
wc -l $1_simpRep