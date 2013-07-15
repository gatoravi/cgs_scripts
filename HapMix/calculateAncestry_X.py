#! /bin/python
#Calculate % of African, European Ancestry based on Allele Counts
#ARG1 is the list of samples
#ARG2 is the file with allele counts, n refers to number of  copies from EUR, 
# n can be 0,1,2


import sys
import numpy

cases = []
f1 = open(sys.argv[1])
for l in f1:
    l = l.rstrip("\n")
#    print l
    fields = l.split()
    caseID = fields[0]
    #print caseID
    cases.append(caseID)


f = open(sys.argv[2])
l1 = 1
for l in f:
    l = l.rstrip("\n")
    if l1 == 1:
        EUR = [0]* len(l)
        AFR = [0]* len(l)
        l1 = 0
    s_n = 0
    for c in l:
        EUR[s_n] += int(c)
        AFR[s_n] += 1 - int(c)
        s_n += 1 
f.close()

ancestry = {}
print "SNo\tEUR\tAFR\tEUR(%)\tAFR(%)"
for s in range(len(EUR)):
    print cases[s], str(EUR[s]), str(AFR[s]), str(100.0 - float(AFR[s])/(EUR[s] + AFR[s])*100), str(float(AFR[s])/(EUR[s] + AFR[s])*100)
    ancestry[cases[s]] = {}
    ancestry[cases[s]]["EUR"] = EUR[s]
    ancestry[cases[s]]["AFR"] = AFR[s]
