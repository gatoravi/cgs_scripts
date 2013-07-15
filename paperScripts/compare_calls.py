#Feb 21 2012
#Avinash Ramu, WUSTL
#Synopsis - Find columns of one file which are present in another.
#Arguments - ARG1 is the validated germline positions file, col1 is chr col2 is pos
#            ARG2 is the validated somatic positions file, col1 is chr col2 is pos
#            ARG3 is the validated falsepositive positions file, col1 is chr col2 is pos
#            ARG4 is the DNG op positions file, col1 is chr col2 is pos, col3 is originial score, col4 is the posterior prob
#Output      The output is a table that summarises the validated calls for diff posterior probs
#Updated 3/8/2012 - Change the specificity calcln to no of validated falsepos/(no of validated false pos + no of validated germlines + no of validated somatics)
#Updated 09/20 - 4th column is PP as opposed to third column, changed sensitivity calc to FDR .
# FDR_old = FP/(TP+FP), FDR_new = FP-TP/(FP)

#! /usr/bin/python

import sys


common_count = 0 #variable to hold count of common positions

count1 = 0
count2 = 0
pp1_cutoff = 0.95
t_c_1 = 0 # total count of PP = 1
t_c_p75 = 0 # total count of PP > 0.75
t_c_p5 = 0 # total count of PP > 0.5
t_c_p1 = 0 # total count of PP > 0.1
t_c_p01 = 0 # total count of PP > 0.01
t_c_p001 = 0 # total count of PP > 0.001
t_c_p0001 = 0 # total count of PP > 0.0001


firstTime=0

DNMcalls_hash = {}
f4 = open(sys.argv[4], 'r') #Open DNG calls file
for line2 in f4:
    line2 = line2.rstrip('\n')
    chr2, pos2, junk,  PP = line2.split('\t', 3)
    PP = float(PP)
    count2 +=1
    if (PP > pp1_cutoff):
        t_c_1 += 1
        t_c_p75 += 1
        t_c_p5 += 1
        t_c_p1 += 1
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP >= 0.9):
        t_c_p75 +=1
        t_c_p5 +=1
        t_c_p1 += 1
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP >= 0.8):
        t_c_p5 +=1
        t_c_p1 += 1
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP >= 0.7):
        t_c_p1 += 1
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP >= 0.6):
        t_c_p01 += 1
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP >= 0.5):
        t_c_p001 += 1
        t_c_p0001 += 1
    elif (PP >= 0.0001):
        t_c_p0001 += 1
     
    DNMcalls_hash[chr2+":"+pos2]=PP # Create a hash of all DNM calls

print "#The size of the DNM hash is "+str(len(DNMcalls_hash))

f1 = open(sys.argv[1], 'r') # open germline file
fout_c = open("germline_validated_called", 'w') # validated positions called by DNG
fout_u = open("germline_validated_notCalled", 'w') # validated positions not called by DNG

g_c_1 = 0 # count of PP = 1
g_c_p75 = 0 # count of PP > 0.75
g_c_p5 = 0 # count of PP > 0.5
g_c_p1 = 0 # count of PP > 0.1
g_c_p01 = 0 # count of PP > 0.01
g_c_p001 = 0 # count of PP > 0.001
g_c_p0001 = 0 # count of PP > 0.0001


