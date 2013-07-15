#Avinash Ramu, WUSTL
#Summary:Pull out the genotypes from a VCF file, this is normally encoded as 0|0 0|1 or 1|1, 0 refers to the Reference allele and 1 refers to the alternate allele. 
#ARGUMENTS: pipe `bcftools view -vg` output
#Output: chr pos gt1 gt2 gt3

#! /usr/bin/perl

#open fin,$ARGV[0] or die"unable to open file"; 

while(<STDIN>) {

    print;
    @fields = split(/\t/);
    
    @subfields1 = split(/:/,$fields[4] );
    if($subfields1[0] eq "0|0") {
	$gt1 = $fields[2].$fields[2];
    }
    elsif($subfields1[0] eq "1|1") {
	$gt1 = $fields[3].$fields[3];
    }
    elsif($subfields1[0] eq "0|1" || $subfields1[0] eq "1|0" 
	  || $subfields1[0] eq "0/1" || $subfields1[0] eq "1/0"  ) {
	$gt1 = $fields[2].$fields[3];
    }

    @subfields2 = split(/:/,$fields[5] );
    if($subfields2[0] eq "0|0") {
	$gt2 = $fields[2].$fields[2];
    }
    elsif($subfields2[0] eq  "1|1") {
	$gt2 = $fields[3].$fields[3];
    }
    elsif($subfields2[0] eq "0|1" || $subfields2[0] eq "1|0" 
	  || $subfields2[0] eq "0/1" || $subfields2[0] eq "1/0"  ) {
	$gt2 = $fields[2].$fields[3];
    }

    @subfields3 = split(/:/,$fields[6] );
    if($subfields3[0] eq "0|0") {
	$gt3 = $fields[2].$fields[2];
    }
    elsif($subfields3[0] eq "1|1") {
	$gt3 = $fields[3].$fields[3];
    }
    elsif($subfields3[0] eq "0|1" || $subfields3[0] eq "1|0" 
	  || $subfields3[0] eq "0/1" || $subfields3[0] eq "1/0"  ) {
	$gt3 = $fields[2].$fields[3];
    }	

    print $fields[0]."\t".$fields[1]."\t".$gt1."\t".$gt2."\t".$gt3."\n";
}

    
