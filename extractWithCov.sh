#! /bin/bash

awk -F "\t" ' {if ($1 ~ /:/ && $4 >= 10 && $6 >= 10 && $8 >= 10)print $1}' $1 | awk -F ":" '{ print $1"\t"$2}'> $1_withCov

awk -F "\t" ' {if (($1 ~ /:/) && ($4 < 10 || $6 < 10 || $8 < 10)) print}' $1 > $1_withoutCov