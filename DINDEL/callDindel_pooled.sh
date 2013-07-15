#! /bin/bash

ip1=$1
ip2=$2
ip3=$3
op=$4
#ref=$5

ref=~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa

echo $1 > BAM.list
echo $2 >> BAM.list
echo $3 >> BAM.list

#Get the candidate INDELs from the BAM

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis getCIGARindels --bamFile $ip1 --outputFile ${op}.1 --ref $ref

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis getCIGARindels --bamFile $ip2 --outputFile ${op}.2 --ref $ref

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis getCIGARindels --bamFile $ip3 --outputFile ${op}.3 --ref $ref

cat ${op}.1.variants.txt ${op}.2.variants.txt ${op}.3.variants.txt > ${op}.123.variants.txt 

python ~/files/Dindel/dindel-1.01-python/makeWindows.py --inputVarFile ${op}.123.variants.txt --windowFilePrefix $op.realign_windows --numWindowsPerFile 100000

echo "DINDELING"

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis indels --doPooled --bamFiles BAM.list --ref $ref --varFile $op.realign_windows.1.txt --libFile ${op}.1.libraries.txt --outputFile $op.123.dindel_stage2_output_windows.1

echo $op".123.dindel_stage2_output_windows.1.glf.txt" > ${op}.list

echo "Merging"

python  ~/files/Dindel/dindel-1.01-python/mergeOutputPooled.py --inputFiles ${op}.list --outputFile $op.VCF --ref $ref --numSamples 3 --numBamFiles 3

echo "Done Merge"
