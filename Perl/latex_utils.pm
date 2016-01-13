package latex_utils;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(multipanel_qualityscores);
@EXPORT_OK = qw(multipanel_qualityscores);

sub multipanel_qualityscores {
  my $common_name = shift;
  my $bqs = shift;
  my $mqs = shift;
  my $data_type = shift;

  my $latex_command = 
  '\documentclass[a4paper,12pt]{article}' . "\n" .
  '\usepackage[english]{babel}' . "\n" .
  '\usepackage{graphicx}' . "\n" .
  '\usepackage{caption}' . "\n" .
  '\usepackage{subcaption}' . "\n" .
  '\begin{document}' . "\n" .
  '\begin{figure}'. "\n";
  my $i = 0;
  foreach my $bq(@$bqs) {
    foreach my $mq(@$mqs) {
      $latex_command .= '\begin{subfigure}[b]{0.2\textwidth}' . "\n" . '\includegraphics[width=\textwidth]{' . $common_name . '_b' . $bq . '_q' . $mq . '_' . $data_type .'}' . "\n" . '\caption{bq='. $bq . ',mq=' . $mq .'}' . "\n" . '\label{fig:figure'. $i . '}' . "\n" . '\end{subfigure}' . "\n";
      if(($i+1) % 4) {
        $latex_command .= '~' . "\n";
      } else {
        $latex_command .= '\\\\' . "\n";
      }
      $i++;
    }
  }
  print $latex_command;
  $latex_command .= '\end{figure}' . "\n";
  $latex_command .= '\end{document}' . "\n";
  return $latex_command;
}

1;
