use above "Genome";

#This example uses HCC32.
my $clinseq_model = Genome::Model::ClinSeq->get(id => "6b0bee236ccc468ca153fd2f0af42d1b");

my $normal_dd = $clinseq_model->exome_model->normal_model->last_succeeded_build->data_directory;
my $tumor_dd = $clinseq_model->exome_model->tumor_model->last_succeeded_build->data_directory;

print "normal\t", $normal_dd, "\ntumor\t", $tumor_dd;
