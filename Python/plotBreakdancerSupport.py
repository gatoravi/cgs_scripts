#!/usr/bin/env python

import sys
import os
import pandas as pd
import matplotlib
matplotlib.use('Agg')

def usage():
  usage1 = """Usage
    1. First Argument is the bedtools pairtopair output of the merged svs.hq.merge.somatic.bedpe and the individual svs.hq.bedpe
  """
  print usage1

def create_sv_df(intersect_f, sv_type, sv_rd):
  fh1 = open(intersect_f, "r")
  for l in fh1:
    l = l.rstrip("\n")
    l_fields = l.split("\t")
    nfields = len(l_fields)
    sv_name = l_fields[6]
    sv_rd1 = l_fields[nfields - 1]
    sv_type1 = l_fields[nfields - 2]
    if sv_name in sv_type:
      sv_rd[sv_name] = sv_rd[sv_name] + int(sv_rd1)
    else:
      sv_rd[sv_name] = int(sv_rd1)
      sv_type[sv_name] = sv_type1
  
def summarize_sv(sv_type, sv_rd, summary_f):
  sfh = open(summary_f, "w")
  sfh.write("Name\tType\tReadDepth\n")
  for sv in sv_type:
    sfh.write(sv + "\t" + sv_type[sv] + "\t" + str(sv_rd[sv]) + "\n")
  sfh.close()

if __name__ == "__main__":
  intersect_f = sys.argv[1]
  sys.stderr.write("Reading from " + intersect_f + "\n")
  summary_f = os.path.splitext(intersect_f)[0] + "_summary.tsv"
  sys.stderr.write("Writing to " + summary_f + "\n")
  sv_type = {}
  sv_rd = {}
  create_sv_df(intersect_f, sv_type, sv_rd)
  summarize_sv(sv_type, sv_rd, summary_f)
