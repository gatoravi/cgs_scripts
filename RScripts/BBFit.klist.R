##### R code for fitting the beta binomial distribution below
# Cost function definition
lbb_karray <- function (abInit, nn) {
    	      	kk<-1:nn
                alpha = abInit[1]
                beta = abInit[2]
                sum(-lgamma(alpha+kk)-lgamma(beta+nn-kk)+lgamma(alpha+beta+nn)+lgamma(alpha)+lgamma(beta)-lgamma(alpha+beta))
		# return (s)
                }
		
# Optimisation
bbFit <- function (k, n) {
                # Use GLM for initial values assuming beta distribution
                binomGlm <- glm(k/n~1, family=binomial, weights=n)
                binomAb <- c(binomGlm$fitted.values[1], 1 - binomGlm$fitted.values[1])
                bbOptim <- optim(binomAb, lbb, method="BFGS", hessian=TRUE, nn=n, kk=k)
                bbOptim$par
}
