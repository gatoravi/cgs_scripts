awk '{ gsub(23, "X", $1); print "chr"$1"\t"$2"\t"$2+1 }' $1 > ${1}.pos
bash ~/Scripts/callLiftOver18to19.sh ${1}.pos