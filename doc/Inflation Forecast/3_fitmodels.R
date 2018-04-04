rawdata <- readRDS(file="cpidata.rdata")
instruction <- list(df=rawdata$df,settings=list(LHS="CPI",RHS=rawdata$vars))

# Fit models
thisname <- "fittedmodels"

olsbaseline <- predictiveanalysis(df=instruction$df, LHS=instruction$settings$LHS, RHS=instruction$settings$RHS,
                                  holdoutvar="holdout", holdout=T,
                                  predictors=list(ols=ols()),
                                  nfold = 5)
saveRDS(olsbaseline,file=paste0(thisname,"-olsbl"))

treedepth <- predictiveanalysis(df=instruction$df, LHS=instruction$settings$LHS, RHS=instruction$settings$RHS,
                                holdoutvar="holdout", holdout=T,
                                predictors=list(tree=regtree(minbuckets=c(1),maxdepths=c(4),numericfactors=F)),
                                nfold = 5)
saveRDS(treedepth,file=paste0(thisname,"-treedepth"))

tunedtree <- predictiveanalysis(df=instruction$df, LHS=instruction$settings$LHS, RHS=instruction$settings$RHS,
                                holdoutvar="holdout", holdout=T,
                                predictors=list(tree=regtree(minbuckets=c(2),maxdepths=c(5),numericfactors=F)),
                                nfold = 5)
saveRDS(tunedtree,file=paste0(thisname,"-tunedtree"))
