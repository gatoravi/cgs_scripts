#Feb 21 2012
#Avinash Ramu, WUSTL
#Synopsis - Find columns of one file which are present in another.
#Arguments - ARG1 is the validated positions file, col1 is chr col2 is pos
#            ARG2 is the DNG op positions file, col1 is chr col2 is pos, col3 is the posterior prob
#            ARG3 is a string, the class of positions being analyzed can be "germline", "somatic" or "falsepos"


#! /usr/bin/python

import sys

common_count = 0 #variable to hold count of common positions

count1 = 0
count2 = 0

t_c_1 = 0 # total count of PP = 1
t_c_p5 = 0 # total count of PP > 0.5
t_c_p1 = 0 # total count of PP > 0.1
t_c_p01 = 0 # total count of PP > 0.01
t_c_p001 = 0 # total count of PP > 0.001
t_c_p0001 = 0 # total count of PP > 0.0001


c_1 = 0 # count of PP = 1
c_p5 = 0 # count of PP > 0.5
c_p1 = 0 # count of PP > 0.1
c_p01 = 0 # count of PP > 0.01
c_p001 = 0 # count of PP > 0.001
c_p0001 = 0 # count of PP > 0.0001

firstTime=0



DNMcalls_hash = {}
f2 = open(sys.argv[2], 'r')
for line2 in f2:
    line2 = line2.rstrip('\n')
    chr2, pos2, PP = line2.split('\t', 2)
    PP = float(PP)
    count2 +=1
    if (PP == 1.0):
        t_c_1 += 1
        t_c_p5 += 1
        t_c_p1 += 1
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP > 0.5):
        t_c_p5 +=1
        t_c_p1 += 1
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP > 0.1):
        t_c_p1 += 1
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP > 0.01):
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP > 0.001):
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP > 0.0001):
        t_c_p0001 += 1
     
    DNMcalls_hash[chr2+":"+pos2]=PP # Create a hash of all DNM calls

print "#The size of the DNM hash is "+str(len(DNMcalls_hash))

f1 = open(sys.argv[1], 'r')
fout_c = open(sys.argv[3]+"_validated_called", 'w') # validated positions called by DNG
fout_u = open(sys.argv[3]+"_validated_notCalled", 'w') # validated positions not called by DNG

for line1 in f1:
    count1 +=1
    line1 = line1.rstrip('\n')
    chr1, pos1 = line1.split('\t', 1)
    if (DNMcalls_hash.has_key(chr1+":"+pos1)): #check if validated site in hash table
        fout_c.write(chr1+"\t"+pos1+"\t"+str(PP)+"\n")
        PP = DNMcalls_hash[chr1+":"+pos1]
        #print chr1+"\t"+pos1+"\t"+str(PP)
        common_count += 1
        if (PP == 1.0):
            c_1 += 1
            c_p5 += 1
            c_p1 += 1
            c_p01 += 1
            c_p001 += 1
            c_p0001 += 1
        elif (PP > 0.5):
            c_p5 +=1
            c_p1 += 1
            c_p01 += 1
            c_p001 += 1
            c_p0001 += 1
        elif (PP > 0.1):
            c_p1 += 1
            c_p01 += 1
            c_p001 += 1
            c_p0001 += 1
        elif (PP > 0.01):
            c_p01 += 1
            c_p001 += 1
            c_p0001 += 1
        elif (PP > 0.001):
            c_p001 += 1
            c_p0001 += 1
        elif (PP > 0.0001):
            c_p0001 += 1
    else:
        fout_u.write(chr1+"\t"+pos1+"\t"+str(PP)+"\n")
print "#The number of validated negative positions is: "+str(count1)
print "#The number of DNG calls is: "+str(count2)
print "#PP\tValidatedNegativeCalls(FP)\tTotalCalls"
print "=1.0\t"+str(c_1)+"\t"+str(t_c_1)
print ">0.5\t"+str(c_p5)+"\t"+str(t_c_p5)
print ">0.1\t"+str(c_p1)+"\t"+str(t_c_p1)
print ">0.01\t"+str(c_p01)+"\t"+str(t_c_p01)
print ">0.001\t"+str(c_p001)+"\t"+str(t_c_p001)
print ">0.0001\t"+str(c_p0001)+"\t"+str(t_c_p0001)
print "#Total\t"+str(common_count)+"\t"+str(count2)
f1.close()
f2.close()
fout_c.close()
fout_u.close()
