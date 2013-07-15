#ipFile format - chr pos reads_ref reads_alt (reads_ref+reads_alt)
plotFits_SNPs_3_3 <- function(ipFile1, ipFile2, ipFile3, opFile, l_wustl_wex) 
{
	t1<-read.table(ipFile1, sep = "\t")
	t2<-read.table(ipFile2, sep = "\t")
	t3<-read.table(ipFile3, sep = "\t")
	#require(ggplot2)
	source("~/Scripts/var_bin.R")
	source("~/Scripts/var_poisson.R")
	source("~/Scripts/betaBinomial.R")
	source("~/Scripts/var_betbin.R")
	a1<-aggregate(t1$V4, by=list(t1$V5), FUN=var)
	a1<-na.omit(a1)
	a2<-aggregate(t2$V4, by=list(t2$V5), FUN=var)
	a2<-na.omit(a2)
	a3<-aggregate(t3$V4, by=list(t3$V5), FUN=var)
	a3<-na.omit(a3)
	write.table(a1, file = paste(opFile, "_1_variance.txt", sep = ""), sep = "\t", quote = F, row.names = F)
	write.table(a2, file = paste(opFile, "_2_variance.txt", sep = ""), sep = "\t", quote = F, row.names = F)
	write.table(a3, file = paste(opFile, "_3_variance.txt", sep = ""), sep = "\t", quote = F, row.names = F)
	
	pdf(paste(opFile, ".pdf", sep = ""))
	
	print(median(a1$x[1:200]))
	plot(a1$Group.1, a1$x/median(a1$x[1:200]), type = "l", xlim = c(0, 200), ylim = c(0, 5), xlab = "Ref+Alt Count", ylab = "Var of Alt Count", main = opFile)
	#points(a1$Group.1, a1$x/median(a1$x[1:200]), col = 6, type = "l")
	#points(a2$Group.1, a2$x/median(a2$x[1:200]), col = 6, type = "l")
	#points(a3$Group.1, a3$x/median(a3$x[1:200]), col = 6, type = "l")
	
	# Fit to Beta Bin
	ab<-as.vector(bbFit(n = t1$V5, k = t1$V4))
	print(paste("alpha = ", ab[1]))
	print(paste("beta = ", ab[2]))
	class(ab)

	points(a1$Group.1, var_betbin(n = a1$Group.1, a = ab[1], b = ab[2])/median(var_betbin(n = a1$Group.1, a = ab[1], b = ab[2])[1:200]), type = "l", col= "red")
	points(a1$Group.1, var_poisson(n = a1$Group.1, lambda = 0.5)/median( var_poisson(n = a1$Group.1, lambda = 0.5)[1:200]), type = "l", col = "blue")
	points(a1$Group.1, var_bin(n = a1$Group.1, p = 0.5)/median(var_bin(n = a1$Group.1, p = 0.5)[1:200]), type = "l", col = "yellow")
	#dev.off()
	#1:length(l_wustl_wex)
	for (i in 1) {
		print(l_wustl_wex[i])
		t_wustl<-read.table(l_wustl_wex[i], sep = "\t")
		a_wustl<-aggregate(t_wustl$V4, by=list(t_wustl$V5), FUN=var)
		#pdf(paste(i, ".pdf", sep = ""))
		#plot(1:200, type = "l")
		#points(a_wustl$Group.1, a_wustl$x, col = 5, type = "l")
		points(a_wustl$Group.1, a_wustl$x/median(a_wustl$x), col = "orange", type = "l")
		print(median(a_wustl$x))
		#dev.off()
	}
	legend(x = "topright", c("Binomial", "Poisson", "BetaBinomial - fit on NA12878 Variance"),
	         lty=c(1,1), # gives the legend appropriate symbols (lines)
             lwd=c(2.5,2.5),
             col=c("yellow", "blue", "red"))
	legend(x = "topleft", c("CEU", "WUSTL"),
	         lty=c(1,1), # gives the legend appropriate symbols (lines)
             lwd=c(2.5,2.5),
             col=c("black","orange"))

	dev.off()
}
