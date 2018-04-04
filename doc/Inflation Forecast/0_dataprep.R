# Read in data and choose variables
data_2017 <- read.csv("CPI-U-201712.csv")
cpi_2017 <- data_2017[c(7,8,130,371),5:16]
lag1_2017 <- data_2017[7,4:15]

data_2016 <- read.csv("CPI-U_201612.csv")
cpi_2016 <- data_2016[c(7,8,130,371),5:16]
lag1_2016 <- data_2016[7,4:15]

data_2015 <- read.csv("CPI-U_201512.csv")
cpi_2015 <- data_2015[c(7,8,130,371),5:16]
lag1_2015 <- data_2015[7,4:15]

data_2014 <- read.csv("CPI-U_201412.csv")
cpi_2014 <- data_2014[c(7,8,130,371),5:16]
lag1_2014 <- data_2014[7,4:15]

data_2013 <- read.csv("CPI-U_201312.csv")
cpi_2013 <- data_2013[c(7,8,130,371),5:16]
lag1_2013 <- data_2013[7,4:15]

data_2012 <- read.csv("CPI-U_201212.csv")
cpi_2012 <- data_2012[c(7,8,130,371),5:16]
lag1_2012 <- data_2012[7,4:15]

total_data <- cbind(cpi_2012,cpi_2013,cpi_2014,cpi_2015,cpi_2016,cpi_2017)
n <- ncol(total_data)
row.names(total_data) <- c("CPI", "Food", "Energy", "Services")
colnames(total_data) <- 0:(n-1)

lag1 <- cbind(lag1_2012,lag1_2013,lag1_2014,lag1_2015,lag1_2016,lag1_2017)
row.names(lag1) <- "Lag1"
colnames(lag1) <- 1:n

lag2 <- lag1[,1:n-1]
row.names(lag2) <- "Lag2"
colnames(lag1) <- 0:(n-1)
data <- data.frame(t(rbind(total_data[,2:n],lag1[,2:n],lag2)))
data$CPI <- as.numeric(as.character(data$CPI))
data$Food <- as.numeric(as.character(data$Food))
data$Energy <- as.numeric(as.character(data$Energy))
data$Services <- as.numeric(as.character(data$Services))
data$Lag1 <- as.numeric(as.character(data$Lag1))
data$Lag2 <- as.numeric(as.character(data$Lag2))

# Divide data into training set and holdout set
data$holdout <- as.logical(1:nrow(data) %in% sample(nrow(data), nrow(data) - 56))
data <- droplevels(data)

vars <- colnames(data)[2:6]

getformula <- function(varlist,LHS="CPI") {
  return(paste(LHS, paste(varlist,collapse=" + "), sep = " ~ "))
}

saveRDS(list(df=data,vars=vars,getformula=getformula),
        file="cpidata.rdata")




