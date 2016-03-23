##simulate_bam_reads.py
rm -f simulated_hets.bam && python simulate_bam_reads.py  ~/dat/ref/hs37d5/all_sequences.fa 0.5 1:100000 1:100200 | samtools view  -bh > simulated_hets.bam && samtools index simulated_hets.bam
rm -f simulated_hets.bam && python simulate_bam_reads.py  ~/dat/ref/hs37d5/all_sequences.fa 1.0 1:100000 1:100200 | samtools view  -bh > simulated_hets_2.bam && samtools index simulated_hets_2.bam
