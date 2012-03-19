#Feb 21 2012
#Avinash Ramu, WUSTL
#Synopsis - Find columns of one file which are present in another.
#Arguments - ARG1 is the validated positions file, col1 is chr col2 is pos
#            ARG2 is the DNG op positions file, col1 is chr col2 is pos, col3 is the posterior prob
#Output - Modified table-  ARG1_modified

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

f1 = open(sys.argv[1], 'r')
for line1 in f1:
    count1 +=1
    line1 = line1.rstrip('\n')
    chr1, pos1 = line1.split('\t', 1)
    f2 = open(sys.argv[2], 'r')
    for line2 in f2:
        line2 = line2.rstrip('\n')
#        chr2, pos2, PP = [int(x) for x in line2.split('\t', 2)]
        chr2, pos2, PP = line2.split('\t', 2)
#        chr2 = int(chr2)
#        pos2 = int(pos2)
        PP = float(PP)
        if (firstTime==0):
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
                
#        print chr1+":\t:"+pos1+":\t:"+chr2+":\t:"+pos2
        if (chr1==chr2 and pos1==pos2):
            print chr1+"\t"+pos1+"\t"+str(PP)
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
    firstTime=1

print "The number of validated positive positions is: "+str(count1)
print "The number of DNG calls is: "+str(count2)
print "The number of common validated positive positions is: "+str(common_count)
print "The number of common validated positive positions (PP=1) is: "+str(c_1)+" total is: "+str(t_c_1)
print "The number of common validated positive positions (PP>0.5) is: "+str(c_p5)+" total is: "+str(t_c_p5)
print "The number of common validated positive positions (PP>0.1) is: "+str(c_p1)+" total is: "+str(t_c_p1)
print "The number of common validated positive positions (PP>0.01) is: "+str(c_p01)+" total is: "+str(t_c_p01)
print "The number of common validated positive positions (PP>0.001) is: "+str(c_p001)+" total is: "+str(t_c_p001)
print "The number of common validated positive positions (PP>0.0001) is: "+str(c_p0001)+" total is: "+str(t_c_p0001)

f1.close()
f2.close()

