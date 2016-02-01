"""
Fix INDEL ref/alt alleles in a VCF file.
Include the previous base for INDELS and adjust
position accordingly
"""

#! /usr/bin/env python

import sys
from pyfaidx import Fasta

ref = Fasta('/gscmnt/gc2607/mardiswilsonlab/aramu/dat/hs37/all_sequences.fa')

def usage():
    print sys.argv[0] + " input_vcf"

def get_ref(chr1, pos1):
    "Get the reference allele"
    return ref[chr1][pos1].seq

def fix_indel_line(fields):
    "Fix one line of vcf"
    pos_new = int(fields[1]) - 1
    fields[1] = str(pos_new)
    #Reset if empty
    if fields[3] == "-":
        fields[3] = ""
    if fields[4] == "-":
        fields[4] = ""
    new_ref = get_ref(fields[0], pos_new)
    fields[4] = new_ref + fields[4]
    fields[3] = new_ref + fields[3]
    return fields

def fix_vcf(vcf):
    "Fix VCF file"
    with open(vcf) as vcf_fh:
        for line in vcf_fh:
            line = line.rstrip("\n")
            if line[0] == "#":
                print line
                continue
            fields = line.split("\t")
            fixed_fields = []
            if "-" in [fields[3], fields[4]]:
                fixed_fields = fix_indel_line(fields)
                print "\t".join(fixed_fields)
            else:
                print line


def main():
    "Execn starts here"
    if len(sys.argv) < 2:
        usage()
    vcf = sys.argv[1]
    fix_vcf(vcf)

if __name__ == "__main__":
    main()
