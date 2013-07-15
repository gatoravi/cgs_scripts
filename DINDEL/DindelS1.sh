# ARG1, ARG2 and ARG3 are the 

#! /bin/bash

ip1=$1
ip2=$2
ip3=$3
op=CEU_WG

ref=~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa

echo $ip1 > BAM.list
echo $ip2 >> BAM.list
echo $ip3 >> BAM.list

#Get the candidate INDELs from the BAM

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis getCIGARindels --bamFile $ip1 --outputFile ${op}.1 --ref $ref

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis getCIGARindels --bamFile $ip2 --outputFile ${op}.2 --ref $ref

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis getCIGARindels --bamFile $ip3 --outputFile ${op}.3 --ref $ref

cat ${op}.1.variants.txt ${op}.2.variants.txt ${op}.3.variants.txt > ${op}.123.variants.txt 

python ~/files/Dindel/dindel-1.01-python/makeWindows.py --inputVarFile ${op}.123.variants.txt --windowFilePrefix $op.realign_windows