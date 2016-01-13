use strict;
use warnings;
use above "Genome";

sub main {
    my $mg_id = $ARGV[0];
    my $target_count;
    my @models;
    if (defined($mg_id)){
        my $mg = Genome::ModelGroup->get("id"=>$mg_id);
        @models = $mg->models;
        $target_count = scalar(@models);
    }
    print "number of models is " . $target_count . "\n";
    print "bq\tmq\tn_unfiltered\tn_filtered\tcommon_name\tcutoff\n";
    foreach my $model (@models) {
        my ($mqs, $bqs) = parse_qualities($model);
        foreach my $bq (@$bqs) {
            foreach my $mq (@$mqs) {
                my $build = $model->last_succeeded_build;
                my $unf_f = $build->snv_indel_report_clean_unfiltered_file($bq, $mq);
                my $f_f = $build->snv_indel_report_clean_filtered_file($bq, $mq);
                if (-e $f_f and -e $unf_f) {
                    my $uf_lc = Genome::Sys->line_count($unf_f);
                    my $f_lc = Genome::Sys->line_count($f_f);
                    print $bq, "\t", $mq, "\t", $uf_lc, "\t", $f_lc, "\t", $build->common_name, "\t", "bq" . $bq . "_mq" . $mq, "\n";
                }
            }
        }
    }
}

sub parse_qualities {
  my $self = shift;
  my $min_mq = $self->sireport_min_mq;
  my $min_bq = $self->sireport_min_bq;
  my @mqs = split(",", $min_mq);
  my @bqs = split(",", $min_bq);
  foreach my $mq(@mqs) {
    if($mq < 0) {
      die $self->error_message("Negative mapping quality $mq in Processing Profile");
    }
  }
  foreach my $bq(@bqs) {
    if($bq < 0) {
      die $self->error_message("Negative mapping quality $bq in Processing Profile");
    }
  }
  return (\@mqs, \@bqs);
}

main();

1;
