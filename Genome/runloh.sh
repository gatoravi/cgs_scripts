normalbam=$1
tumorbam=$2
echo "WARNING: Using build 37 fasta"
# 1) run varscan
gmt varscan somatic-parallel --tumor-bam $tumorbam --normal-bam $normalbam --output varscan.output --reference /gscmnt/ams1102/info/model_data/2869585698/build106942997/all_sequences.fa
sleep 5
/gscuser/cmiller/usr/bin/bwait -n varscan -s 60

# 2) Filter out false positives:
gmt varscan somatic-parallel-filter --tumor-bam $tumorbam --normal-bam $normalbam --output varscan.output --filter-germline 1 --reference /gscmnt/ams1102/info/model_data/2869585698/build106942997/all_sequences.fa
sleep 5
/gscuser/cmiller/usr/bin//bwait -n varscan -s 60

# 3) Combine germline and LOH calls into one file:
cat varscan.output.*.snp.*.LOH.hc.fpfilter varscan.output.*.snp.*.Germline.hc.fpfilter >varscan.output.snp.combined 

# 4) sort it:
gmt capture sort-by-chr-pos --input varscan.output.snp.combined --output varscan.output.snp.combined.sorted

# 5) Run varscan loh-segments to ID contiguous regions of LOH:
gmt varscan loh-segments --variant-file varscan.output.snp.combined.sorted --output-basename varscan.output.loh

# 6) keep only the regions with high % of LOH and at least 10 contiguous probes. 
perl -nae 'print $_ if $F[4] > 0.95 && $F[3] >= 10' varscan.output.loh.segments.cbs >varscan.output.loh.segments.final

#7 (optional) remove unused files
rm -rf *.Somatic* *.readcounts *.hc *.LOH *.lc *.Germline *.removed *.indel* *.formatted *.hc.err *.other
