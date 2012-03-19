#Author- Avinash Ramu, WUSTL
#Convert coordinates from hg18 to hg19


#! /usr/bin/bash

~/bin/liftOver $1 ~/bin/hg18ToHg19.over.chain $1_liftovered $1_unmapped