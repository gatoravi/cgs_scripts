use Genome;
use strict;
use warnings;


#From Jason:
#   genome model reference-alignment instrument-data-alignment-bams --build-id=cf151eae1b8f45539dde3f06e6fb1b69 
my $clinseq_model = Genome::Model::ClinSeq->get($ARGV[0]);
my $wgs_refalign_n_model = $clinseq_model->wgs_model->normal_model;
my $wgs_refalign_t_model = $clinseq_model->wgs_model->tumor_model;
my $wgs_refalign_n_build = $wgs_refalign_n_model->last_succeeded_build;
my $wgs_refalign_t_build = $wgs_refalign_t_model->last_succeeded_build;
my $exome_refalign_n_model = $clinseq_model->exome_model->normal_model;
my $exome_refalign_t_model = $clinseq_model->exome_model->tumor_model;
my $exome_refalign_n_build = $exome_refalign_n_model->last_succeeded_build; 
my $exome_refalign_t_build = $exome_refalign_t_model->last_succeeded_build;
my $op_string = "genome software-result set-test-name --new-test-name='Regenerate bam qc results: RT#99337' ";
my @sr_ids;
my @refalign_builds;
foreach my $build ($wgs_refalign_n_build) {#, $wgs_refalign_t_build, $exome_refalign_t_build, $exome_refalign_n_build) {
  for my $instrument_data ($build->instrument_data) {
    my $instrument_data_id = $instrument_data->id;
    my ($alignment_result) = $build->alignment_results_for_instrument_data($instrument_data);
    unless ($alignment_result) {
      Genome::Sys->warning_message('Missing alignment result for instrument data: '. $instrument_data->id);
      next;
    }
    my ($bamqc_result) = Genome::InstrumentData::AlignmentResult::Merged::BamQc->get(alignment_result_id => $alignment_result->id);
    #print $bamqc_result->_log_directory;
    unless ($bamqc_result) {
      Genome::Sys->warning_message('Missing BamQc result for instrument data: '. $instrument_data->id);
      next;
    }
    my $sr_id = $bamqc_result->id . "\n";
    chomp($sr_id);
    push @sr_ids, $sr_id;
  }
  #my $bam_qc_metrics = Genome::Model::ReferenceAlignment::Command::BamQcMetrics->create(
  #build_id => $build->id, output_directory => "/tmp/");
  #$bam_qc_metrics->execute();
  push @refalign_builds, $build->model_id;
}
my $sr_ids_string = join("\t", @sr_ids);
print $op_string . $sr_ids_string . "\n";
print "genome model build start " . join("\t", @refalign_builds) . "\n";
