thisname <- "hw1tuning"
# Load base data
localget <- readRDS(file="cpidata.rdata")
localdata <- localget$df
datavars <- localget$vars
getformula <- localget$getformula

# Prepare data locally
parallelprep(df=localdata, LHS="CPI", RHS=datavars,
             holdoutvar="holdout",
             predictor=rf(nodesizes=c(5,7,10),ntrees=c(2,4),pmtrys=c(.2,.3),numericfactors=F,bootstrap=T),
             nfold = 5,
             savename=paste0(thisname,"-rfin"))

instruction <- readRDS(file=paste0(thisname,"-rfin"))

# OLS
olsbaseline <- predictiveanalysis(df=instruction$df, LHS=instruction$settings$LHS, RHS=instruction$settings$RHS,
                                  holdoutvar="holdout", holdout=T,
                                  predictors=list(ols=ols()),
                                  nfold = 5)
saveRDS(olsbaseline,file=paste0(thisname,"-olsbl"))

# Tree by depth
treedepth <- predictiveanalysis(df=instruction$df, LHS=instruction$settings$LHS, RHS=instruction$settings$RHS,
                                holdoutvar="holdout", holdout=T,
                                predictors=list(tree=regtree(minbuckets=c(1),maxdepths=c(5),numericfactors=F)),
                                nfold = 5)
saveRDS(treedepth,file=paste0(thisname,"-treedepth"))

# Tree well-tuned
tunedtree <- predictiveanalysis(df=instruction$df, LHS=instruction$settings$LHS, RHS=instruction$settings$RHS,
                                holdoutvar="holdout", holdout=T,
                                predictors=list(tree=regtree(minbuckets=c(2,4,6,8),maxdepths=c(2,3,4,5,6),numericfactors=F)),
                                nfold = 5)
saveRDS(tunedtree,file=paste0(thisname,"-tunedtree"))