#Avinash Ramu, WUSTL
#Summary - As the name says, calls the other script

#! /usr/bin/bash

for c in {1..22}
do
    cat $1${c}_posns >> $1_WG
done