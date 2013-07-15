var_betbin <- function (n, a, b) {
	variance = n*a*b*(a+b+n) / (((a+b)^2) * (a+b+1))
	return(variance)
}