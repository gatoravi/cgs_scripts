#Avinash Ramu, WUSTL
#Get the lengths of the VNTR alleles in mom, dad and child
#ARG1 - DNGop file 

#! /bin/python
import sys


dng_f = sys.argv[1]
f_dng_f = open(sys.argv[1])

for l in f_dng_f:
    l = l.rstrip()
    fields = l.split()
    i = 0
    alleles = []
    for field in fields:
        if fields[i] == "ref_name:":
            chr = fields[i+1]
            sys.stdout.write(chr)
            sys.stdout.write(" ")
        if fields[i] == "coor:":
            pos = fields[i+1]
            sys.stdout.write(pos)
            sys.stdout.write(" ")
        if fields[i] == "ref_base:":
            ref = fields[i+1]
            alleles.append(ref)
        if fields[i] == "ALT:":
            alts = fields[i+1].split(",")
            for alt in alts:
                alleles.append(alt)
        if fields[i] == "tgt_denovo:":
            denovo_gt = fields[i+1]
            sys.stdout.write(denovo_gt)
        i += 1
    sys.stdout.write(" ")
    gts = denovo_gt.split("/")
    for gt in gts:
        allele_indices = gt.split(",")
        for allele_index in allele_indices:
            #sys.stdout.write(allele_index + " " + alleles[int(allele_index)] + " " + str(len(alleles[int(allele_index)])))
            sys.stdout.write(str(len(alleles[int(allele_index)])))
            sys.stdout.write(" ")
    sys.stdout.write("\n")
    #print alleles
    


