library(brms)
library(BhGLM)
set.seed(123)
rmvnorm <- function (n, mean = rep(0, nrow(sigma)), sigma = diag(length(mean)), 
                     method = c("svd", "eigen", "chol"), pre0.9_9994 = FALSE) 
{
  if (!isSymmetric(sigma, tol = sqrt(.Machine$double.eps), 
                   check.attributes = FALSE)) {
    stop("sigma must be a symmetric matrix")
  }
  if (length(mean) != nrow(sigma)) 
    stop("mean and sigma have non-conforming size")
  method <- match.arg(method)
  R <- if (method == "eigen") {
    ev <- eigen(sigma, symmetric = TRUE)
    if (!all(ev$values >= -sqrt(.Machine$double.eps) * abs(ev$values[1]))) {
      warning("sigma is numerically not positive definite")
    }
    t(ev$vectors %*% (t(ev$vectors) * sqrt(ev$values)))
  }
  else if (method == "svd") {
    s. <- svd(sigma)
    if (!all(s.$d >= -sqrt(.Machine$double.eps) * abs(s.$d[1]))) {
      warning("sigma is numerically not positive definite")
    }
    t(s.$v %*% (t(s.$u) * sqrt(s.$d)))
  }
  else if (method == "chol") {
    R <- chol(sigma, pivot = TRUE)
    R[, order(attr(R, "pivot"))]
  }
  retval <- matrix(rnorm(n * ncol(sigma)), nrow = n, byrow = !pre0.9_9994) %*% R
  retval <- sweep(retval, 2, mean, "+")
  nm <- names(mean)
  if (is.null(nm) && !is.null(colnames(sigma))) nm <- colnames(sigma)
  colnames(retval) <- nm
  if (n == 1) drop(retval)
  else retval
}
sim.x <- function(n, m, corr = 0.6, v = rep(1, m), p = 0.5, genotype = NULL, 
                  method = c("svd", "chol", "eigen"), joint = TRUE, verbose = FALSE)
{
  start.time <- Sys.time()
  vars <- paste("x", 1:m, sep = "")
   sigma1=rep(1,m)%*%t(1:m)
  sigma2=abs(sigma1-t(sigma1))
  V=0.2^sigma2
  rownames(V) <- colnames(V) <- unique(vars)
  
  method <- method[1]
  x <- matrix(0, n, m)
  colnames(x) <- unique(vars)
  x <- rmvnorm(n = n, mean =c(rep(log(0.5*m), 5),rep(0,m-5)), sigma = V,method = method)
  
  stop.time <- Sys.time()
  minutes <- round(difftime(stop.time, start.time, units = "min"), 3)
  if (verbose) cat("simulation time:", minutes, "minutes \n")
  
  return(data.frame(x))
}

n=n
m=100
he=he
k = sim.x(n=n, m=m)
colMeans(k)
cor.test(k$x1,k$x2)
sd(k$x1)
x1=exp(k)
x2 = x1/rowSums(x1)
rowSums(x2)
x3=log(x2)
x5=log(x2[,1:m-1]/x2[,m])

#x=x3[,1:m-1]-x3[,m]
h = rep(he, 4)
nz = as.integer(seq(2, m, by=m/length(h))); nz

yy=sim.y(x=x5[, nz], mu=0, herit=h, p.neg=0.75, sigma=1.6, theta=2)
yy$coefs
y = yy$y.normal; fam = gaussian; 
#y = yy$y.ordinal; fam = binomial
dat=data.frame(y,x3)
  q=n/2
  b=q+1
 dat1=dat[1:q,]
 dat2=dat[b:n,]
 dim(dat1);dim(dat2)


