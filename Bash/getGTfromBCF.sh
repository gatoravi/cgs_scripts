#Avinash Ramu, WUSTL
#Extract GTs of SNPs from BCF files

ipDir=~/files/20110915_CEUtrio/WGS/bcfFiles_orig
opDir=~/files/20110915_CEUtrio/WGS/GTs


for chr in {1..22}
do
    bcftools view -vg $ipDir/CEU_WGS_chr${chr}.bcf 2>>stderrorOP | awk '{if($1!~/#/ && !/INDEL/){ print $1"\t"$2"\t"$4"\t"$5"\t"$10"\t"$11"\t"$12}}' |awk '{split($5, f1, ":"); split($6, f2, ":"); split($7, f3, ":"); print $1"\t"$2"\t"$3"\t"$4"\t"f1[1]"\t"f2[1]"\t"f3[1];}' > $opDir/CEU_WGS_chr${chr}_GT
done


chr=X
bcftools view -vg $ipDir/CEU_WGS_chr${chr}.bcf 2>>stderrorOP | awk '{if($1!~/#/ && !/INDEL/){ print $1"\t"$2"\t"$4"\t"$5"\t"$10"\t"$11"\t"$12}}' |awk '{split($5, f1, ":"); split($6, f2, ":"); split($7, f3, ":"); print $1"\t"$2"\t"$3"\t"$4"\t"f1[1]"\t"f2[1]"\t"f3[1];}' > $opDir/CEU_WGS_chr${chr}_GT