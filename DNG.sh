#! /bin/bash
denovogear=~/files/DeNovoGear/code-releases/denovogear-0.5.2/denovogear-code/build/src/denovogear
bcf=${1}
ped=${2}
chr=${3}
pp_cutoff=0.001
	
$denovogear dnm auto --bcf $bcf --ped $ped --pp_cutoff ${pp_cutoff} > DNGop.${chr}.txt