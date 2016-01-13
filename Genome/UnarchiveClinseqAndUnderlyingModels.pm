use Genome;
use strict;
use warnings;

my @archived_builds;

my $clinseq_build = Genome::Model::Build::ClinSeq->get($ARGV[0]);
if($clinseq_build) {
    push @archived_builds, $clinseq_build->id;
}
my $wgs_somatic_build = $clinseq_build->wgs_build;
if($wgs_somatic_build) {
    push @archived_builds, $wgs_somatic_build->id;
}
my $wgs_refalign_n_build = $clinseq_build->wgs_build->normal_build;
if($wgs_refalign_n_build) {
    push @archived_builds, $wgs_refalign_n_build->id;
}
my $wgs_refalign_t_build = $clinseq_build->wgs_build->tumor_build;
if($wgs_refalign_t_build) {
    push @archived_builds, $wgs_refalign_t_build->id;
}
my $exome_somatic_build = $clinseq_build->exome_build;
if($exome_somatic_build) {
    push @archived_builds, $exome_somatic_build->id;
}
my $exome_refalign_n_build = $clinseq_build->exome_build->normal_build;
if($exome_refalign_n_build) {
    push @archived_builds, $exome_refalign_n_build->id;
}
my $exome_refalign_t_build = $clinseq_build->exome_build->tumor_build;
if($exome_refalign_t_build) {
    push @archived_builds, $exome_refalign_t_build->id;
}

print "genome model build unarchive @archived_builds --lab Mardis-Wilson";
