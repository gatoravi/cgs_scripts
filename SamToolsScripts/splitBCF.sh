#! /usr/bin/bash


for chr in {1..22}
do
    echo "splitting chr"$chr
    bcftools view -b $1 $chr > $1.$chr.bcf
    bcftools index $1.$chr.bcf
done

chr=X
echo "splitting chr"$chr
bcftools view -b $1 $chr > $1.$chr.bcf
bcftools index $1.$chr.bcf
