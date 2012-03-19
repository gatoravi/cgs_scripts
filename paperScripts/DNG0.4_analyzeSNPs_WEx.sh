#Avinash Ramu, WUSTL
#Summary - Pull out required columns from DNG o/p and compare with validated positions to get summary of intersectin calls !! :)
#ARG1 - directory where the DNG calls for each chromosome has been generated

#! /bin/bash

dng=dng0.4 # DNG version used
#dng=dng0.3 # DNG version used
#trio=${trio} # the trio being analyzed
trio=CEU

db_g_p=/home/comp/exlab/aramu/files/db/${trio}_validated_positive_germline_liftovered_exome # germline validated positive calls
db_s_p=/home/comp/exlab/aramu/files/db/${trio}_validated_positive_somatic_liftovered_exome # somatic validated positivecalls
db_n=/home/comp/exlab/aramu/files/db/${trio}_validated_negative_liftovered_exome # somatic validated negative calls
WG_DNGop=${dng}op_WG_${trio}_chr*
WEx_DNGop=${dng}_CEU_WEx_decoy.bcf.chr*
DNGop=$WEx_DNGop #choose either WGS or WEx op format
#DNGop=$WG_DNGop
scriptDir=~/scripts/paperScripts #directory where the python script is stored

cd $1
mkdir chrOP
mv $DNGop chrOP/
cat chrOP/$DNGop > ${dng}op_${trio}_WG
mkdir SNPanalysis
mv $DNGop SNPanalysis
awk '/DENOVO-SNP/ {print $6"\t"$8"\t"$26}' ${dng}op_${trio}_WG > ./SNPanalysis/${dng}op_${trio}_WG_f

#python ~/scripts/paperPipelines/compareCalls_positive_hash.py ${db_g_p} ./SNPanalysis/${dng}op_${trio}_WG_f germline > ${1}germlineCalls_results_positive 
#python ~/scripts/paperPipelines/compareCalls_positive_hash.py ${db_s_p} ./SNPanalysis/${dng}op_${trio}_WG_f somatic > ${1}somaticCalls_results_positive 
#python ~/scripts/paperPipelines/compareCalls_negative_hash.py ${db_n} ./SNPanalysis/${dng}op_${trio}_WG_f falsepos > ${1}Calls_results_negative 

python $scriptDir/compare_calls.py $db_g_p $db_s_p ${db_n} ./SNPanalysis/${dng}op_${trio}_WG_f falsepos > ${1}Calls_results

cp ${1}*Calls_results* ..
mv *validated* SNPanalysis/