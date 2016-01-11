trio=CEU
db_g_p=~/Dat/NGValdnData/INDEL_validation_sites.true_positives.txt
db_s_p=~/Dat/NGValdnData/INDEL_validation_sites.true_positives.txt
db_n=~/Dat/NGValdnData/INDEL_validation_sites.true_positives.txt
scriptDir=~/Scripts/paperScripts

python $scriptDir/compare_calls.py $db_g_p $db_s_p $db_n $1
