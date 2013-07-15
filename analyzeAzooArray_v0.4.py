#Avinash Ramu, WUSTL
#Synopsis - Build table of Case/Control minor allele ratio
#            vs minor allele frequency
#Argument - ARG1 - Eigenstrat geno file, contains GT calls.
#           ARG2 - '.snp' file, contains SNP ID and posns.            
#           ARG3 - '.ind' file, contains list of samples.
#                   all the cases are listed before the controls.           
#Note - In the Eigenstrat geno file, 0/1/2 stands for the number of alt alleles, i.e RR/RA/AA

#! /bin/python
import sys
import numpy as np
DEBUG = 0
#for a in np.arange(0, 0.31, 0.01):
    #print a
#exit(1)

def usage():
    print "Usage"
    print "\tARG1 - Eigenstrat geno file, contains GT calls."                         
    print "\tARG2 - '.snp' file, contains SNP ID and posns."                          
    print "\tARG3 - '.ind' file, contains list of samples." 
    print "\tARG4 - file with rs\tMAF"

class SNP:
    def __init__ (self, rsid, total_ref_freq, total_alt_freq, case_ref_freq, case_alt_freq, 
                 control_ref_freq, control_alt_freq):
        self.rsid = rsid
        self.total_ref_freq = total_ref_freq
        self.total_alt_freq = total_alt_freq
        self.case_ref_freq  = case_ref_freq # avg fraction of cases ref allele is present [0 - 1]
        self.case_alt_freq  = case_alt_freq # avg fraction of cases alt allele is present [0 - 1]
        self.control_ref_freq = control_ref_freq # avg fraction of controls ref allele is present [0 - 1] 
        self.control_alt_freq = control_alt_freq # avg fraction of controls alt allele is present [0 - 1]
       
#check arguments
argc = len(sys.argv) - 1
if(argc != 4):
    print usage()
    exit(1)

#parse arguments
genoFile = sys.argv[1]
snpFile  = sys.argv[2]
indFile  = sys.argv[3]
opFile   = "amlcc_snpBurdenTable"
ind      = {} #Hash with all ind info
snpIDs   = []

snp_MAF = {}
f4 = open(sys.argv[4], "r")
for l in f4:
    fields = l.split()
    snp = fields[0]
    MAF = float(fields[1])
    #print "snp is ", snp
    #print "MAF is ", MAF
    snp_MAF[snp] = MAF
print "The number of SNPs with MAF is ", len(snp_MAF)


if DEBUG:
    for ind in EURanc:
        print ind, EURanc[ind]

# find no of cases, controls from ind file
caseCount = 0
caseDroppedCount = 0
controlCount = 0
indno = 1
ind_fh = open(indFile, 'r')
for line in ind_fh:
    #print line
    ind[indno] = {}
    line = line.rstrip('\n')
    fields = line.split()
    indID = fields[0]
    sex = fields[1] 
    caseStatus = fields[2]
    #print caseStatus
    ind[indno]["indID"] = indID
    ind[indno]["sex"] = sex
    ind[indno]["caseStatus"] = caseStatus
    if (caseStatus == "Case"):
        caseCount += 1
    elif (caseStatus == "Control"):
        controlCount += 1
    elif (caseStatus == "Case_Dropped"):
        caseDroppedCount += 1
    indno += 1
print "The number of retained cases is " + str(caseCount)
print "The number of dropped cases is " + str(caseDroppedCount)
print "The number of Controls is " + str(controlCount)
ind_fh.close()

# get SNPs and SNP IDs from .snp file
snpCount = 0
snp_fh = open(snpFile, 'r')
for line in snp_fh:    
    line = line.rstrip("\n")
    snpID = line
#    print snpID
    snpIDs.append(snpID)
    snpCount += 1
print "\nThe number of SNPs with GT calls is " + str(snpCount)

