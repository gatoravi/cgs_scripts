#! /bin/bash

ip=$1
op=$2
so=coordinate #Sort order of output file Required. Possible values: {unsorted, queryname, coordinate} 


java -Xmx4g -jar ~/bin/SortSam.jar INPUT=$ip OUTPUT=$op SORT_ORDER=$so VALIDATION_STRINGENCY=SILENT