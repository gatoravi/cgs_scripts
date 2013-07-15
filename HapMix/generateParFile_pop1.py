#! /bin/python

#for c in range(1, 23):
for c in "X":
    f = open("chr" + str(c) + ".par", "w")
    f.write ("GENOTYPE:1"
              "\nOUTPUT_SITES:1"
              "\nSITE_POSITIONS: 1 1000000000"
              "\nTHETA:0.98"
              "\nLAMBDA:55.0"
              "\nRECOMBINATION_VALS:600 900"
              "\nMUTATION_VALS:0.2 0.2 0.01"
              "\nMISCOPYING_VALS:0.05 0.05"
              "\nREFPOP1GENOFILE:/home/comp/exlab/aramu/dat/HapMapPhasedGTs/CEU_geno_chr"+str(c)+".txt"
              "\nREFPOP2GENOFILE:/home/comp/exlab/aramu/dat/HapMapPhasedGTs/YRI_geno_chr"+str(c)+".txt"
              "\nREFPOP1SNPFILE:/home/comp/exlab/aramu/dat/HapMapMarkers/CEU_chr"+str(c)+".marker"
              "\nREFPOP2SNPFILE:/home/comp/exlab/aramu/dat/HapMapMarkers/YRI_chr"+str(c)+".marker"
              "\nADMIXSNPFILE:/home/comp/exlab/aramu/files/HapMix/AdmixPop/aml.chr"+str(c)+".snp"
              "\nADMIXGENOFILE:/home/comp/exlab/aramu/files/HapMix/AdmixPop/aml.chr"+str(c)+".eigenstratgeno"
              "\nADMIXINDFILE:/home/comp/exlab/aramu/files/HapMix/AdmixPop/aml.chr"+str(c)+".ind"
              "\nREF1LABEL:CEU"
              "\nREF2LABEL:YRI"
              "\nADMIXPOP:AML"
              "\nRATESFILE:/home/comp/exlab/aramu/dat/HapMapRates/CEU_chr"+str(c)+".rates"
              "\nCHR:"+str(c)+""
              "\nOUTDIR:./RUN_AML"
              "\nHAPMIX_MODE:LOCAL_ANC"
              "\nOUTPUT_DETAILS:ANC_INT_SAMPLE"
              "\nTHRESHOLD:0.0"
              "\nKEEPINTFILES:1\n")
    f.close()
