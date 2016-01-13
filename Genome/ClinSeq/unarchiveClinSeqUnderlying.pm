use Genome;
use strict;
use warnings;

sub main {
  my $mg_id = $ARGV[0];
  my $target_count = 0;
  my @models;
  if (defined($mg_id)){
    my $mg = Genome::ModelGroup->get("id"=>$mg_id);
    @models = $mg->models;
    $target_count = scalar(@models);
  }
  print "number of models is " . $target_count . "\n";
  my @builds;
  foreach my $model (@models) {
    my $build = $model->last_succeeded_build;
    #my $wgs_refalign_n_model = $clinseq_model->wgs_model->normal_model;
    #my $wgs_refalign_t_model = $clinseq_model->wgs_model->tumor_model;
    #my $wgs_refalign_n_build = $wgs_refalign_n_model->last_succeeded_build;
    #my $wgs_refalign_t_build = $wgs_refalign_t_model->last_succeeded_build;
    my $exome_refalign_n_model = $model->exome_model->normal_model;
    my $exome_refalign_t_model = $model->exome_model->tumor_model;
    my $exome_refalign_n_build = $exome_refalign_n_model->last_succeeded_build;
    my $exome_refalign_t_build = $exome_refalign_t_model->last_succeeded_build;
    push @builds, $exome_refalign_n_build->id, $exome_refalign_t_build->id;
  }
  print "genome model build unarchive @builds --lab Mardis-Wilson";
}

main();
