# Avinash Ramu, WUSTL
# Extract sites of interest from BCF file using bcftools
# ARG1 is the file containing the list of files in the format "chr:pos1-pos1"

#! /bin/perl

open FILE, "<".$ARGV[0];
$bcf_f_pre = "~/files/20110915_CEUtrio/WGS/bcfFiles_orig/CEU_WGS_chr";

while (<FILE>) {
    chomp;
    $site = $_;
    @fields = split(":", $site);
#    print $fields[0]."\t".$fields[1];
    $bcf_f = $bcf_f_pre.$fields[0].".bcf"; # attach the name of the chromosome to the filename
#    print $bcf_f."\n";
    $command = "bcftools view $bcf_f $site | grep INDEL >> INDELvalidationsites_bcfOP";
    print $command."\n";
#    $c1 = "bcftools";
    `$command`;
}
