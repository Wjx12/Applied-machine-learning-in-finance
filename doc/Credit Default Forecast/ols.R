thisname <- "hw2OLS"
# Load base data
localget <- readRDS(file="defaultdataOLS.rdata")
localdata <- localget$df
datavars <- localget$vars
getformula <- localget$getformula

# Prepare data locally
parallelprep(df=localdata, LHS="default", RHS=datavars,
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


