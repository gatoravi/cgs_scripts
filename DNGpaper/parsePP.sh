#! /usr/bin/bash


awk '{ if ($3 > 0.001) print}' $1 > $1_p001
awk '{ if ($3 > 0.01) print}' $1 > $1_p01
awk '{ if ($3 > 0.1) print}' $1 > $1_p1
awk '{ if ($3 > 0.5) print}' $1 > $1_p5
awk '{ if ($3 == 1) print}' $1 > $1_1