#! /bin/bash

ip=$1
ref=$2
op=$3
chart=${3}.pdf
summary=${3}.summary

java -Xmx4g -jar ~/bin/CollectGcBiasMetrics.jar R=$ref I=$ip O=$op CHART=$chart S=$summary VALIDATION_STRINGENCY=SILENT ASSUME_SORTED=true