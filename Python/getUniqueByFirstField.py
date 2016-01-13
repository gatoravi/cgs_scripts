#Avinash Ramu, TGI, WUSTL
#Often we have files where the first column is a key for eg chr:pos,
#this script will attempt to find the sites unique to one file

#!/bin/env python

import sys

filtered = sys.argv[1]
unfiltered = sys.argv[2]
filtered_sites = {}

for l in open(filtered):
    fields = l.split()
    chr = fields[0]
    pos = fields[1]
    filtered_sites[chr+pos] = 1

for l in open(unfiltered):
    l = l.rstrip("\n")
    fields = l.split()
    chr = fields[0]
    pos = fields[1]
    if chr+pos not in filtered_sites.keys():
        print l

