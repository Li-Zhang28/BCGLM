###Load library
library(brms)
library(BhGLM)
 library(rstan)
  rstan_options(auto_write = TRUE)
###dissimilarity matrix
  dist = c("bray", "jaccard", "jsd", "unifrac", "wunifrac", "dpcoa")
  m = dist[1]
  otu=otu_table(exp(dat1[,2:(p+1)]),taxa_are_rows = F)
  dis.taxa = distance(otu, method=m, type="taxa") 
  dis.taxa = as.matrix(dis.taxa); dim(dis.taxa)
###similarity matrix
  simi.mat <- function(dis.mat)
  {
    n <- ncol(dis.mat)
    D2 <- dis.mat^2
    I <- diag(1, n)
    II <- array(1, c(n,n))
    K <- -0.5 * (I - II/n) %*% D2 %*% (I - II/n)
    # to ensure a positive semi-definite matrix
    # method 1
    ev <- eigen(K)
    v <- ev$vectors
    e <- abs(ev$values)
    K <- v %*% diag(e) %*% t(v)
    K
  }
  
  K.taxa = simi.mat(dis.taxa); dim(K.taxa)
  
  taxa = as.numeric(K.taxa)
  node1 = node2 = w = NULL
  for (i in 1:(ncol(K.taxa)-1))
    for (j in (i+1):ncol(K.taxa))
    {
      if(abs(K.taxa[i,j]) > 0.18) ##quantile(abs(taxa))[3]
      {
        node1 = c(node1,i);
        node2 = c(node2,j);
        w = c(w, K.taxa[i,j])
     }
    }
  w = sqrt(abs(w)); length(w)
  

 RP = beta!=0

 ###BCGLM

fm = bf(y ~ ., center=T)

### In real data analysis, the number of identified taxa in univariate generalized linear models can serve as a reasonable
### prior guess for 𝑚0

e1=p-12
 bp4 = set_prior("horseshoe(df=1, df_global=1,par_ratio=12/e1)", class="b")
 bp4= bp4 + set_prior("target += normal_lpdf(mean(b) | 0, 0.001)", check=F) # sensitive to the variance of mean(b)
 bp4 = bp4 + set_prior("target += -0.5*dot_self(w .* (log(hs_local[node1])-log(hs_local[node2])))", check=F)

 ln = length(node1)
 stanvars =stanvar(x=ln, name="ln", scode="int ln;", block="data") +
  stanvar(x=node1, name="node1", scode="int node1[ln];", block="data") +
  stanvar(x=node2, name="node2", scode="int node2[ln];", block="data") +
  stanvar(x=w, name="w", scode="vector[ln] w;", block="data") 

f4= brm(fm, data=dat1, family=gaussian(), prior=bp4, stanvars=stanvars,control = list(adapt_delta = 0.95,max_treedepth= 15),
        chains=4, iter=4000)
samples4 = fixef(f4)
samples4=samples4[-1,]
sum_c1=sum(samples4[,1])
PP4 = (samples4[,4]<0)|(samples4[,3]>0)
FP4 = sum(PP4=="TRUE"&RP=="FALSE")
TP4= sum(PP4=="TRUE"&RP=="TRUE")
FN4 = sum(PP4=="FALSE"&RP=="TRUE")
TN4 = sum(PP4=="FALSE"&RP=="FALSE")

mse4=sum((samples4[,1]-beta)^2)/p
FP4;FN4;mse4

y=dat2$y
pred4 = predict(f4, newdata=dat2[,-1])[,1]
a4=measure.glm(y, pred4, family="gaussian")
a4

###########
 
