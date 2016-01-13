use strict;
use warnings;
use above "Genome";
use lib "/gscuser/aramu/src/Scripts/Perl";
use latex_utils;

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
    print "bq\tmq\tn_unfiltered\tn_filtered\tcommon_name\n";
    foreach my $model (@models) {
        my $build = $model->last_succeeded_build;
        my $common_name = $build->common_name;
        my ($mqs, $bqs) = $model->parse_qualities;
        foreach my $bq (@$bqs) {
            foreach my $mq (@$mqs) {
                my $unf_f = $build->snv_indel_report_clean_unfiltered_file($bq, $mq);
                my $f_f = $build->snv_indel_report_clean_filtered_file($bq, $mq);
                if (-e $f_f and -e $unf_f) {
                    my $uf_lc = Genome::Sys->line_count($unf_f);
                    my $f_lc = Genome::Sys->line_count($f_f);
                    print $bq, "\t", $mq, "\t", $uf_lc, "\t", $f_lc, "\t", $build->common_name, "\n";
                }
              my $cp_command = "cp " . $build->data_directory .
                "/" . $common_name . "/" . "clonality/sciclone/b" . $bq . "_q" . $mq . "/sciclone*exome*pdf " .
                $common_name . "_b" . $bq . "_q" . $mq . "_exome.pdf";
              system($cp_command);
              $cp_command = "cp " . $build->data_directory .
                "/" . $common_name . "/" . "clonality/sciclone/b" . $bq . "_q" . $mq . "/sciclone*wgs*pdf " .
                $common_name . "_b" . $bq . "_q" . $mq . "_wgs.pdf";
              system($cp_command);
              $cp_command = "cp " . $build->data_directory .
                "/" . $common_name . "/" . "clonality/" . $common_name . ".clonality.filtered_snvs.cn2.pdf " .
                $common_name . "original_wgs.clonality.pdf";
              system($cp_command);
            }
        }
        open OUT ,">" . $common_name . "_exome.tex";
        print OUT multipanel_qualityscores($common_name, $bqs, $mqs, "exome");
        close OUT;
        open OUT ,">" . $common_name . "_wgs.tex";
        print OUT multipanel_qualityscores($common_name, $bqs, $mqs, "wgs");
        close OUT;
        #last;
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
