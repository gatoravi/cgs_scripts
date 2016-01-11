INPUT_BAM=$1
echo ${INPUT_BAM}

java -Xmx4g -jar ~/files/Src/Picard/picard-tools-1.84/MarkDuplicates.jar I=${INPUT_BAM} M=${INPUT_BAM}.markDuplicate.metrics.txt O=${INPUT_BAM}.duplicatesMarked.bam VALIDATION_STRINGENCY=LENIENT