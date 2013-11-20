calcDenovoMatrix<-function(m, d, c)
{
  m2<-10 ^ (-1*m/10)
  mom<-matrix(m2, ncol = length(m2))
  d2<-10 ^ (-1*d/10)
  dad<-matrix(d2, ncol = 1)
  c2<-10 ^ (-1*c/10)
  child<-matrix(c2, ncol = 1)
  P = kronecker(mom, dad)
  F = kronecker(P, child)
  F
}		