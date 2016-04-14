#! /usr/bin/env bash

clinseq_model=$1
echo "Tumor microarray: "
genome model list id=$clinseq_model  \
    --show exome_model.tumor_model.genotype_microarray_model | tail -1
echo "Normal microarray: "
genome model list id=$clinseq_model  \
    --show exome_model.normal_model.genotype_microarray_model | tail -1
