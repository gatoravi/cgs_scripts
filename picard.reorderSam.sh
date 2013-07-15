
ref=~/files/20110915_CEUtrio/WEx/ref/hs37d5.fa
java -Xmx4g -jar  ~/files/Src/Picard/picard-tools-1.84/ReorderSam.jar I=$1 O=${1}.reordered REFERENCE=$ref