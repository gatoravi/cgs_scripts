trio=CEU
db_g_p=~/Dat/NGValdnData/WEx_WithCov/WEx.ger.RD10
db_s_p=~/Dat/NGValdnData/WEx_WithCov/WEx.som.RD10
db_n=~/Dat/NGValdnData/WEx_WithCov/WEx.fp.RD10
scriptDir=~/Scripts/paperScripts

python $scriptDir/compare_calls.py $db_g_p $db_s_p $db_n $1
