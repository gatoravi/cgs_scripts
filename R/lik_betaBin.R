#This function calculates the likelihood of a beta binomial function: given n, k, alpha and beta values. Refer to the PMF formula in Wikipedia.

lik_betaBin <- function(ipFile, alpha1, beta1, alpha2, beta2, opFile)
{
	t<-read.table(ipFile, sep = "\t")
	print(head(t))

	n <- as.vector(t$V5)
	k <- as.vector(t$V4)
	#print(n)
	#print(k)
	#print (n[42422])
	#print (k[42422])

	c <- choose(n, k)
	#print(c)

	t1 <- k + alpha1
	t2 <- n - k + beta1
	num <- beta(t1, t2)
	print(paste("num is ", num, sep = "\t"))
	denom <- beta(alpha1, beta1)
	print(paste("denom is ", denom, sep = "\t"))
	l1 <- c * num / denom
	
	print("2")
	t1 <- k + alpha2
	t2 <- n - k + beta2
	num <- beta(t1, t2)
	denom <- beta(alpha2, beta2)
	l2 <- c * num / denom

	print("3")
	#lrt = -2 * (log(l1)  - log(l2))
	tout <- cbind(n, k, l1, l2)
	head(tout)
	print("Hello")
	write.table(tout, quote = F, file = opFile, sep = "\t", row.names = F, col.names = F)

	lrt = -2 * ( sum(log(l2)) - sum(log(l1)) )
	print(paste("LRT is ", lrt, sep = ""))

	
}