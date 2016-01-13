use above "Genome";
my @pp = Genome::ProcessingProfile::ClinSeq->get(); for (@pp) { 
#    $_->sireport_min_coverage(20); 
#    $_->sireport_min_tumor_vaf(2.5); 
#    $_->sireport_max_normal_vaf(10); 
#    $_->sireport_min_mq_bq("1,1;10,20;20,20;30,20"); 
#    $_->bamrc_version("0.6"); 
#    $_->bamrc_version_clonality("0.4"); 
    $_->exome_cnv(1); 
} 
UR::Context->commit();
