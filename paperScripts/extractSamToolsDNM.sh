#! /bin/bash

file_pre=SamTools17op_WG_CEU_chr

for c in {1..22}
do
    echo "chr $c"
    #awk '{ if($8~/CLR/ print}' $file_pre$c > ${file_pre}${c}_parsed
    awk -F "\t" '{if ($8 !~ /INDEL/) {split($8,a, ";"); print $1"\t"$2"\t"a[4]}}' ${file_pre}${c}_parsed > ${file_pre}${c}_parsed_pos
done

c=X
echo "chr $c"
#awk '{ if($8~/CLR/) print}' $file_pre$c > ${file_pre}${c}_parsed
awk -F "\t" -F";" '{print $1"\t"$2"\t"$11}' ${file_pre}${c}_parsed > ${file_pre}${c}_parsed_pos

