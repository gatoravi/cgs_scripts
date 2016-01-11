#! /bin/python
import gzip
from itertools import izip
import sys
import Bio.SeqIO as SeqIO


def help():
    print "Takes two gzipped ead fastqs and one gzipped index fastq and one specific index and splits the reads into separate fastq files based on the index."
    print "Arg1 - read fastq1 of pair"
    print "Arg2 - read fastq2 of pair"
    print "Arg3 - index fastq"
    sys.exit()

def main():
    readfastq1 = sys.argv[1]
    readfastq2 = sys.argv[2]
    indexfile = sys.argv[3]
    indexString = sys.argv[4]
    f_rfq1 = gzip.open(readfastq1, 'rb')
    f_rfq2 = gzip.open(readfastq2, 'rb')

    of_rfq1 = gzip.open(indexString + "_" + "read1.fq.gz", 'wb')
    of_rfq2 = gzip.open(indexString + "_" + "read2.fq.gz", 'wb')

    f_i = gzip.open(indexfile, 'rb')
    r1_parse = SeqIO.parse(f_rfq1,'fastq')
    r2_parse = SeqIO.parse(f_rfq2,'fastq')
    i_parse = SeqIO.parse(f_i,'fastq')
    for (r1,r2,i) in izip(r1_parse, r2_parse, i_parse):
        if(str(i.seq).startswith(indexString)):
            SeqIO.write(r1, of_rfq1, 'fastq')
            SeqIO.write(r2, of_rfq2, 'fastq')



if __name__ == "__main__":
    main()
