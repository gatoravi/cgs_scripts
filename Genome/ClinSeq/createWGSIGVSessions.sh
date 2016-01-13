use strict;
use warnings;
use above "Genome";
use lib "/gscuser/aramu/src/Scripts/Perl";
use latex_utils;

sub main {
    my $mg_id = $ARGV[0];
    my $target_count = 0;
    my @models;
    if (defined($mg_id)) {
        my $mg = Genome::ModelGroup->get("id"=>$mg_id);
        @models = $mg->models;
        $target_count = scalar(@models);
    }
    print "number of models is " . $target_count . "\n";
    foreach my $model (@models) {
      my $build = $model->last_succeeded_build;
      my $common_name = $build->common_name;
      my $wgs_tumor_bam = "https://gscweb.gsc.wustl.edu/" . $model->wgs_model->tumor_model->last_succeeded_build->merged_alignment_result->bam_file;
      my $wgs_normal_bam = "https://gscweb.gsc.wustl.edu/" . $model->wgs_model->normal_model->last_succeeded_build->merged_alignment_result->bam_file;
      my $wgs_tumor_coverage = $wgs_tumor_bam . "_coverage";
      my $wgs_normal_coverage = $wgs_normal_bam . "_coverage";
      my $tumor_type = $model->exome_model->subject->common_name;
      $tumor_type =~ s/pre-treatment met/1/;
      $tumor_type =~ s/recurrence met/2/;
      $tumor_type =~ s/relapse2//;
      $tumor_type =~ s/tumor//;
      if ($tumor_type ne "") {
        $common_name = $common_name . "_" . $tumor_type;
      }
      open OUT ,">" . $common_name . "_wgs_igv.xml";
      print OUT '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Session genome="b37" locus="17:7569720-7592868" version="4">

  <Resources>
    <Resource path="' . $wgs_normal_bam . '"/>
    <Resource path="' . $wgs_tumor_bam . '"/>
  </Resources>

  <Panel name="Panel1">
    <Track altColor="0,0,178" autoScale="true" color="175,175,175" colorScale="ContinuousColorScale;0.0;9062.0;255,255,255;175,175,175" displayMode="COLLAPSED" featureVisibilityWindow="-1" fontSize="11" id="' . $wgs_normal_coverage . '" name="WGS Normal Coverage" showDataRange="true" visible="true">
      <DataRange baseline="0.0" drawBaseline="true" flipAxis="false" maximum="100.0" minimum="0.0" type="LINEAR"/>
    </Track>
    <Track altColor="0,0,178" color="0,0,178" colorOption="UNEXPECTED_PAIR" displayMode="EXPANDED" featureVisibilityWindow="-1" fontSize="11" id="' . $wgs_normal_bam . '" name="WGS Normal Reads" showDataRange="true" sortByTag="" visible="true"/>
  </Panel>
  <Panel name="Panel2">
    <Track altColor="0,0,178" autoScale="true" color="175,175,175" colorScale="ContinuousColorScale;0.0;9062.0;255,255,255;175,175,175" displayMode="COLLAPSED" featureVisibilityWindow="-1" fontSize="11" id="' . $wgs_tumor_coverage . '" name="WGS Tumor Coverage" showDataRange="true" visible="true">
      <DataRange baseline="0.0" drawBaseline="true" flipAxis="false" maximum="100.0" minimum="0.0" type="LINEAR"/>
    </Track>
    <Track altColor="0,0,178" color="0,0,178" colorOption="UNEXPECTED_PAIR" displayMode="EXPANDED" featureVisibilityWindow="-1" fontSize="11" id="'. $wgs_tumor_bam . '" name="WGS Tumor Reads" showDataRange="true" sortByTag="" visible="true"/>
  </Panel>
  <PanelLayout dividerFractions="0.000, 0.330, 0.660"/>
</Session>
';
      close OUT;
    }
}

main();

1;
