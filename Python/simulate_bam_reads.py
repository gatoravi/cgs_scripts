#!/usr/bin/env python

import numpy
import sys
from pyfaidx import Fasta

offset = 50 #50 bases before and after

#Keep it simple, just use the complement
mutator = { "A" : "T", "G" : "C", "T" : "A", "C" : "G"}
n_reads = 100

def usage():
    "Print usage info"
    print __file__ + " ~/dat/ref/hs37d5/all_sequences.fa 1.0 1:100000 1:100200"
    print "Note - Assumes all loci are on the same chromosome"

def get_seq(ref_fa, chrom, pos):
    "Get the reference sequence that middles this position"
    reference = Fasta(ref_fa)
    return reference[chrom][pos-offset:pos+offset].seq

def mutate(seq):
    "Complement the base in the middle"
    seq = list(seq)
    seq[len(seq)/2 - 1] = mutator[seq[len(seq)/2 - 1]]
    return "".join(seq)

def get_bq(mean1 = 30, sd1 = 2):
    "Get random base qualities"
    return  "".join([chr(int(x)) for x in numpy.random.normal(mean1, sd1, 2*offset) + 33])

def assemble_read(chrom, pos, seq):
    "Assemble the read without queryname"
    chrom = str(chrom)
    pos = str(pos - offset + 1)
    cigar = str(2 * offset) + "M"
    flag = "0"
    mapq = "255"
    rnext = "*"
    pnext = "0"
    tlen = "0"
    bqs = get_bq()
    return  "\t".join([flag, chrom, pos, mapq,\
                      cigar, rnext, pnext, tlen, seq, bqs])

def print_header(chrom = "1"):
    "Print the BAM header"
    print "@HD\tVN:1.0\tGO:none\tSO:coordinate"
    print "@SQ\tSN:" + chrom + "\tLN:249250621"

def main():
    if len(sys.argv) >= 4:
        ref_fa = sys.argv[1]
        allele_fraction = float(sys.argv[2])
        sys.stderr.write("Allele fraction is " + sys.argv[2] + "\n")
        chrom, pos = sys.argv[3].split(":")
        print_header(chrom)
        for locus in sys.argv[3:]:
            chrom, pos = locus.split(":")
            pos = int(pos)
            seq = get_seq(ref_fa, chrom, pos)
            mutated = mutate(seq)
            wt_read = assemble_read(chrom, pos, seq)
            mut_read = assemble_read(chrom, pos, mutated)
            global read_number
            read_number = 0
            while (read_number < n_reads):
                #coin-toss
                if(numpy.random.uniform(0, 1) >= allele_fraction):
                    read_number = read_number + 1
                    qname = "fake-read:" + str(read_number)
                    print qname + "\t" + mut_read
                else:
                    read_number = read_number + 1
                    qname = "fake-read:" + str(read_number)
                    print qname + "\t" + wt_read
    else:
        usage()

if __name__ == "__main__":
    main()
