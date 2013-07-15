#Avinash Ramu, Conrad Lab, WUSTL
#Summary - Create an IGV batch file for a set of BAMs and a list of positions
#ARG1 - list of BAM files, one BAM per line
#ARG2 - list of positions, column1 is of the form chr:pos, the remaining columns can be anything

#! /bin/python

import sys, getopt, re

def main():
    print "hello"
    try:
        opts, args = getopt.getopt(sys.argv[1:],"", ["bam_list=", "pos_list="])
    except getopt.GetoptError as err:
        print str(err)
        sys.exit(2)
#    print opts, args
    for a, v in opts:
        print a, v
        if a == "--bam_list":
            bamList = v
        elif a == "--pos_list":
            posList = v
        elif a == "--snapshot_directory":
            snapshotDirectory = v
    print "new"
    printBAMs(bamList)
    printLoci(posList)
    print "exit"

#print "snapShotDirectory 

def printBAMs(bamList):
    freader = open(bamList)
    for bam in freader:
        bam = bam.rstrip('\n')
        print "load ", bam


def printLoci(posList):
    freader = open(posList)
    for locus in freader:
        locus = locus.rstrip('\n')
        fields = locus.split()
        locus = re.sub(":", "_", fields[0])
        print "goto ", fields[0]
        print "sort position\ncollapse\nsnapshot " + locus + ".png\n"
        



if __name__ == "__main__":
    main()