for line1 in f1:
    count1 +=1
    line1 = line1.rstrip('\n')
    chr1, pos1 = line1.split('\t', 1)
    if (DNMcalls_hash.has_key(chr1+":"+pos1)): #check if validated site in hash table
        PP = DNMcalls_hash[chr1+":"+pos1]
        fout_c.write(chr1+"\t"+pos1+"\t"+str(PP)+"\n")
        #print chr1+"\t"+pos1+"\t"+str(PP)
        common_count += 1
        if (PP > pp1_cutoff):
            g_c_1 += 1
            g_c_p75 += 1
            g_c_p5 += 1
            g_c_p1 += 1
            g_c_p01 += 1
            g_c_p001 += 1
            g_c_p0001 += 1
        elif (PP >= 0.9):
            g_c_p75 +=1
            g_c_p5 +=1
            g_c_p1 += 1
            g_c_p01 += 1
            g_c_p001 += 1
            g_c_p0001 += 1
        elif (PP >= 0.8):
            g_c_p5 +=1
            g_c_p1 += 1
            g_c_p01 += 1
            g_c_p001 += 1
            g_c_p0001 += 1
        elif (PP >= 0.7):
            g_c_p1 += 1
            g_c_p01 += 1
            g_c_p001 += 1
            g_c_p0001 += 1
        elif (PP >= 0.6):
            g_c_p01 += 1
            g_c_p001 += 1
            g_c_p0001 += 1
        elif (PP >= 0.5):
            g_c_p001 += 1
            g_c_p0001 += 1
        elif (PP >= 0.0001):
            g_c_p0001 += 1
    else:
        fout_u.write(chr1+"\t"+pos1+"\n")
print "#The number of validated germline positions is: "+str(count1)
n_ger=count1
#print "#The number of DNG calls is: "+str(count2)
#print "#PP\tValidatedGermlineCalls\tTotalCalls"
#print "=1.0\t"+str(g_c_1)+"\t"+str(t_c_1)
#print ">0.5\t"+str(g_c_p5)+"\t"+str(t_c_p5)
#print ">0.1\t"+str(g_c_p1)+"\t"+str(t_c_p1)
#print ">0.01\t"+str(g_c_p01)+"\t"+str(t_c_p01)
#print ">0.001\t"+str(g_c_p001)+"\t"+str(t_c_p001)
#print ">0.0001\t"+str(g_c_p0001)+"\t"+str(t_c_p0001)
#print "#Total\t"+str(common_count)+"\t"+str(count2)

f4.close()
f1.close()
fout_c.close()
fout_u.close()


common_count = 0 #variable to hold count of common positions

count1 = 0


s_c_1 = 0 # count of PP = 1
s_c_p75 = 0 # count of PP > 0.75
s_c_p5 = 0 # count of PP > 0.5
s_c_p1 = 0 # count of PP > 0.1
s_c_p01 = 0 # count of PP > 0.01
s_c_p001 = 0 # count of PP > 0.001
s_c_p0001 = 0 # count of PP > 0.0001

firstTime=0
f2 = open(sys.argv[2], 'r') # open somatic validated file
fout_c = open("somatic_validated_called", 'w') # validated positions called by DNG
fout_u = open("somatic_validated_notCalled", 'w') # validated positions not called by DNG

for line1 in f2:
    count1 += 1
    line1 = line1.rstrip('\n')
    chr1, pos1 = line1.split('\t', 1)
    if (DNMcalls_hash.has_key(chr1+":"+pos1)): #check if validated site in hash table
        PP = DNMcalls_hash[chr1+":"+pos1]
        fout_c.write(chr1+"\t"+pos1+"\t"+str(PP)+"\n")
        #print chr1+"\t"+pos1+"\t"+str(PP)
        common_count += 1
        if (PP > pp1_cutoff): #if (PP == 1.0):
            s_c_1 += 1
            s_c_p75 += 1
            s_c_p5 += 1
            s_c_p1 += 1
            s_c_p01 += 1
            s_c_p001 += 1
            s_c_p0001 += 1
        elif (PP >= 0.9):
            s_c_p75 +=1
            s_c_p5 +=1
            s_c_p1 += 1
            s_c_p01 += 1
            s_c_p001 += 1
            s_c_p0001 += 1
        elif (PP >= 0.8):
            s_c_p5 +=1
            s_c_p1 += 1
            s_c_p01 += 1
            s_c_p001 += 1
            s_c_p0001 += 1
        elif (PP >= 0.7):
            s_c_p1 += 1
            s_c_p01 += 1
            s_c_p001 += 1
            s_c_p0001 += 1
        elif (PP >= 0.6):
            s_c_p01 += 1
            s_c_p001 += 1
            s_c_p0001 += 1
        elif (PP >= 0.5):
            s_c_p001 += 1
            s_c_p0001 += 1
        elif (PP >= 0.0001):
            s_c_p0001 += 1
    else:
        fout_u.write(chr1+"\t"+pos1+"\n")

