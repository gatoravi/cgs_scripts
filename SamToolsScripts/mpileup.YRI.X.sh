#! /bin/bash

ref=~/files/20110915_CEUtrio/WEx/ref/hs37d5.fa
b1=$2
b2=$3
b3=$4
chr=X

samtools mpileup -gDf $ref $b1 $b2 $b3 -r $chr > YRI.$chr.bcf