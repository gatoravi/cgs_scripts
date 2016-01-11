#! /bin/bash

#bam1=$1
pos=$1
op=$2

awk '{ print $1":"$2"-"$2 }' $pos | xargs -i echo -e "samtools mpileup -f ~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa ~/files/20110915_CEUtrio/WGS/BAMFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12878.clean.dedup.recal.bam -r {}  2>/dev/null | java -Xmx4g -jar ~/bin/VarScan.v2.2.11.jar readcounts  2>${op}_78" | bash

awk '{ print $1":"$2"-"$2 }' $pos | xargs -i echo -e "samtools mpileup -f ~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa ~/files/20110915_CEUtrio/WGS/BAMFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12891.clean.dedup.recal.bam -r {}  2>/dev/null | java -Xmx4g -jar ~/bin/VarScan.v2.2.11.jar readcounts  2>${op}_91" | bash

awk '{ print $1":"$2"-"$2 }' $pos | xargs -i echo -e "samtools mpileup -f ~/files/20110915_CEUtrio/WGS/ref/hs37d5.fa ~/files/20110915_CEUtrio/WGS/BAMFiles/CEUTrio.HiSeq.WGS.b37_decoy.NA12892.clean.dedup.recal.bam -r {}  2>/dev/null | java -Xmx4g -jar ~/bin/VarScan.v2.2.11.jar readcounts  2>${op}_92" | bash
