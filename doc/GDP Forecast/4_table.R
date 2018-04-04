library(ggplot2)
library(rpart)

# Load base data
basedata <- readRDS(file="cpidata.rdata")

# Fitted objects
olsbaseline <- readRDS(file="fittedmodels-olsbl")
treedepth <- readRDS(file="fittedmodels-treedepth")
tunedtree <- readRDS(file="fittedmodels-tunedtree")

# Combine data into one
fulldata <- olsbaseline$returndf[,c("CPI","holdout")]
fulldata$OLS <- olsbaseline$returndf$prediction
fulldata$Tree <- treedepth$returndf$prediction
fulldata$TreeFull <- tunedtree$returndf$prediction

# Calculate losses
losses <- fulldata[,c("CPI","holdout")]
isvar <- mean((losses$CPI[!losses$holdout] - mean(losses$CPI[!losses$holdout]))^2)
oosvar <- mean((losses$CPI[losses$holdout] - mean(losses$CPI[losses$holdout]))^2)

# Put together into one table
table1 <- data.frame(setup=NULL,predictor=NULL,parameters=NULL,
                     ismse=NULL,isr2=NULL,
                     oosmse=NULL,oosse=NULL,oosr2=NULL,oosr2ci1=NULL,oosr2ci2=NULL)

for(method in setdiff(names(fulldata),c("CPI","holdout"))) {
  losses[,method] <- (fulldata[,method] - fulldata$CPI)^2
  
  table1 <- rbind(table1,data.frame(method=method,
                                    ismse=mean(losses[!losses$holdout,method]),
                                    isr2= 1 - mean(losses[!losses$holdout,method]) / isvar,
                                    oosmse=mean(losses[losses$holdout,method]),
                                    oosse=sd(losses[losses$holdout,method]) / sqrt(sum(losses$holdout)),oosr2=1 - mean(losses[losses$holdout,method]) / oosvar,
                                    oosr2ci1=NA,oosr2ci2=NA))
  
}


# Holdout bootstrap for R2
holdoutsample <- losses[losses$holdout,setdiff(names(losses),c("holdout"))]
B <- 56
methods <- setdiff(names(fulldata),c("CPI","holdout"))
bstab <- data.frame(matrix(NA,ncol=length(methods),nrow=0))
names(bstab) <- methods
for(b in 1:B) {
  thissample <- sample.int(nrow(holdoutsample),replace=T)
  for(method in methods) {
    bstab[b,method] <- 1 - mean(holdoutsample[thissample,method]) / mean((holdoutsample[thissample,"CPI"] - mean(holdoutsample[thissample,"CPI"]))^2)
  }
}
cis <- lapply(bstab, quantile, probs=c(.025,.975), name=FALSE)

for(methodnr in 1:length(methods)) {
  table1[methodnr,"oosr2ci1"] <- cis[[methods[methodnr]]][1]
  table1[methodnr,"oosr2ci2"] <- cis[[methods[methodnr]]][2]
}

# Add quantile MSEs
bins <- 5
holdoutsample <- losses[losses$holdout,setdiff(names(losses),c("holdout"))]
holdoutsample$decile <- ceiling(ecdf(holdoutsample$CPI)(holdoutsample$CPI)*bins)
msedeciles <- aggregate(holdoutsample, list(holdoutsample$decile), mean)[2:(ncol(holdoutsample)+1)]

reldeciles <- msedeciles
reldeciles[,2:(ncol(msedeciles) - 1)] <- (msedeciles$OLS - msedeciles[,2:(ncol(msedeciles) - 1)]) / msedeciles$OLS

diffdeciles <- msedeciles
diffdeciles[,2:(ncol(msedeciles) - 1)] <- msedeciles[,2:(ncol(msedeciles) - 1)] - msedeciles$OLS

table1[,8+ 1:(3*bins)] <- NA
names(table1) <- c(names(table1)[1:8],c(1:bins,1:bins,1:bins))

for(methodnr in 1:length(setdiff(names(fulldata),c("CPI","holdout")))) {
  table1[methodnr,8+(1:bins)] <- reldeciles[,setdiff(names(fulldata),c("CPI","holdout"))[[methodnr]]]
  table1[methodnr,8+bins+(1:bins)] <- diffdeciles[,setdiff(names(fulldata),c("CPI","holdout"))[[methodnr]]]
  table1[methodnr,8+2*bins+(1:bins)] <- msedeciles[,setdiff(names(fulldata),c("CPI","holdout"))[[methodnr]]]
}

table1[1,8+(1:bins)] <- msedeciles[,"OLS"]
table1[1,8+bins+(1:bins)] <- msedeciles[,"OLS"]

write.csv(table1,file="fittedmodels-table1.csv")
