#Avinash Ramu, WUSTL
#Annotate denovo variants as germline, somatic, false positive or not_called (CEU, NA12878 based on Don's validation)



#! /bin/python

import sys

ger_val = "/home/dclab/aramu/Dat/NGValdnData/CEU_validated_positive_germline_liftovered"
som_val = "/home/dclab/aramu/Dat/NGValdnData/CEU_validated_positive_somatic_liftovered"
fp_val = "/home/dclab/aramu/Dat/NGValdnData/CEU_validated_negative_liftovered"


f_ger = open(ger_val, 'r')
f_som = open(som_val, 'r')
f_fp = open(fp_val, 'r')
f_calls = open(sys.argv[1], 'r')


ger_sites = {}
som_sites = {}
fp_sites = {}

for l in f_ger:
    chr, pos = l.split()
    ger_sites[chr+pos] = 1


for l in f_som:
    chr, pos = l.split()
    som_sites[chr+pos] = 1


for l in f_fp:
    chr, pos = l.split()
    fp_sites[chr+pos] = 1


for l in f_calls:
    chr, pos = l.split()
    if( chr+pos in ger_sites.keys()):
        sys.stdout.write( chr + "\t" + pos + "\t" +  "germline\n")
    elif( chr+pos in som_sites.keys()):
        sys.stdout.write( chr + "\t" + pos + "\t" +  "somatic\n")
    elif( chr+pos in fp_sites.keys()):
        sys.stdout.write( chr + "\t" + pos + "\t" +  "false_positive\n")
    else:
        sys.stdout.write( chr + "\t" + pos + "\t" +  "not_called\n")
