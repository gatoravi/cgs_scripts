#! /usr/bin/bash

db=WEx
#db=WG
script_dir=/home/comp/exlab/aramu/scripts/paperScripts
dng=dng0.4
for prior in 1e-4 1e-5 1e-6 1e-7 1e-8 1e-9 1e-10 1e-11 1e-12
do
     echo $prior
     bash $script_dir/DNG0.4_analyzeSNPs_$db.sh $prior
done
mkdir ${dng}ResultsSummary
mv *results* ${dng}ResultsSummary