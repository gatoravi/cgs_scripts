#! /usr/bin/perl
use strict;
use warnings;

my $f1 = $ARGV[0];
my $f2 = $ARGV[1];
my $f1_o = $f1 . ".intersected";
my $f2_o = $f2 . ".intersected";

open(my $f1_fh, "<". $f1);
open(my $f1_ofh, ">". $f1_o);
open(my $f2_fh, "<". $f2);
open(my $f2_ofh, ">". $f2_o);

my %f1;
my %chr_pos1;

while(<$f1_fh>) {
  my $line = $_;
  my @fields = split("\t", $line);
  my $key = $fields[0] . ":" . $fields[1];
  $chr_pos1{$key} = 1;
  $f1{$key} = $line;
}

while(<$f2_fh>) {
  my $line = $_;
  my @fields = split("\t", $line);
  my $key = $fields[0] . ":" . $fields[1];
  if($chr_pos1{$key}) {
    print $f2_ofh $line;
    print $f1_ofh $f1{$key};
  }
}
