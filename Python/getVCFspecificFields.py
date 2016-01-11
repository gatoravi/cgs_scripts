#Pull out all the fields in the INFO column of the VCF file.
#ARG1 is the VCF file
#! /bin/python

import vcf
import sys


vcf_reader = vcf.Reader(open(sys.argv[1], 'r'))
infoField = sys.argv[2]
#sampleField = sys.argv[2]

for record in vcf_reader:
    locus = str(record.CHROM) + ":" + str(record.POS)
    if infoField in record.INFO.keys():
           print locus, record.INFO[infoField]
#    for sample in record.samples:
#        if sample[sampleField] is not None :
#            print sample[sampleField]
