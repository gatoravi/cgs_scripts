#! /usr/bin/env python

import sys
import csv

#Key is 5p:3p:type, value is count of samples
master_fusion_list = {}

def usage():
    print(sys.argv[0] + " master_fusions.csv summary.csv")

def read_master_fusions(master_fusion_file):
    with open(master_fusion_file) as master_fusion_file_fh:
            for row in csv.DictReader(master_fusion_file_fh, delimiter = "\t"):
                fusion = row['fusion']
                n_samples = row['n_samples']
                master_fusion_list[fusion] = n_samples

def check_for_presence(new_calls):
    with open(new_calls) as new_calls_fh:
            for row in csv.DictReader(new_calls_fh, delimiter = "\t"):
                fivep = row['5_Prime']
                threep = row['3_Prime']
                type1 = row['Type']
                if (fivep < threep):
                    key = fivep + ":" + threep#+ ":" + type1
                else:
                    key = threep + ":" + fivep# + ":" + type1
                if key in master_fusion_list:
                    print(key + "\t" + str(master_fusion_list[key]))
                else:
                    print(key + "\t0")

def main():
    if len(sys.argv) < 3:
        return usage()
    read_master_fusions(sys.argv[1])
    check_for_presence(sys.argv[2])

if __name__ == "__main__":
    main()
