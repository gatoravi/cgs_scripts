#!/usr/bin/perl -w

my $usage="Usage: $0 [fastaFile]\n" . 
    "Converts fastaFile (with IUPAC ambiguity code) into PHASE format.\n".
    "The output contains only polymorphic sites (inluding gap polymorphisms)\n".
    "3-base and 4 base ambiguity codes are considered as missing character.\n".
    "This may have undesirable effect: a site with G G G H should be polymorphic,\n".
    "since H = A, C, or T.  But this site is considered as monomorphic in this program\n".
    "There is no way to specify an individual who is het for indel, this has to".
    "be added manually\n";

use Bio::AlignIO;

my %IUPAC = ('A'=>'A','C'=>'C','G'=>'G','T'=>'T','U'=>'T','-'=>'-','?'=>'?',
	          'M'=>'A C','R'=>'A G','W'=>'A T','S'=>'C G','Y'=>'C T','K'=>'G T',
	          'V'=>'A C G','H'=>'A C T','D'=>'A G T','B'=>'C G T',
	     'N'=>'A C G T');
my %toPhase = ('A'=>'A A','C'=>'C C','G'=>'G G','T'=>'T T','U'=>'T T','-'=>'- -',
	              '?'=>'? ?',
	       'M'=>'A C','R'=>'A G','W'=>'A T','S'=>'C G','Y'=>'C T','K'=>'G T');

use Getopt::Std;
getopts('h') || die "$usage\n";
die "$usage\n" if (defined($opt_h));

@ARGV = ('-') unless @ARGV;

if (@ARGV > 1) {
    die "ERROR: it can take only 1 input file\n$usage\n";
}

my $infile = shift @ARGV;

my $inAln = Bio::AlignIO->new(-file => "$infile", -format => 'fasta');

my $alnObj = $inAln -> next_aln;

unless ($alnObj->is_flush) {
    die "Alignment is not flush at the ends\n";
}

my @polyCat = CategorizeSites($alnObj);

# Find the polymorphic sites: this include site with
# monomorphic + some gap
my @polyIndex = ();  # 1-offset index
my @siteTypeString = ();
foreach my $index (0..$#polyCat) {
    if ($polyCat[$index] > 1) {
	push @polyIndex, $index+1;
	# S = biallelic, M = microsat
	my $thisType = ($polyCat[$index] == 2 || $polyCat[$index] == 5) ? "S" : "M";
	push @siteTypeString, $thisType;
    }
}

if (@polyIndex == 0) {
    warn "WARN: no polymorphic sites were found\n";
    exit;
}

print $alnObj->no_sequences, "\n", scalar(@polyIndex), "\n";
print join(" ", 'P', @polyIndex), "\n";
print join("", @siteTypeString), "\n";

## Now extract the poly sites, and print out in phase format
foreach my $seq ($alnObj->each_seq()) {
    my $name = $seq->display_id();
    print "$name\n";
    my $seqString = $seq->seq();
    my $outputString = "";
    foreach my $pindex (0..$#polyIndex) {
	my $base = substr $seqString, $polyIndex[$pindex] - 1 , 1;
	$base = uc $base;
	$base =~ s/U/T/;
	my $genotype = '? ?';
	if (defined($toPhase{$base})) {
	    $genotype = $toPhase{$base};
	} # 3 or 4-base ambiguity and non-IUPAC codes get converted to '? ?'

	if ($siteTypeString[$pindex] eq 'M') { # convert to microsat spec
	    $genotype =~ tr/ATGC-/12345/;
	    $genotype =~ s/\?/-1/g;
	}
	$outputString .= "$genotype ";
    }
    $outputString =~ s/\s+$//;
    print "$outputString\n";
} 

exit;

# Returns an array of integers, with each representing the
# type of polymorphism at the site (see PolymorphismType() below)
sub CategorizeSites  {
    my $alnObj = shift;

    my $alignedLen = $alnObj->length;
    my $numSamples = $alnObj->no_sequences;

    my @category = ();
    
    foreach my $index (1..$alignedLen) {
	my @charArr = GetBasesAtSite($alnObj, $index);
	my $type = PolymorphismType(@charArr);
	if ($type < 0 ) {
	        die "ERROR: Site $index contains non-IUPAC code:\n" . 
		    join(" ", @charArr);
	}
	push @category, $type;
    }
    return @category;
}

# Return a char array of bases at a particular site.
# 2nd arg $position is 1-offset index.  The 1st site is 1 not 0.
# when invalid position is specified, empty array is returned.
sub GetBasesAtSite {
    my ($alnObj, $position) = @_;
    my $numSamples = $alnObj->no_sequences;

    my @basesAtThisSite = ();
    
    if($alnObj->length < $position || $position < 1) {
	return @basesAtThisSite;
    }
    
    foreach my $seq ($alnObj->each_seq()) {
	push @basesAtThisSite, $seq->subseq($position,$position);
    }
    return @basesAtThisSite;
}


# Takes an array of bases, and categorize the 'polymorphism' in the array

# Returns:
#  0 : all gap (-)
#  1 : monomorphic (include all N or ?)
#  2 : di-allelic 
#  3 : tri-allelic
#  4 : quad-allelic
#  5 : monomorphic + gap (include cases: N N N N - N)
#  6 : di-allelic + gap
#  7 : tri-allelic + gap
#  8 : quad-allelic + gap
# <0 : non IUPAC code encountered
# WARN: For simplicity, 3 or 4 base ambiguity codes are considered as a
# missing char (? N V H D B), and they are ignored.
# This could cause problem.  For example, with (G, G, G, G, H, H), this site
# contains at least two types of bases (H=A|C|T).  However, this function
# consider this site to be monomorphic

sub PolymorphismType {
    my @bases = @_;

    # check gaps, and get rid of them
    my $withGap = 0;  # a flag to indicate existence of gap
    my @gaps = grep {/^-$/} @bases;
    if (@gaps > 0) {
	$withGap = 4; # raise the flag
	@bases = grep {! /^-$/} @bases; # get rid of gaps 
	return 0 if (@bases == 0);
    }
    
    @bases = map {uc $_} @bases; # convert to all upper case
    @bases = map {s/U/T/; $_} @bases; # U->T
    
    # convert 3 or 4 base ambiguity codes to N
    @bases = map {$_ =~ s/[VHDB\?]/N/; $_} @bases;
    
    # converting the 2 base-ambituity codes to single bases
    @bases = map {if(/^[MRWSYK]$/) {$IUPAC{$_}} else {$_} } @bases;
    @bases = split(/\s+/, join(" ", @bases));

    # Now @bases contain only A, T, G, C, N, so check this
    my $allIUPAC = 1;
    foreach my $bb (@bases) {
	if ($bb !~ /^[ATGCN]$/) {
    warn "WARNING: non-IUPAC code encountered: $bb\n";
    $allIUPAC = -1;
    last;
	}
    }
    
    my $type = NumBaseTypes(@bases);
    if ($type == 0) { # This means all 'N', return 1
	$type = 1;
    }

    # if there is at least one non-IUPAC code exist, negative
    # value get returned
    return ($type + $withGap) * $allIUPAC;
}

# Count how many different types of bases (A T G C) exist in an array.
# N, -, ? are ignored
# return value: 0 - 4
sub NumBaseTypes {
    my @bases = @_;
    my %cnt = ('A'=>0, 'T'=>0, 'G'=>0, 'C'=>0);
    foreach my $bb (@bases) {
	$cnt{uc($bb)} = 1;
    }
    return $cnt{'A'} + $cnt{'T'} + $cnt{'G'} + $cnt{'C'};
}
