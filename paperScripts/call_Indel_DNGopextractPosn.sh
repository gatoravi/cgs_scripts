#Avinash Ramu, WUSTL
#Summary - As the name says, calls the other script

#! /usr/bin/bash

for c in {1..22}
do
    bash Indel_DNGopextractPosn.sh $1$c
done