print "#The number of validated somatic positions is: "+str(count1)
n_som=count1
#print "#The number of DNG calls is: "+str(count2)
#print "#PP\tValidatedSomaticCalls\tTotalCalls"
#print "=1.0\t"+str(s_c_1)+"\t"+str(t_c_1)
#print ">0.5\t"+str(s_c_p5)+"\t"+str(t_c_p5)
#print ">0.1\t"+str(s_c_p1)+"\t"+str(t_c_p1)
#print ">0.01\t"+str(s_c_p01)+"\t"+str(t_c_p01)
#print ">0.001\t"+str(s_c_p001)+"\t"+str(t_c_p001)
#print ">0.0001\t"+str(s_c_p0001)+"\t"+str(t_c_p0001)
#print "#Total\t"+str(common_count)+"\t"+str(count2)

f2.close()
fout_c.close()
fout_u.close()

common_count = 0 #variable to hold count of common positions

count1 = 0


fp_c_1 = 0 # count of PP = 1
fp_c_p75 = 0 # count of PP > 0.75
fp_c_p5 = 0 # count of PP > 0.5
fp_c_p1 = 0 # count of PP > 0.1
fp_c_p01 = 0 # count of PP > 0.01
fp_c_p001 = 0 # count of PP > 0.001
fp_c_p0001 = 0 # count of PP > 0.0001

firstTime=0


f3 = open(sys.argv[3], 'r')
fout_c = open("FP_validated_called", 'w') # validated positions called by DNG
fout_u = open("FP_validated_notCalled", 'w') # validated positions not called by DNG

for line1 in f3:
    count1 +=1
    line1 = line1.rstrip('\n')
    chr1, pos1 = line1.split('\t', 1)
    if (DNMcalls_hash.has_key(chr1+":"+pos1)): #check if validated site in hash table
        PP = DNMcalls_hash[chr1+":"+pos1]
        fout_c.write(chr1+"\t"+pos1+"\t"+str(PP)+"\n")
        #print chr1+"\t"+pos1+"\t"+str(PP)
        common_count += 1
        if (PP > pp1_cutoff):#if (PP == 1.0):
            fp_c_1 += 1
            fp_c_p75 += 1
            fp_c_p5 += 1
            fp_c_p1 += 1
            fp_c_p01 += 1
            fp_c_p001 += 1
            fp_c_p0001 += 1
        elif (PP >= 0.9):
            fp_c_p75 +=1
            fp_c_p5 +=1
            fp_c_p1 += 1
            fp_c_p01 += 1
            fp_c_p001 += 1
            fp_c_p0001 += 1
        elif (PP >= 0.8):
            fp_c_p5 +=1
            fp_c_p1 += 1
            fp_c_p01 += 1
            fp_c_p001 += 1
            fp_c_p0001 += 1
        elif (PP >= 0.7):
            fp_c_p1 += 1
            fp_c_p01 += 1
            fp_c_p001 += 1
            fp_c_p0001 += 1
        elif (PP >= 0.6):
            fp_c_p01 += 1
            fp_c_p001 += 1
            fp_c_p0001 += 1
        elif (PP >= 0.5):
            fp_c_p001 += 1
            fp_c_p0001 += 1
        elif (PP >= 0.0001):
            fp_c_p0001 += 1
    else:
        fout_u.write(chr1+"\t"+pos1+"\t"+"\n")
print "#The number of validated FPs is: "+str(count1)
n_fp = count1
#print "#The number of DNG calls is: "+str(count2)
#print "#PP\tValidatedFPCalls(FP)\tTotalCalls"
#print "=1.0\t"+str(fp_c_1)+"\t"+str(t_c_1)
#print ">0.5\t"+str(fp_c_p5)+"\t"+str(t_c_p5)
#print ">0.1\t"+str(fp_c_p1)+"\t"+str(t_c_p1)
#print ">0.01\t"+str(fp_c_p01)+"\t"+str(t_c_p01)
#print ">0.001\t"+str(fp_c_p001)+"\t"+str(t_c_p001)
#print ">0.0001\t"+str(fp_c_p0001)+"\t"+str(t_c_p0001)
#print "#Total\t"+str(common_count)+"\t"+str(count2)

