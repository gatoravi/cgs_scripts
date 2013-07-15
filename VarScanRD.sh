#! /bin/bash

bam=$1 
pos_f=$2  #chr pos
op=$3


# awk '{ print $1":"$2"-"$2 }' $pos_f | xargs -i echo -e "samtools mpileup -f ~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa $bam -r {}  2>/dev/null | java -Xmx4g -jar ~/bin/VarScan.v2.2.11.jar readcounts"  | bash > $op


awk '{ print $1":"$2"-"$2 }' $pos_f | xargs -i echo -e "samtools mpileup -f ~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa $bam -r {}  2>/dev/null"  | bash > $op

