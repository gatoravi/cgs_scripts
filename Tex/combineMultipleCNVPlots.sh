#! /bin/bash
#This script puts the CNV results from microarray, wgs and exome and the Chris Miller style CNV plot for all three platforms into one.
#BRC18 does not have microarray cnvs.
#BRC38 has microarray missing data.
#
#for sample in AML103  AML109   AML31   BRC36   BRC38   GIA1   HG2   HG3   HG4   HGG1   LGG1  LUC21   PNC2_1   PNC2_2   PNC4   PNC5   PNC6
rm -f *CNVpanels.pdf
for sample in AML103  AML109 AML31 BRC36  GIA1   HG2   HG3   HG4  HGG1   LGG1   LUC21  PNC2_1  PNC2_2   PNC4   PNC5   PNC6
do
pdflatex "\def\sample{$sample} \def\maf{${sample}.microarrays.cnvs.jpg} \def\wgsf{${sample}.wgs.cnvs.jpg} \def\exomef{${sample}.exome.cnvs.pdf}   \def\combinedf{${sample}.combinedCNV.pdf} \def\ma{{${sample}.microarrays.cnvs}.jpg} \def\wgs{{${sample}.wgs.cnvs}.jpg} \def\exome{{${sample}.exome.cnvs}.pdf}   \def\combined{{${sample}.combinedCNV}.pdf} \input{/gscuser/aramu/src/Scripts/Tex/combineMultipleCNVPlots.tex}"
mv combineMultipleCNVPlots.pdf ${sample}.CNVpanels.pdf
done
mv all.CNVpanels.pdf all.CNVpanels.pdf.bk
pdftk *CNVpanels.pdf cat output all.CNVpanels.pdf
pdfcrop all.CNVpanels.pdf
cp all.CNVpanels-crop.pdf ~
