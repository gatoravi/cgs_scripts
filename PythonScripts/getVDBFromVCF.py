#Pull out all the fields in the INFO column of the VCF file.
#! /bin/python

import vcf
import sys


vcf_reader = vcf.Reader(open(sys.argv[1], 'r'))

print "#CHR:POS\tVDB\tMQ\tAF1\tFQ";
for record in vcf_reader:
    locus = str(record.CHROM) + ":" + str(record.POS)
    print locus, record.INFO['VDB'], record.INFO['MQ'], record.INFO['AF1'], record.INFO['FQ']
