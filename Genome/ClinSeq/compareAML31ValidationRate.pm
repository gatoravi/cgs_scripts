use strict;
use warnings;
use above "Genome";

sub main {
  my $m_id = $ARGV[0];
  my $model;
  if (defined($m_id)){
    $model = Genome::Model->get("id"=>$m_id);
  }
  my $AML31_sorted_op_file = get_AML31_tps();
  print "bq\tmq\tn_unfiltered\tn_unfiltered_validated\tn_filtered\tn_filtered_validated\tcommon_name\tcutoff\n";
  my ($mqs, $bqs) = parse_qualities_new($model);
  foreach my $bq (@$bqs) {
    foreach my $mq (@$mqs) {
      my $build = $model->last_succeeded_build;
      my $unf_f = $build->snv_indel_report_clean_unfiltered_file($bq, $mq);
      my $f_f = $build->snv_indel_report_clean_filtered_file($bq, $mq);
      if (-e $f_f and -e $unf_f) {
        unlink("filtered.tsv", "filtered.bed", "filtered.validated.tsv", "unfiltered.tsv", "unfiltered.bed", "unfiltered.validated.tsv");
        my $uf_lc = Genome::Sys->line_count($unf_f);
        Genome::Sys->copy_file($unf_f, "unfiltered.tsv");
        system('awk \'{ if(NR!=1) { print $1"\t"$2"\t"$3 } }\' unfiltered.tsv > unfiltered.bed');
        system("joinx sort unfiltered.bed > unfiltered.sorted.tsv");
        system("joinx intersect $AML31_sorted_op_file unfiltered.sorted.tsv > unfiltered.validated.tsv");
        my $uf_v_lc = Genome::Sys->line_count("unfiltered.validated.tsv");
        Genome::Sys->copy_file("unfiltered.tsv", "unfiltered_b" . $bq . "_q" . $mq . ".tsv");
        
        my $f_lc = Genome::Sys->line_count($f_f);
        Genome::Sys->copy_file($f_f, "filtered.tsv");
        system('awk \'{ if(NR!=1) { print $1"\t"$2"\t"$3 } }\' filtered.tsv > filtered.bed');
        system("joinx sort filtered.bed > filtered.sorted.tsv");
        system("joinx intersect $AML31_sorted_op_file filtered.sorted.tsv > filtered.validated.tsv");
        my $f_v_lc = Genome::Sys->line_count("filtered.validated.tsv");

        print $bq, "\t", $mq, "\t", $uf_lc, "\t", $uf_v_lc, "\t", $f_lc, "\t", $f_v_lc, "\t", $build->common_name, "\t", "bq" . $bq . "_mq" . $mq, "\n";
      }
    }
  }
}

sub get_AML31_tps {
  my $AML31_tp_file = "/gscmnt/gc6122/info/medseq/aml31.deepseq/vars.platinum.tumorOnly.anno.tiered.rcnt.postReview";
  my $AML31_sorted_tp_file = "AML31.tp.sorted.bed";
  unless( -e $AML31_sorted_tp_file) {
    system("joinx sort $AML31_tp_file > $AML31_sorted_tp_file");
  }
  return $AML31_sorted_tp_file;
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

sub parse_qualities_new {
  my $self = shift;
  my $min_mq_bq = $self->sireport_min_mq_bq;
  my @mq_bq_pairs = split(";", $min_mq_bq);
  my @mqs = (1, 10, 20, 30);
  my @bqs = (0, 20, 30, 40);
#  foreach my $mq_bq_pair(@mq_bq_pairs) {
#    my ($mq, $bq) = split(",", $mq_bq_pair);
#    if($mq < 0) {
#      die $self->error_message("Negative mapping quality $mq in Processing Profile");
#    }
#    if($bq < 0) {
#      die $self->error_message("Negative mapping quality $bq in Processing Profile");
#    }
#    push @mqs, $mq;
#    push @bqs, $bq;
#  }
  return (\@mqs, \@bqs);
}

main();

1;
