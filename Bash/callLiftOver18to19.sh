#Author- Avinash Ramu, WUSTL
#Convert coordinates from hg18 to hg19
#Arguments - Coordinates in a BED file
#chromosome must have the prefix chr

#! /usr/bin/bash

~/bin/liftOver $1 ~/bin/hg18ToHg19.over.chain $1_liftovered $1_unmapped