f3.close()
fout_c.close()
fout_u.close()

#HEADER
#print "PP_cutoff\tValidatedGermlineCalls\tValidatedSomaticCalls\tValidatedFPCalls(FP)\tTotalCalls\tGermlineSens\tSomaticSens\tSpecificity" 
print "#pp1_cutoff\t"+str(pp1_cutoff)
print "#PP_cutoff\tValidatedGermlineCalls\tValidatedSomaticCalls\tValidatedFPCalls(FP)\tTotalCalls\tGermlineSens\tSomaticSens\tFDR" 
#print "#PP_cutoff\tValidatedGermlineCalls\tValidatedSomaticCalls\tValidatedFPCalls(FP)\tTotalCalls\tGermlineSens\tSomaticSens\tFDR_old\tFDR" 


#print"sens_denom is "+str(sens_denom)


## Previous calculation
#print "0.0001\t"+str(g_c_p0001)+"\t"+str(s_c_p0001)+"\t"+str(fp_c_p0001)+"\t"+str(t_c_p0001)+"\t"+str(float(g_c_p0001)/float(n_ger))+"\t"+str(float(s_c_p0001)/float(n_som))+"\t"+str(float(fp_c_p0001)/float(sens_denom))

#New calculation
sens_denom=int(g_c_p0001)+int(s_c_p0001)+int(fp_c_p0001)

if sens_denom != 0:
    new_FDR=float(int(t_c_p0001)- int(g_c_p0001) - int(s_c_p0001))/float(t_c_p0001)
    print "0.0001\t"+str(g_c_p0001)+"\t"+str(s_c_p0001)+"\t"+str(fp_c_p0001)+"\t"+str(t_c_p0001)+"\t"+str(float(g_c_p0001)/float(n_ger))+"\t"+str(float(s_c_p0001)/float(n_som))+"\t"+str(new_FDR)
else:
        print "0.0001\t"+str(g_c_p0001)+"\t"+str(s_c_p0001)+"\t"+str(fp_c_p0001)+"\t"+str(t_c_p0001)+"\t"+str(float(g_c_p0001)/float(n_ger))+"\t"+str(float(s_c_p0001)/float(n_som))+"\tINF"
#print "0.0001\t"+str(g_c_p0001)+"\t"+str(s_c_p0001)+"\t"+str(fp_c_p0001)+"\t"+str(t_c_p0001)+"\t"+str(float(g_c_p0001)/float(n_ger))+"\t"+str(float(s_c_p0001)/float(n_som))+"\t"+str(float(fp_c_p0001)/float(sens_denom))+"\t"+str(new_FDR)

sens_denom=g_c_p001+s_c_p001+fp_c_p001
if sens_denom != 0:
    new_FDR=float(int(t_c_p001)- int(g_c_p001) - int(s_c_p001))/float(t_c_p001)
    print "0.5\t"+str(g_c_p001)+"\t"+str(s_c_p001)+"\t"+str(fp_c_p001)+"\t"+str(t_c_p001)+"\t"+str(float(g_c_p001)/float(n_ger))+"\t"+str(float(s_c_p001)/float(n_som))+"\t"+str(new_FDR)
else:
    print "0.5\t"+str(g_c_p001)+"\t"+str(s_c_p001)+"\t"+str(fp_c_p001)+"\t"+str(t_c_p001)+"\t"+str(float(g_c_p001)/float(n_ger))+"\t"+str(float(s_c_p001)/float(n_som))+"\tINF"

