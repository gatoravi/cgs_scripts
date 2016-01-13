package Genome::Model::ClinSeq::Command::Converge::PlotStats;

use strict;
use warnings;
use Genome;

class Genome::Model::ClinSeq::Command::Converge::PlotStats {
  is => 'Genome::Model::ClinSeq::Command::Converge::Base',
  has_input => [
  outdir => {
    is => 'FilesystemPath',
    doc => 'Directory to write results',
  },
  min_coverage => {
    is => 'Number',
    doc => 'Minimum coverage cutoff for all technologies',
    default => 10,
    is_optional => 1,
  },
  ],
  doc => 'Plot stats from WGS, Exome, RNA-seq from clin-seq builds.',
};

sub help_synopsis {
  return <<EOS
genome model clin-seq converge plot-stats --builds='id in ["4b7539bb10cc4b9c97577cf11f4c79a2","cdca0edf526c4fe193d3054627a5871b"]' --outdir=/tmp/stat_report/

genome model clin-seq converge plot-stats --builds='model.id=9d0fcdca2b5d4f4385b83d2f75addac4,is_last_complete=1' --outdir=/tmp/stat_report/

genome model clin-seq converge plot-stats --builds='model_groups.id=786367aa2edc41e1b4a5d33787a8c003,is_last_complete=1' --outdir=/tmp/stat_report/

genome model clin-seq converge plot-stats --builds='model.id in ["279f50e35d2b479ea3c32486eafd4ad4","7143119a93984056ae3f32c88c9ac2a1"],is_last_complete=1' --outdir=/tmp/stat_report/
EOS
}

sub help_detail {
  return <<EOS
Plot stats from different clinseq builds.
EOS
}

sub __errors__ {
  my $self = shift;
  my @errors = $self->SUPER::__errors__(@_);

  unless (-e $self->outdir && -d $self->outdir) {
    push @errors, UR::Object::Tag->create(
      type => 'error',
      properties => ['outdir'],
      desc => "Outdir: " . $self->outdir . " not found or not a directory",
    );
  }
  return @errors;
}

sub execute {
  my $self = shift;
  $self->plot_wgs_exome_rnaseq_stats();
  return 1;
}

sub plot_wgs_exome_rnaseq_stats() {
  my $self = shift;
  my @builds = $self->builds;
  foreach my $build (@builds) {
      my $common_name = $build->common_name;
      my $stat_rd_file = $self->copy_stat_file($build, $common_name);
      if ($stat_rd_file eq "NA") {
        $self->status_message("Skipping $common_name, this sample does not have the stat_rd_file");
        next;
      }
      $self->create_combined_plot($stat_rd_file, $common_name);
  }
}

sub create_combined_plot {
  my $self = shift;
  my $stat_rd_file = shift;
  my $common_name = shift;
  my $min_rd = $self->min_coverage;
  my $plot = $self->outdir . $common_name . ".combinedstat.pdf";
  my $Rscript = "Rscript " . __FILE__ . ".R";
  my $plot_cmd = $Rscript . " $stat_rd_file $min_rd $plot $common_name";
#  Genome::Sys->shellcmd(cmd => $plot_cmd);
}

sub copy_stat_file {
  my $self = shift;
  my $build = shift;
  my $common_name = shift;
  my $clinseq_build = Genome::Model::Build::ClinSeq->get(id => $build->id);
  my $stat_rd_file = $clinseq_build->input_summary_stats_file;
  if($stat_rd_file) {
    $stat_rd_file = $self->copy_to_outdir($stat_rd_file, $common_name . ".input.summarystats.txt");
  } else {
    $stat_rd_file = "NA";
  }
  return $stat_rd_file;
}

sub copy_to_outdir {
  my $self = shift;
  my $file = shift;
  my $outfile = shift;
  my $outdir = $self->outdir;
  $outfile = $outdir . "/" . $outfile;
  unlink $outfile;
  Genome::Sys->copy_file($file, $outfile);
  return $outfile;
}

1;