# get the case and control freq of alt allele from each snp in genotype file
S = []
snp_i = 0
geno_fh = open(genoFile, 'r')
for line in geno_fh:
    line = line.rstrip('\n')
    total_ref_freq = 0 # freq of ref allele in cases and controls
    total_alt_freq = 0 # freq of alt allele in cases and controls
    case_ref_freq = 0 # freq of ref allele in cases
    case_alt_freq = 0 # freq of alt allele in cases
    control_ref_freq = 0 # freq of ref allele in controls
    control_alt_freq = 0 # freq of alt allele in controls
    indno = 1
    for c in line:  
        c = int(c)
        if(c == 9):
            c = 1
        #print c, (c+1)/2, (3-c)/2
        #alt_freq = (c + 1)/2 
        #alt_freq = int(c)
        #ref_freq = 2 - alt_freq
        alt_freq = int((c + 1)/2) 
        ref_freq = int((3 - c)/2)     
        if(alt_freq != 0 and alt_freq != 1):
            print "alt_freq fail", alt_freq   
        indID_current = ind[indno]["indID"]
        if (ind[indno]["caseStatus"] == "Case"): 
            total_alt_freq += alt_freq  
            total_ref_freq += ref_freq
            case_alt_freq += float(alt_freq)
            case_ref_freq += ref_freq
        elif (ind[indno]["caseStatus"] == "Control"):
            total_alt_freq += alt_freq  
            total_ref_freq += ref_freq
            control_alt_freq += float(alt_freq) 
            control_ref_freq += ref_freq
        #print total_alt_freq, alt_freq
        indno += 1
    if snpIDs[snp_i] in snp_MAF.keys():
        S.append(SNP(snpIDs[snp_i], total_ref_freq, total_alt_freq, case_ref_freq, case_alt_freq, control_ref_freq, control_alt_freq))
        #print snpIDs[snp_i], "in MAF"
    snp_i += 1

# sort the SNPs based on total frequency
S.sort(key=lambda x: x.total_alt_freq) # sort the SNP calls based on total freq
print "The number of SNPs in S is ", len(S), snp_i

#write to file for reference
fs = open("snpStatistics", "w")
fs.write("rsid\ttotal_ref\ttotal_alt\tcase_ref\tcase_alt\tcontrol_ref\tcontrol_alt\n")
for s in S:
    l  = s.rsid + "\t" + str(s.total_ref_freq) + "\t" 
    l += str(s.total_alt_freq) + "\t" +str(s.case_ref_freq) 
    l += "\t" + str(s.case_alt_freq) + "\t" + str(s.control_ref_freq) 
    l +=  "\t" + str(s.control_alt_freq) + "\n"
    fs.write(l)
fs.close()

print "Done writing SNP statistics"

# calculate the number of SNPs for each rank
cutoff = int(0.3 * (caseCount + controlCount)) #only look at SNPs in atleast 30 pc of population
SNPburden = {}
index = 0
for altFreqCutoff in np.linspace(0, 0.3, 31):
    print "cutoff is ", str(altFreqCutoff)
    print "\n"
    SNPburden[altFreqCutoff] = {}
    SNPburden[altFreqCutoff]["case"] = 0
    SNPburden[altFreqCutoff]["control"] = 0
    for s in S:        
        if(snp_MAF[s.rsid] <= altFreqCutoff):
            #print s.rsid, str(altFreqCutoff), "satisfies cutoff"
            SNPburden[altFreqCutoff]["case"] += s.case_alt_freq
            SNPburden[altFreqCutoff]["control"] += s.control_alt_freq

# write the burden to a file
print "opFile is ", opFile
fout = open(opFile, "w")
fout.write("Frequency\tCase_SNPs\tControl_SNPs\tCase_SNPs_perCase\tControl_SNPs_perControl\tcaseSNPs_perSample/controlSNPs_perSample\n")
#for altFreqCutoff in SNPburden:
for altFreqCutoff in np.linspace(0, 0.3, 31):
    caseSNPs_perSample = float(SNPburden[altFreqCutoff]["case"]) / float(caseCount) #normalize by number of cases
    controlSNPs_perSample = float(SNPburden[altFreqCutoff]["control"]) / float(controlCount) #normalize by number of controls
    
    fout.write(str(altFreqCutoff) + "\t" + str(SNPburden[altFreqCutoff]["case"]) + 
                "\t" + str(SNPburden[altFreqCutoff]["control"]) + "\t" + str(caseSNPs_perSample) + "\t" + 
                str(controlSNPs_perSample) + "\t" + str(caseSNPs_perSample/controlSNPs_perSample)+ "\n")
fout.close()

#Debug SNP MAF's
fout_scheck = open("SNP_MAF_check", "w")
fout_scheck.write("rsid" + "\t" + "population freq" + "\t" +  "1kg freq")
for s in S:
    fout_scheck.write(s.rsid + "\t" + str(s.total_alt_freq) + "\t" + str(snp_MAF[s.rsid]) + "\n")
fout_scheck.close()
