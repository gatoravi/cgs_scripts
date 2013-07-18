INPUT_BAM=$1
echo ${INPUT_BAM}
ref=/home/comp/exlab/aramu/files/20110915_CEUtrio/WEx/ref/hs37d5.fa


java -Xmx4g -jar ~/files/Src/Picard/picard-tools-1.84/CollectAlignmentSummaryMetrics.jar  I=${INPUT_BAM}  O=${INPUT_BAM}.alignmentSummary VALIDATION_STRINGENCY=LENIENT R=$ref