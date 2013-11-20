import sys

f = sys.argv[1]
fo = open(f)
for l in fo:
    l = l.rstrip()
#    chrpo, child, mom, dad, junk = l.split("\t", 4)
    chrpo, child, mom, dad = l.split()
    child_GT = []
    mom_GT = []
    dad_GT = []
    child_GT = child.split("/")
    mom_GT = mom.split("/")
    dad_GT = dad.split("/")
    p11 = 0
    p12 = 0
    p21 = 0
    p22 = 0
    d_flag = 0
    n_flag = 1
    #print chrpo, dad_GT, dad_GT[0], dad_GT[1]
    if child_GT[0] == mom_GT[0] or child_GT[0] ==  mom_GT[1]:
        p11+=1
    if child_GT[0] == dad_GT[0] or child_GT[0] ==  dad_GT[1]:
        p21+=1
    if not p11 and not p21:
        n_flag = 0
        d_flag = 1
    if(child_GT[1] == mom_GT[0] or child_GT[1] ==  mom_GT[1]):
        p12+=1
    if(child_GT[1] == dad_GT[0] or child_GT[1] ==  dad_GT[1]):
        p22+=1
    if(not p12 and not p22):
        n_flag = 0
        d_flag = 1
    if(child_GT[0] == child_GT[1]):
        if((not p11 and not p12) or (not p21 and not p22)): # hom allele not in any one of the parents.
            n_flag = 0 
            d_flag = 1
    print l, d_flag
