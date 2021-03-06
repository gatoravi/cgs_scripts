#Calculate FST from VCF file
#Avinash Ramu, Conrad Lab, WUSTL
#ARG1 is the VCF file

#! /bin/python

import vcf
import sys


vcf_reader = vcf.Reader(open(sys.argv[1], 'r'))
sys.stdout.write("LOCUS")
for sample in vcf_reader.samples:
    sys.stdout.write("\t")
    sys.stdout.write(sample)
sys.stdout.write("\n")
    
for record in vcf_reader:
    locus = str(record.CHROM) + ":" + str(record.POS)
    nSample = 0
    GTs = []
#    print record.samples
    for sample in record.samples:
        nSample += 1
        if sample['GT'] is None:
            GTs.append("./.")
        else:
            GTs.append( sample['GT'])
    sys.stdout.write(locus)
    for gt in GTs:
        sys.stdout.write("\t")
        sys.stdout.write(gt)
    sys.stdout.write("\n")
