#! /bin/bash
 
ip=$1
op=${1}.tdf,${1}.wig
genome=hg19

java -Xmx4g -jar  ~/files/Src/IGVTools/IGVTools-2.2.1/igvtools.jar count -w 10 $ip $op $genome