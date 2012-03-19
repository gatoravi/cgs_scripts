#Jan 28 2012
#Avinash Ramu, WUSTL
#Synopsis - Get the DNM allele and DNM count for paired sample read depths table file
#Arguments - ARG1 is the tabel file.
#Output - Modified table-  ARG1_modified
#! /usr/bin/python

import sys
f = open(sys.argv[1], 'r')
windows = []
count = 0
chr_old = 1
pos2 = ""
pos1 = 0
for line in f:
    line = line.rstrip('\n')
    if ':' in line:
        chr_new, pos_new = line.split(':')
        if(chr_new == chr_old):
            if(int(pos_new) - int(pos1) < 300 ):
                pos2 = pos_new
                count = count +1
            elif((pos2 != "") and (count>5)):
                pos1_r = int(int(pos1)/100)*100# round to nearest 100
                pos2_r = int(int(pos2)/100)*100 + 100
                windows.append( chr_old+":"+str(pos1_r)+"-"+str(pos2_r) )
                count=0
                pos1 = pos_new
                pos2 = ""
                #print "\n"   #print line
            else:
                pos1 = pos_new
                count = 0
        elif(pos2 != "" and count>5):
            pos1_r = int(int(pos1)/100)*100# round to nearest 100
            pos2_r = int(int(pos2)/100)*100 + 100
            windows.append( chr_old+":"+str(pos1_r)+"-"+str(pos2_r) )
            count = 0
            chr_old = chr_new
            pos1 = pos_new
            pos2 = ""
            #print "\n"   #print line
        else:
            chr_old = chr_new
            pos1 = pos_new
            pos2 = ""
            count = 0

#print "The number of windows is"+windows.length()
for win1 in windows:
    print win1
