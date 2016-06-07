##simulate_bam_reads.py
```bash
rm -f simulated_hets.bam && python simulate_bam_reads.py  ~/dat/ref/hs37d5/all_sequences.fa 0.5 1:100000 1:100200 | samtools view  -bh > simulated_hets.bam && samtools index simulated_hets.bam
rm -f simulated_hets.bam && python simulate_bam_reads.py  ~/dat/ref/hs37d5/all_sequences.fa 1.0 1:100000 1:100200 | samtools view  -bh > simulated_hets_2.bam && samtools index simulated_hets_2.bam
python ~/src/nowarranty/Python/simulate_bam_reads.py  tests/integration-test/data/fa/test_chr22.fa 0.5 22:4050 | samtools view  -bh > simulated_hets.bam && samtools index simulated_hets.bam
samtools cat -o cat_rna.bam tests/integration-test/data/bam/cis_ase_tumor_rna.bam simulated_hets.bam
samtools index cat_rna.bam
samtools cat -o cat_dna.bam tests/integration-test/data/bam/cis_ase_tumor_dna.bam simulated_hets.bam
samtools index cat_dna.bam
```
