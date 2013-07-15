#! /bin/bash

java -Xmx10g -jar ~/bin/FixMateInformation.jar  INPUT=$1 OUTPUT=$2 SORT_ORDER=coordinate VALIDATION_STRINGENCY=SILENT TMP_DIR=Tmp