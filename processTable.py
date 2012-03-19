#Jan 28 2012
#Avinash Ramu, WUSTL
#Synopsis - Get the DNM allele and DNM count for paired sample read depths table file
#Arguments - ARG1 is the tabel file.
#Output - Modified table-  ARG1_modified
#! /usr/bin/python

import sys
f = open(sys.argv[1], 'r')
f2 = open(sys.argv[1]+"_modified", 'w')
for line in f:
    #print line
    alt1_base = ""
    alt1_count = 0
    alt2_base = ""
    alt2_count = 0
    ref1_base = ""
    ref1_count = 0
    ref2_base = ""
    ref2_count = 0
    dnm_base = ""
    dnm_count = 0
    fields = line.split('\t');

#    print fields[1],'\t',fields[6], '\t', fields[8]
    if ':' in fields[0]:
  
      #print "ff ",fields[0]
      s1_RDs = fields[6]
      s2_RDs = fields[8]
      all1_RDs = s1_RDs.split(' ',4)
      for base_RD in all1_RDs:
        #print "brd",base_RD
        RD = base_RD.split(':')
        #print RD
        #print base_count
        #print fields[1], RD[0]
        if (RD[0] == fields[1]):
            #print RD[0],":",RD[1]
            ref1_count = RD[1]
            ref1_base = RD[0]
        else:
            if(RD[1] > alt1_count):
                alt1_count = RD[1]
                alt1_base = RD[0]
        all2_RDs = s2_RDs.split(' ',4)
        #base_count = dict()
        for base_RD in all2_RDs:
          #print "brd",base_RD
          RD2 = base_RD.split(':')
          #print RD
          #base_count[RD[0]] = RD[1]
          #print base_count
          #print fields[1], RD2[0]
          
          if (RD2[0] == fields[1]):
            #print RD2[0],":",RD2[1]
            ref2_count = RD2[1]
            ref2_base = RD2[0]
          else:
            if(RD2[1] > alt2_count):
              alt2_count = RD2[1]
              alt2_base = RD2[0]
#      print ref1_base,"\t",ref1_count
#      print ref2_base,"\t",ref2_count
#      print alt1_base,"\t",alt1_count
#      print alt2_base,"\t",alt2_count
      if ref1_count == "0":
        dnm_base = alt1_base
        dnm_count = alt1_count
        line = line.rstrip('\n')
        line += "\t"+dnm_base+"\t"+str(dnm_count)+"\tNA\tNA"
      elif ref2_count == "0":
        dnm_base = alt2_base
        dnm_count = alt2_count
        line = line.rstrip('\n')
        line += "\tNA\tNA\t"+dnm_base+"\t"+str(dnm_count)
      elif alt1_count > alt2_count:
        dnm_base = alt1_base
        dnm_count = alt1_count
        line = line.rstrip('\n')
        line += "\t"+dnm_base+"\t"+str(dnm_count)+"\tNA\tNA"
      else:
        dnm_base = alt2_base
        dnm_count = alt2_count
        line = line.rstrip('\n')
        line += "\tNA\tNA\t"+dnm_base+"\t"+str(dnm_count)
      line+='\n'    
      #print line
      f2.write(line)
    else:
        line = line.rstrip('\n')
        s1, junk = fields[6].split('_', 1)
        s2, junk = fields[8].split('_', 1)
#        print s1,s2
        line+="\t"+s1+"_dnm_allele\t"+s1+"_dnm_allele_count\t"+s2+"_dnm_allele\t"+s2+"_dnm_allele_count"
        line+='\n'
        f2.write(line)
