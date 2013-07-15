plotFits_SNPs <- function(ipFile, opFile) 
{
	t<-read.table(ipFile)
	#require(ggplot2)
	source("~/Scripts/var_bin.R")
	source("~/Scripts/var_poisson.R")
	source("~/Scripts/betaBinomial.R")
	source("~/Scripts/var_betbin.R")
	a<-aggregate(t$V4, by=list(t$V5), FUN=var)
	a<-na.omit(a)
	write.table(a, file = paste(opFile, "_variance", sep = ""), sep = "\t", quote = F, row.names = F)
	ab<-as.vector(bbFit(n = t$V5, k = t$V4))
	pdf(paste(opFile, ".pdf", sep = ""))
	print(ab[1])
	print(ab[2])
	class(ab)
	plot(a$Group.1, a$x, type = "l", xlim = c(0, 200), ylim = c(0, 500), xlab = "Ref+Alt Count", ylab = "Var of Alt Count", main = opFile)
	points(a$Group.1, var_betbin(n = a$Group.1, a = ab[1], b = ab[2]), type = "l", col= "red")
	points(a$Group.1, var_poisson(n = a$Group.1, lambda = 0.5), type = "l", col = "blue")
	points(a$Group.1, var_bin(n = a$Group.1, p = 0.5), type = "l", col = "green")
	legend(130, 500, 
			 c("Binomial", "Poisson", "BetaBinomial", "Exome Data"),
	         lty=c(1,1), # gives the legend appropriate symbols (lines)
             lwd=c(2.5,2.5),
             col=c("green","blue", "red", "black"))
	dev.off()
	#return(a)
}
