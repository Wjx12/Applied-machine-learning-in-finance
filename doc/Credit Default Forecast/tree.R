thisname <- "hw2Tree"
# Load base data
localget <- readRDS(file="defaultdataTREE.rdata")
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


# Tree by depth
treedepth <- predictiveanalysis(df=instruction$df, LHS=instruction$settings$LHS, RHS=instruction$settings$RHS,
                                holdoutvar="holdout", holdout=T,
                                predictors=list(tree=regtree(minsplits=20,maxdepths=8,numericfactors=F)),
                                nfold = 5)
saveRDS(treedepth,file=paste0(thisname,"-treedepth"))

