
#kmer_plot<-function()
#{
	require("ggplot2")
	require("reshape2")
	args<-commandArgs()
	print(args)
	f<-args[9]
	print(f)
	t.kmer<-read.table(f, skip = 2)
	head(t.kmer)
	m<-melt(t.kmer, id.vars="V2", measure.vars=c("V5", "V6", "V7"), variable_name= "sample")
	head(m)
	print("1")
	colnames(m)[2]<-"sample"
	m$sample<-as.character(m$sample)
	print("2")
	m$sample[m$sample == "V5"] <- "78"
	m$sample[m$sample == "V6"] <- "91"
	m$sample[m$sample == "V7"] <- "92"
	print("3")
	ggplot(m) + aes(x = V2, y = value, col = sample)  + geom_point() + xlab("Locus") + ylab("Read count") 
	ggsave(paste(f, "_RD.pdf", sep = "")) 
	q()
#}