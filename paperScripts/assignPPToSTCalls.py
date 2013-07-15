#Avinash Ramu, WUSTL
#Synopsis  - Assign Posterior Probabilities to SamTools calls.
#Arguments - ARG1 is the file with the counts for different PP cutoffs, format PP\tCount
#            ARG2 is the file with all the SamTools calls.

#! /bin/python
import sys
import math   # This will import math module

cutoffFile=sys.argv[1]
cutoffs=[]
callsDict={}

f=open(cutoffFile, 'r')
cutoffs={}

for line in f:
    line=line.rstrip('\n')
    PP, count = line.split('\t', 1)
    cutoffs[PP]=int(count)
    #print line+"\tPP="+PP+"\tCount="+count

cutoffKeys=sorted(cutoffs.iterkeys())
#print cutoffKeys
f.close()


PP_index=len(cutoffKeys)-1 #Index of the PP cutoff
#print "size is "+str(len(cutoffKeys))
CLR_prev =0
call_count = 0
f2=open(sys.argv[2], 'r')    
for line in f2:
    call_count+=1
    line=line.rstrip('\n')
    #print "Line is "+str(line)
    chr1, pos, CLR = line.split('\t', 2)
    #print "CLR = ", CLR
    CLR=int(math.floor(float(CLR)))
    #print str(cutoffs[cutoffKeys[PP_index]]) + "\t" + str(call_count)
    if((call_count <= cutoffs[cutoffKeys[PP_index]]) or (CLR==CLR_prev)): #looks terrible, I concur
        print chr1+"\t"+pos+"\t"+str(CLR)+"\t"+cutoffKeys[PP_index]
        CLR_prev=CLR
    elif(PP_index > 0):
        PP_index -= 1
        print chr1+"\t"+pos+"\t"+str(CLR)+"\t"+cutoffKeys[PP_index]
        CLR_prev=CLR
f2.close()

