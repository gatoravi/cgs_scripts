trio=CEU
db_g_p=~/Dat/NGValdnData/coding.germline.validated.liftovered
db_s_p=~/Dat/NGValdnData/coding.somatic.validated.liftovered
db_n=~/Dat/NGValdnData/coding.fp.validated.liftovered
scriptDir=~/Scripts/paperScripts

python $scriptDir/compare_calls.py $db_g_p $db_s_p $db_n $1
