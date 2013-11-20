# Cost function definition
lbb <- function (abInit, kk, nn) {
                alpha = abInit[1]
                beta = abInit[2]
                sum(-lgamma(alpha+kk)-lgamma(beta+nn-kk)+lgamma(alpha+beta+nn)+lgamma(alpha)+lgamma(beta)-lgamma(alpha+beta))
                }
 
# Optimisation - Pass an array of k, n values to be fitted to this function. 'n' is the number of trials, 'k' is the number of successes.
bbFit <- function (k, n) {
                # Use GLM for initial values assuming beta distribution
                binomGlm <- glm(k/n~1, family=binomial, weights=n)
                binomAb <- c(binomGlm$fitted.values[1], 1 - binomGlm$fitted.values[1])
                #bbOptim <- optim(binomAb, lbb, method="BFGS", hessian=TRUE, nn=n, kk=k)
                bbOptim <- optim(binomAb, lbb, method="L-BFGS-B", lower=c(1,1), upper=c(1000,1000), hessian=FALSE, nn=n, kk=k)#12/10/12
                bbOptim$par
                }
