#! /bin/bash

rm sizes

for c in {1..22}
do
ls -l *chr${c}.*bam | awk '{ printf($5"\t") }' >> sizes
echo -e "" >> sizes
done

c=X
ls -l *chr${c}.*bam | awk '{ printf($5"\t") }' >> sizes
echo -e "" >> sizes
