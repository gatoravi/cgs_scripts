require(ggplot2)

usage<-function() {
  print("write me ")
}

plot_wgs_exome<-function(t, cutoff, sample_name) {
  if("WGS_Tumor_VAF"  %in% colnames(t) & "Exome_Tumor_VAF"  %in% colnames(t)) {
    print(ggplot(t) + geom_point(aes(x=WGS_Tumor_VAF, y = Exome_Tumor_VAF)) + 
    labs(title = sample_name) + 
    annotate("text", x = 10, y = 90, label = paste("n = ", nrow(t))))
    t.filtered<-subset(t, (Exome_Tumor_ref_rc + Exome_Tumor_var_rc) > cutoff & 
      (WGS_Tumor_ref_rc + WGS_Tumor_var_rc) > cutoff)
    print(ggplot(t.filtered) + geom_point(aes(x=WGS_Tumor_VAF, y = Exome_Tumor_VAF)) + 
    labs(title = sample_name) + 
    annotate("text", x = 10, y = 90, label = 
        paste("n = ", nrow(t.filtered), ", RD cutoff = ", cutoff)))
  }
}

plot_wgs_rnaseq<-function(t, cutoff, sample_name) {
  if("WGS_Tumor_VAF"  %in% colnames(t) & "RNAseq_Tumor_VAF"  %in% colnames(t)) {
    ggplot(t) + geom_point(aes(x=WGS_Tumor_VAF, y = RNAseq_Tumor_VAF)) + 
    labs(title = sample_name) + 
    annotate("text", x = 10, y = 90, label = paste("n = ", nrow(t)))
  }
}

plot_exome_rnaseq<-function(t, cutoff, sample_name) {
  if("Exome_Tumor_VAF"  %in% colnames(t) & "RNAseq_Tumor_VAF"  %in% colnames(t)) {
    ggplot(t) + geom_point(aes(x=Exome_Tumor_VAF, y = RNAseq_Tumor_VAF)) + 
    labs(title = sample_name) + 
    annotate("text", x = 10, y = 90, label = paste("n = ", nrow(t)))
  }
}

args <- commandArgs(trailingOnly = TRUE)
if(length(args) != 4) {
  usage()
  quit()
}

#MAIN()
snv_rd_f = args[1]
rd_cutoff = args[2]
plot_file = args[3]
sample_name = args[4]

t.snv.rd<-read.table(snv_rd_f, head = T)
pdf(plot_file)
plot_wgs_exome(t.snv.rd, rd_cutoff, sample_name)
plot_wgs_rnaseq(t.snv.rd, rd_cutoff, sample_name)
plot_exome_rnaseq(t.snv.rd, rd_cutoff, sample_name)
dev.off()
