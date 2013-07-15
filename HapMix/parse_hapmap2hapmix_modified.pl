#!/usr/bin/perl

#MEANT TO BE RUN FROM ../phase3
#THIS WILL BECOME SOME HORRIBLE SCRIPT .. Eh, Yes it will, but don't worry I'll try to fix it. 

# Updated 4/18 by Avinash

use warnings;

$PRINTMARKERFILE = 1;
@pop=("CEU");

#Directories used

$ratesDir = "/home/comp/exlab/aramu/dat/HapMapRates";
$markerDir = "/home/comp/exlab/aramu/dat/HapMapMarkers";
$markerDir2 = ".";
$ratesDir2 = ".";

$phasedDir = "/home/comp/exlab/aramu/dat/hapmap.ncbi.nlm.nih.gov/downloads/phasing/2009-02_phaseIII/HapMap3_r2";
$phasedGTsDir = ".";

for ($k=0; $k<=$#pop; $k++) { #LOOP OVER POPS
    #OPEN MARKER FILE IF APPROPRIATE, ALL HAPMAP P3 POPS TYPED WITH SAME MARKERS
    for ($j=5; $j<=5; $j++){ #LOOP OVER CHROMS   
        if ($k==0 && $PRINTMARKERFILE == 1) {
             $ratefile = $ratesDir."/genetic_map_chr$j\_b36.txt";
             $snpfile = $markerDir."/$pop[$k]_chr$j.sites";

             print "\nReading rates file\n";

             %rates=read_rates($ratefile); #only need recomb rates for marker file

	     print "\nReading markers file\n";
             %gtmap=read_markers($snpfile);


             open(MARK,">".$markerDir2."/chr$j.marker") or die "\ncan't open marker file\n";
             open(ORATES,">".$ratesDir2."/chr$j.rates") or die "\ncan't open output ratefile\n";
            
             @pos  = sort {$a <=> $b} keys %rates; #list of all pos in rate table
             $nrates=$#pos+1;
	    
             print ORATES ":sites:$nrates\n";

             for ($i=0;$i<=$#pos;$i++){
                print ORATES "$pos[$i] ";
             }
             print ORATES "\n";  
             for ($i=0;$i<=$#pos;$i++){
                print ORATES "$rates{$pos[$i]} ";
             }
             print ORATES "\n";  
             close(ORATES);
             %gtmap=fix_rates(\%gtmap,\%rates);
        }
        # OPEN TMP GENOTYPE FILE       
        open(GT_TMP,">".$phasedGTsDir."/$pop[$k]\_geno_chr$j.txt"); 
       
        #Open HAPMAP marker file. THIS IS A FILE THAT I CREATE BY SPLITTING OUT THE FIRST 5 COLUMNS OF THE HAPMAP _GENOTYPE_ FILES AND CONTAINS RSID CHR PHYSPOS ALT AND REF ALLELES. WE NEED THIS TO RECODE THE PHASED HAPS INTO EIGENSTRAT 0 or 1 FORMAT

        $filename = $markerDir."/$pop[$k]_chr$j.sites";
        $ratefile = $ratesDir."/genetic_map_chr$j\_b36.txt";
      	%gtmap=read_markers($filename);
        if ( 0 == 0 ){
	    $pop1 = lc($pop[$k]);
            $file = $phasedDir."/$pop[$k]/TRIOS/hapmap3_r2_b36_fwd.consensus.qc.poly.chr$j\_".$pop1.".phased";
            open(IN, "<$file") or die "can't find file $file\n";
            chomp($line=<IN>);
            @header=split(' ',$line); 
            #NO HEADER INFO REQUIRED FOR REFERENCE FILES, NO IND FILE EITHER
      
            while(<IN>){
              chomp($line=$_);
              @data=split(' ',$line);
              #SKIP RECORD IF NOT PRESENT IN GTMAP
	      if (defined $gtmap{$data[0]} == 0 ) {
                next;
              } 
              #PRINT RECORD TO SNPMAP
              if ($k==0 && $PRINTMARKERFILE == 1 ) {   
                print MARK "$data[0]\t$j\t$gtmap{$data[0]}{cM}\t$gtmap{$data[0]}{pos}\t$gtmap{$data[0]}{ref}\t$gtmap{$data[0]}{alt}\n";
              }
              $ref=$gtmap{$data[0]}{ref};
              $alt=$gtmap{$data[0]}{alt};
              for ($i=2; $i<=$#data; $i+=2) {
                #Recode gts
              	if ($data[$i] eq $ref  && $data[$i+1] eq $ref) {print GT_TMP "0";}
                elsif ($data[$i] eq $alt  && $data[$i+1] eq $alt) {print GT_TMP "2";}
               	else {print GT_TMP "1";}
              }
              print  GT_TMP "\n";
            }
            close(IN);
        }
        close(GT_TMP);
        if ($k == 0 && $PRINTMARKERFILE == 1 ){ close(MARK);}
    } #FINISH LOOP OVER CHROM
} #FINISH LOOP OVER POPS

