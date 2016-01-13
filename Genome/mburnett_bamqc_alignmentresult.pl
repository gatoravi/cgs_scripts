#!/usr/bin/env genome-perl

use strict;
use warnings FATAL => 'all';

use Genome;

unless ($ARGV[0]) {
    die "Must specify a build id as the first argument.";
}

my $build = Genome::Model::Build->get($ARGV[0]);

my @bam_qc_srs = Genome::InstrumentData::AlignmentResult::Merged::BamQc->get(
    builds => $build);

my @headers = qw(
    INSTRUMENT_DATA_ID
    FLOW_CELL_ID
    LANE
    BAM_PATH
    BAMQC_PATH
    BAMQC_ID
);
_print_line(@headers);


for my $bqc_sr (@bam_qc_srs) {
    my $alignment_result = $bqc_sr->alignment_result;
    my $instrument_data = $alignment_result->instrument_data;

    my $bam_path = $alignment_result->output_dir . '/all_sequences.bam';

    _print_line($instrument_data->id,
        $instrument_data->flow_cell_id, $instrument_data->lane, $bam_path,
        $bqc_sr->output_dir, $bqc_sr->id);
}


sub _print_line {
    printf("%s\t%s\t%s\t%s\t%s\t%s\n", @_);
}
