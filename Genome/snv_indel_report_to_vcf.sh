#SNV Indel report file
snv_indel_report=$1
echo "SNV Indel report is " $snv_indel_report

#Name of the sample, modify as necessary
sample=GTB15

#Make VCF without INDELs
rm -f $sample.tmp.vcf && awk 'BEGIN { print "##fileformat=VCFv4.1\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO" } !/chr|DEL|INS/ { if($1 !~ /GL/) print $1"\t"$2"\t.\t"$4"\t"$5"\t.\tPASS\t." }' "$snv_indel_report" > $sample.tmp.vcf && mv $sample.tmp.vcf ${sample}_snvs.vcf
#Make VCF with INDELs
rm -f $sample.tmp.vcf && awk 'BEGIN { print "##fileformat=VCFv4.1\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO" } !/chr/ { if($1 !~ /GL/) print $1"\t"$2"\t.\t"$4"\t"$5"\t.\tPASS\t." }'  "$snv_indel_report" > $sample.tmp.vcf && mv $sample.tmp.vcf ${sample}_snvs_indels.vcf
