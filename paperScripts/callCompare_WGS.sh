trio=CEU
db_g_p=~/Dat/NGValdnData/CEU_validated_positive_germline_liftovered
db_s_p=~/Dat/NGValdnData/CEU_validated_positive_somatic_liftovered
db_n=~/Dat/NGValdnData/CEU_validated_negative_liftovered
scriptDir=~/Scripts/paperScripts

python $scriptDir/compare_calls.py $db_g_p $db_s_p $db_n $1
