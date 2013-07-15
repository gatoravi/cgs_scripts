#! /bin/bash

chr=X
bcf=~/Dat/1000genomes/Trio_PCRFree/BCF/CEU.${chr}.bcf
ped=~/Dat/1000genomes/Trio_PCRFree/PED/CEU.ped

bash ~/Scripts/DNG.sh $bcf $ped $chr