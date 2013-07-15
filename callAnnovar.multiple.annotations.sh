#! /bin/bash                                                                                                                            
#Author- Avinash Ramu, WUSTL                                                                                                            
#Summary - region based anno using bed files using Annovar                                                                              
# $1 - list of variants to be annotated in Annovar acceptable format                                                                    
#                                                                                                                                       
#! /usr/bin/bash                                                                                                                        

home=/home/dclab/aramu
DB=$home/Dat/Annovar/BED/ #folder with the annotation files
simpleRepeats=ucsc_simpleRepeats.hg19.bed #simple Repeats
segDups=ucsc_segDups.hg19.bed #segmental Duplications
dbSNP=snp137.hg19.bed #dbSNP
dgv=dgv.hg19.bed #Database of Genomic Variation
conradCNV=ng42m_calls_qc_mid_090908.cnves_51_pos.txt_liftovered.bed #CNV's from Don's Nature Genetics papers
vdj=vdj.recombination.hg19.bed #regions of vdj recombination
singleExons=refseq.singleExonGenes.hg19.bed #single Exon genes
#Simple repeats                                                                                                                         
#for class in simpleRepeats segDups dbSNP dgv conradCNV vdj singleExons

for class in simpleRepeats segDups dbSNP dgv conradCNV 
do
    echo $class
    $home/Scripts/annotate_variation.pl --buildver hg19 $1 $DB -bedfile ${!class} -dbtype bed -regionanno -outfile ${1}.${class}.op 
done

cat ${1}.*bed |  awk '{ print $3"\t"$4"\t"$5"\t"$6"\t"$7 }' | sort -u  > ${1}.unique.inAnnotations.txt
cat $1 ${1}.unique.inAnnotations.txt | sort | uniq --count | awk '{ if($1!=2) print $2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7 }' > ${1}.unique.notInAnnotations.txt
perl $home/Scripts/annotate_variation.pl ${1}.unique.notInAnnotations.txt --buildver hg19 $home/Dat/Annovar/humandb/