sens_denom=g_c_p01+s_c_p01+fp_c_p01
if sens_denom != 0:
    new_FDR=float(int(t_c_p01)- int(g_c_p01) - int(s_c_p01))/float(t_c_p01)
    print "0.6\t"+str(g_c_p01)+"\t"+str(s_c_p01)+"\t"+str(fp_c_p01)+"\t"+str(t_c_p01)+"\t"+str(float(g_c_p01)/float(n_ger))+"\t"+str(float(s_c_p01)/float(n_som))+"\t"+str(new_FDR)
else:
    print "0.6\t"+str(g_c_p01)+"\t"+str(s_c_p01)+"\t"+str(fp_c_p01)+"\t"+str(t_c_p01)+"\t"+str(float(g_c_p01)/float(n_ger))+"\t"+str(float(s_c_p01)/float(n_som))+"\tINF"

sens_denom=g_c_p1+s_c_p1+fp_c_p1
if sens_denom != 0:
    new_FDR=float(int(t_c_p1)- int(g_c_p1) - int(s_c_p1))/float(t_c_p1)
    print  ("0.7\t"+str(g_c_p1)+"\t"+str(s_c_p1)+"\t"+str(fp_c_p1)+"\t"+str(t_c_p1)+"\t"+str(float(g_c_p1)/float(n_ger))+"\t"+str( float(s_c_p1)/float(n_som))+"\t"+str(new_FDR))
else:
        print "0.7\t"+str(g_c_p1)+"\t"+str(s_c_p1)+"\t"+str(fp_c_p1)+"\t"+str(t_c_p1)+"\t"+str(float(g_c_p1)/float(n_ger))+"\t"+str(float(s_c_p1)/float(n_som))+"\tINF"


sens_denom=g_c_p5+s_c_p5+fp_c_p5
if sens_denom != 0:
    new_FDR=float(int(t_c_p5)- int(g_c_p5) - int(s_c_p5))/float(t_c_p5)
    print "0.8\t"+str(g_c_p5)+"\t"+str(s_c_p5)+"\t"+str(fp_c_p5)+"\t"+str(t_c_p5)+"\t"+str(float(g_c_p5)/float(n_ger))+"\t"+str(float(s_c_p5)/float(n_som))+"\t"+str(new_FDR)
else:
        print "0.8\t"+str(g_c_p5)+"\t"+str(s_c_p5)+"\t"+str(fp_c_p5)+"\t"+str(t_c_p5)+"\t"+str(float(g_c_p5)/float(n_ger))+"\t"+str(float(s_c_p5)/float(n_som))+"\tINF"

sens_denom=g_c_p75+s_c_p75+fp_c_p75
if sens_denom != 0:
    new_FDR=float(int(t_c_p75)- int(g_c_p75) - int(s_c_p75))/float(t_c_p75)
    print "0.9\t"+str(g_c_p75)+"\t"+str(s_c_p75)+"\t"+str(fp_c_p75)+"\t"+str(t_c_p75)+"\t"+str(float(g_c_p75)/float(n_ger))+"\t"+str(float(s_c_p75)/float(n_som))+"\t"+str(new_FDR)
else:
    print "0.9\t"+str(g_c_p75)+"\t"+str(s_c_p75)+"\t"+str(fp_c_p75)+"\t"+str(t_c_p75)+"\t"+str(float(g_c_p75)/float(n_ger))+"\t"+str(float(s_c_p75)/float(n_som))+"\tINF"

sens_denom=g_c_1+s_c_1+fp_c_1
if sens_denom != 0:
    new_FDR=float(int(t_c_1)- int(g_c_1) - int(s_c_1))/float(t_c_1)
    print "1.0\t"+str(g_c_1)+"\t"+str(s_c_1)+"\t"+str(fp_c_1)+"\t"+str(t_c_1)+"\t"+str(float(g_c_1)/float(n_ger))+"\t"+str(float(s_c_1)/float(n_som))+"\t"+str(new_FDR)
else:
        print "1.0\t"+str(g_c_1)+"\t"+str(s_c_1)+"\t"+str(fp_c_1)+"\t"+str(t_c_1)+"\t"+str(float(g_c_1)/float(n_ger))+"\t"+str(float(s_c_1)/float(n_som))+"\tINF"



