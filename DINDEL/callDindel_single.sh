#! /bin/bash

ip=$1
op=$2
#ref=$3

ref=~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa

#Get the candidate INDELs from the BAM

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis getCIGARindels --bamFile $ip --outputFile $op --ref $ref

python ~/files/Dindel/dindel-1.01-python/makeWindows.py --inputVarFile $op.variants.txt --windowFilePrefix $op.realign_windows --numWindowsPerFile 100000

~/files/Dindel/binaries/dindel-1.01-linux-64bit --analysis indels --doDiploid --bamFile $ip --ref $ref --varFile $op.realign_windows.1.txt --libFile $op.libraries.txt --outputFile $op.dindel_stage2_output_windows.1

echo $op".dindel_stage2_output_windows.1.glf.txt" > ${op}.list
python  ~/files/Dindel/dindel-1.01-python/mergeOutputDiploid.py --inputFiles ${op}.list --outputFile $op.VCF --ref $ref

