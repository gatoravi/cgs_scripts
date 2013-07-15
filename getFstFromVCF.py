#Calculate FST from VCF file
#ARG1 is the VCF file
#! /bin/python

import vcf
import sys


vcf_reader = vcf.Reader(open(sys.argv[1], 'r'))
for record in vcf_reader:
    locus = str(record.CHROM) + ":" + str(record.POS)
#    print locus, len(record.ALT)
    opLine = locus
    isNone = False
    pooledRefCount = 0
    pooledAltCount = 0
    altFreq = 0
    fst_numerator = 0
    fst_denominator = -1
    nSample = 0
    altCount = 0
    refCount = 0
    for sample in record.samples:
        nSample += 1
        if sample['GT'] is not None and len(record.ALT) == 1:
            #print sample['AD'][0], sample['AD'][1]
            refCount = sample['AD'][0]
            altCount = sample['AD'][1]
            altFreq = float(sample['AD'][1])/float((sample['AD'][1] + sample['AD'][0]))
            opLine += "\t" + str(sample['AD'][0]) + "\t" + str(sample['AD'][1]) + "\t" + str('%.3f' % altFreq)
            fst_numerator += altFreq * (1-altFreq) * (refCount + altCount)
            pooledRefCount += sample['AD'][0]
            pooledAltCount += sample['AD'][1]
        else:
            isNone = True
    if not isNone:
        pooledAltFreq = float(pooledAltCount)/float(pooledAltCount + pooledRefCount)
        if(pooledAltFreq == 1):
            fst = 0
        else:
            #fst_numerator = float(fst_numerator)/float(nSample)
            fst_numerator = float(fst_numerator)/float(pooledAltCount + pooledRefCount)
            fst_denominator = pooledAltFreq * (1-pooledAltFreq)
            fst = 1 - (fst_numerator/fst_denominator)
#            print fst_numerator, fst_denominator, pooledAltFreq, fst, nSample
        print opLine + "\t" + str(pooledRefCount) + "\t" + str(pooledAltCount) + "\t" + str('%.3f' %pooledAltFreq) + "\t" + str('%.3f' %fst)