sub read_markers_case{
    my $file=$_[0];
    my $j=0;
    my @data;
    open(HMFILE,"<$file") or die "\ncan't open $file\n";
    #my $junk=<HMFILE>; #READ HEADER
    while(<HMFILE>) {
	chomp($line=$_);
	@data=split('\t',$line);
	$gtmap_cases{$data[0]}{ref} = $data[4];
	$gtmap_cases{$data[0]}{alt} = $data[5];
	$gtmap_cases{$data[0]}{pos} = $data[3];
	$j++;
    }
    close(HMFILE);
    print STDERR "READ IN $j observations from case snp file\n";
    return %gtmap_cases;
}

sub read_rates{
#FUNCTION TO READ IN RECOMBINATION RATES FROM HAPMAP
#REMEMBER RATES ARE BUILD SPECIFIC AND MAPPED BY PHYSPOS NOT RSID
    my $file = $_[0];
    my @data;
    open(RATES,"<$file") or die "Can't open RATES $file\n";
    $header=<RATES>;
    while(<RATES>){
	      chomp($line=$_);
	      @data=split(' ',$line);
        $rates{$data[0]}=$data[2];
    }
    close(RATES);
    return %rates;
}

sub read_markers{
    my $file=$_[0];
    my $j=0;
    my @data;
    open(HMFILE,"<$file") or die "\ncan't open $file\n";
    my $junk=<HMFILE>; #READ HEADER
    while(<HMFILE>){
      chomp($line=$_);
      @data=split(' ',$line);
      $gtmap{$data[0]}{ref}= substr($data[1],0,1);
      $gtmap{$data[0]}{alt}= substr($data[1],2,1);
      $gtmap{$data[0]}{pos}=$data[3];
      $j++;
    }
    close(HMFILE);
    print STDERR "READ IN $j observations from gtmapfile\n";
    return %gtmap;
}


sub fix_rates{
    my %gtmap=%{$_[0]};
    my %rates=%{$_[1]};
    my $i=0;
    my $k=0;   
    print STDERR "mapping rates to snpmap\n";
    my @pos  = sort {$a <=> $b} keys %rates; #list of all pos in rate table
    @rsid = keys %gtmap; #list of all rsid in gtmap
    for ($i=0; $i<=$#rsid; $i++){ 
      	if ( $i % 1000 ==  0 ) {print STDERR "processed $i th marker\n";}
#	print $rsid[$i]."\t";
#	if (defined $gtmap{$rsid[$i]}{pos}) {
#	    print $gtmap{$rsid[$i]}{pos};
#	}
#	else {
#	    exit(1);
#	}
#	$l = scalar @pos;
#	print "\t$l\n";
      	$gtpos=$gtmap{$rsid[$i]}{pos};
        if ( defined $rates{$gtpos} == 0) { #need to interpolate
           #FIND CLOSEST POS 5' AND 3' TO SNP
	   #$small = 0; $large = $gtpos;
	   #print $pos[0]."\n";
           $k=0; while ((exists $pos[$k]) && $pos[$k]<$gtpos){ $k++;} 
	   if ($k != 0 && exists $pos[$k]) { #Avinash, ignore if k>nrates
	       #FIND CLOSEST POS 5' AND 3' TO SNP
	       $small = 0; $large = $gtpos;
	       $k=0; while ((exists $pos[$k]) && $pos[$k]<$gtpos){ $k++;} 
	       if (exists $pos[$k-1]) { $small = $pos[($k-1)]; } 
	       if (exists $pos[$k]) { $large=$pos[$k]; }       
	       #INTERPOLATE
	       $dist=$large-$small;
	       $cmdist=$rates{$large}-$rates{$small};
	       $reldist=($gtpos-$small)/$dist;
	       $cmbase=$rates{$small};       
	       $newcm=$cmbase+($cmdist*$reldist);
	       $gtmap{$rsid[$i]}{cM}=$newcm;
	   } 
	}
        else {
           $gtmap{$rsid[$i]}{cM}=$rates{$gtpos};
           # print "RATES $gtmap{$rsid[$i]}{cM} $rsid[$i] $gtpos\n";
        }	
    }
    print STDERR "Done mapping and interpolating rates to SNPmap\n";
    return %gtmap;
}
