# Read in data
data <- read.csv("Assignment 2-3 Credit Model Data.csv", head = TRUE)
data <- data[,c(4:93,96)]
colnames(data) <- c(1:90, "default")
for (i in 1:(ncol(data)-1)){
  data[,i] <- as.numeric(as.character(data[,i]))
}

# Set default to 1, no default to 0
nodefault <- data[,91] == "-"
data[,91] <- as.numeric(as.character(data[,91]))
data[nodefault,91] <- 0
data[!nodefault,91] <- 1

# Assign missing values
data0 <- data
removed.col <- 0
for (i in 1:(ncol(data0)-1)){
  if (mean(is.na(data0[,i])) == 1){
    data <- data[,c(1:(i-1-removed.col),(i-removed.col+1):ncol(data))]
    removed.col <- removed.col + 1
  }
}

removed.row <- 0
for (j in 1:(nrow(data0)-1)){
  if (mean(is.na(data0[j,-ncol(data0)])) == 1){
    data <- data[c(1:(j-1-removed.row),(j-removed.row+1):nrow(data)),]
    removed.row <- removed.row + 1
  }
}

if (mean(is.na(data[nrow(data),-ncol(data)])) == 1){
  data <- data[-nrow(data),]
}

data1 <- data[,c(1:50,53:73)]

avg.miss <- function(v){
  v <- as.numeric(v)
  v2 <- v
  for (i in 1:7){
    v1 <- v[(10*(i-1)+1):(10*i)]
    if (mean(is.na(v1)) == 1){
      v2[(10*(i-1)+1):(10*i)] <- NA
    } else{
      index <- min(which(!is.na(v1) == TRUE))
      if (index > 1){
        for (k in 1:(index-1)){
          if (is.na(v1[index-k]) == TRUE){
            v1[index-k] <- v1[index-k+1]
          }
        }
      }
      if (index < length(v1)){
        for (k in 1:(length(v1)-index)){
          if (is.na(v1[index+k]) == TRUE){
            v1[index+k] <- v1[index+k-1]
          }
        }
      }
      v2[(10*(i-1)+1):(10*i)] <- v1
    }
  }
#  for (i in 51:52){
#   v1 <- v[i] 
#   v1[is.na(v1)] <- NA
#   v2[i] <- v1
#  }
  return(v2)
}

for (j in 1:nrow(data1)){
  data1[j,] <- avg.miss(data1[j,])
}

data2 <- data1

removed.company <- 0
for (j in 1:nrow(data2)){
  if (sum(is.na(data2[j,])) > 0){
    data1 <- data1[-(j-removed.company),]
    removed.company <- removed.company + 1
  }
}

colnames(data1) <- make.names(colnames(data1))

data.ols <- data1[,c("X10","X20","X30","X40","X50","X80","X90","default")]

# Divide data into training set and holdout set
data.ols$holdout <- as.logical(1:nrow(data.ols) %in% sample(nrow(data.ols), nrow(data.ols)*0.2))
data.ols <- droplevels(data.ols)

vars.ols <- colnames(data.ols)[1:7]

getformula <- function(varlist,LHS="default") {
  return(paste(LHS, paste(varlist,collapse=" + "), sep = " ~ "))
}

saveRDS(list(df=data.ols,vars=vars.ols,getformula=getformula),
        file="defaultdataOLS.rdata")

data1$holdout <- as.logical(1:nrow(data1) %in% sample(nrow(data1), nrow(data1)*0.2))
data1 <- droplevels(data1)

vars.tree <- colnames(data1)[1:70]

saveRDS(list(df=data1,vars=vars.tree,getformula=getformula),
        file="defaultdataTREE.rdata")




