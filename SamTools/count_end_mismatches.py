#! /usr/bin/env python

import sys
import re

def usage():
    print "python count_end_mismatches.py samtools0.1.18_output.txt"

def main():
    pileup = sys.argv[1]
    end_mismatch_pattern = re.compile('\^.[ACGTacgt]|\$[ACGTacgt]')
    mismatch_pattern = re.compile('[ACGTacgt]')
    #Print the header
    print "\t".join(["chr", "pos", "total_depth", "n_total_mismatches", "n_end_mismatches", \
            "n_end_mismatches/n_total_mismatches", "end_mismatch_pileup"])
    with open(pileup) as f:
        for line in f:
            fields = line.split()
            chr, pos = fields[0:2]
            depth = fields[3]
            pileup = fields[4]
            end_mismatches = end_mismatch_pattern.findall(pileup)
            mismatches = mismatch_pattern.findall(pileup)
            if len(end_mismatches) > 0:
                print "\t".join([str(x) for x in [chr, pos, depth, len(mismatches), len(end_mismatches), \
                        len(end_mismatches)/float(len(mismatches)), end_mismatches]])

main()
