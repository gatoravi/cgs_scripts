#Calculate FST from VCF file
#Avinash Ramu, Conrad Lab, WUSTL
#ARG1 is the VCF file

#! /bin/python

import vcf
import sys


vcf_reader = vcf.Reader(open(sys.argv[1], 'r'))
field = sys.argv[2]
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
        if sample[field] is None:
            GTs.append(0)
        else:
            if(float(sample[field][0] + sample[field][1]) == 0):
                GTs.append(0)
            else:
                GTs.append(float(sample[field][1]/float(sample[field][0] + sample[field][1])))
#            print sample[field][0], sample[field][1]
    sys.stdout.write(locus)
    for gt in GTs:
        sys.stdout.write("\t")
        sys.stdout.write(str(gt))
    sys.stdout.write("\n")
