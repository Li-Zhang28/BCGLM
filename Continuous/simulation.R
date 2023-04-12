library(MASS)
library(phyloseq)
  p=100
  n=n
  snr=snr
  gammatrue=rep(0,p)
  true_index=seq(18,40,by=2)
  gammatrue[true_index]=1
  b1=c(2.0800,-1.3900,2.1200,1.3100,-1.8600,-1.3400)
  b2=c(-1.4100,-1.1500,2.5100,-1.9500,1.9300,-0.8500)
  b=rep(0,p)
  index1=seq(1,length(true_index),by=2)
  index2=seq(2,length(true_index),by=2)
  b[true_index[index1]]=b1
  b[true_index[index2]]=b2
  sigmaX=1
  sigma=1/snr*mean(abs(c(b1,b2)))
  sigma1=rep(1,p)%*%t(1:p)
  sigma2=abs(sigma1-t(sigma1))
  sigma3=0.2^sigma2
  
  theta=rep(0,p)
  theta[true_index]=log(0.5*p)
  beta=gammatrue*b
  X=mvrnorm(n,theta,sigma3)
  x=exp(X)
  x1 = x/rowSums(x)
  x2=log(x1)
  epsilon=rnorm(n,0,sigma)
  y=x2%*%beta+epsilon
  dat=data.frame(y,x2)
  q=n/2
  m=q+1
 dat1=dat[1:q,]
 dat2=dat[m:n,]
 dim(dat1);dim(dat2)



 