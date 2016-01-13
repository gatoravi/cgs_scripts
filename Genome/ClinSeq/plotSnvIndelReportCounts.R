#! /bin/Rscript
require(ggplot2)
t<-read.table("samples.counts.txt", head = T)
for (sample in unique(t$common_name)) { print(sample); t.subset = t[t$common_name == sample, ]; t.subset.o<-t.subset[order(t.subset$n_filtered),]; print(t.subset.o); print(ggplot(t.subset.o) + geom_bar(stat = "identity", aes(x = cutoff, y = n_filtered)) + ggtitle(sample) +  opts(axis.text.x=theme_text(angle=-90))) ; ggsave(paste(sample, ".pdf", sep = "")) }
