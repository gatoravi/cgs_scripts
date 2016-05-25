#! /usr/bin/env python

import sys
import csv

#Key is 5p:3p:type, value is list of samples
master_fusion_list = {}

def usage():
    print(sys.argv[0] + " HCC_integrate_master.csv SCLC_Master_Fusions_Integrate.tsv")

def read_fusions(fusion_files):
    for fusion_file in fusion_files:
        sys.stderr.write("Reading " + fusion_file)
        with open(fusion_file) as fusion_file_fh:
            for row in csv.DictReader(fusion_file_fh, delimiter = "\t"):
                fivep = row['5_Prime']
                threep = row['3_Prime']
                type1 = row['Type']
                sample = row['Sample']
                if (fivep < threep):
                    key = fivep + ":" + threep# + ":" + type1
                else:
                    key = threep + ":" + fivep# + ":" + type1
                if key not in master_fusion_list:
                    master_fusion_list[key] = set()
                master_fusion_list[key].add(sample)

def print_fusions():
    print("fusion\tsamples\tn_samples")
    for fusion in master_fusion_list:
        samples = master_fusion_list[fusion]
        print(fusion + "\t" + ",".join(samples) + "\t" + str(len(samples)))

def main():
    if len(sys.argv) < 3:
        return usage()
    read_fusions(sys.argv[1:])
    print_fusions()

if __name__ == "__main__":
    main()
