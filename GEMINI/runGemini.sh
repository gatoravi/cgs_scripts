#VEP is on clia1 here - /opt/gms/vep/variant_effect_predictor

INPUT_VCF=snvs.vcf.gz
VCFTOOLS_PREFIX=snvs_filteredDP10
VCFTOOLS_VCF=snvs_filteredDP10.recode.vcf
VEP_OUTPUT=snvs_annotated.vcf
VEP_OUTPUT_GZ=snvs_annotated.vcf.gz
VEP_STATS=vep_stats.html
GEMINI_DB=GTB15.db

#Filter input VCF based on depth
#vcftools --min-meanDP 10 --gzvcf ${INPUT_VCF} --out ${VCFTOOLS_PREFIX} --recode

#another example with required VEP annotations for GEMINI
#rm -f ${VEP_OUTPUT} ${VEP_STATS}
#PERL5LIB=$PERL5LIB:/opt/gms/vep/ perl /opt/gms/vep/variant_effect_predictor/variant_effect_predictor.pl -i ${VCFTOOLS_VCF} --cache --sift b --polyphen b --symbol --numbers --biotype --gmaf --maf_1kg --maf_esp --maf_exac --total_length -o ${VEP_OUTPUT} --vcf --fields Consequence,Codons,Amino_acids,Gene,SYMBOL,Feature,EXON,PolyPhen,SIFT,Protein_position,BIOTYPE,ExAC_MAF,GMAF --dir_cache /opt/gms/vep/v83/ --assembly GRCh37 --offline --stats_file ${VEP_STATS} --fork 20

#Index the VCF file with tabix
#tabix -f -p vcf ${VEP_OUTPUT_GZ}

#load the VCF into Gemini
#Gemini is installed here - /opt/gms/gemini/bin/gemini
#PATH=$PATH:/opt/gms/gemini/bin gemini load -v ${VEP_OUTPUT_GZ} -t VEP ${GEMINI_DB} --cores 30

#query with clinvar
/opt/gms/gemini/bin/gemini query --header -q "SELECT v.chrom,v.end,v.qual,v.grc,v.gms_illumina,v.in_segdup,v.filter,v.num_het,v.aaf,v.max_aaf_all,v.gene,v.cosmic_ids,v.biotype,v.impact,v.impact_severity,v.aa_change,v.rs_ids,v.sift_pred,v.polyphen_pred,v.cadd_scaled,v.in_omim,v.clinvar_disease_name FROM variants v, gene_summary g WHERE v.gene=g.gene AND  v.qual>='10' AND v.max_aaf_all<='0.01' AND v.is_coding==1 AND v.impact!='synonymous_variant' AND v.impact!='intron' AND v.impact!='downstream' AND v.impact!='upstream' AND v.impact_severity!='LOW' AND v.in_segdup=0 AND v.in_cse=0 AND v.sift_pred!='tolerated' AND v.polyphen_pred!='benign' AND g.in_cosmic_census==1" ${GEMINI_DB}
