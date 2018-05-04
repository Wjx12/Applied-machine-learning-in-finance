setwd("D:/5293-finance/HW4")
# Read in data
data <- read.csv("Flight Delays Data.csv", head = TRUE)
data <- data[data$Cancelled == 0,]
carrier <- (data$Carrier == "AA")|(data$Carrier == "B6")|(data$Carrier == "DL")|(data$Carrier == "EV")|(data$Carrier == "MQ")|(data$Carrier == "OO")|(data$Carrier == "UA")|(data$Carrier == "US")|(data$Carrier == "WN")
data <- data[carrier,]
data <- data[,c("Carrier","CRSDepTime", "OriginAirportID", "DestAirportID", "DepDelay")]
data$DepDelay[data$DepDelay < 0] <- 0

delay <- ifelse(data$DepDelay == 0, "No", "Yes")
flight <- data.frame(data, delay)

# Classification tree
library(rpart)
set.seed(2)
n <- nrow(flight)
train <- sample(1:n, n*0.7)
flight.test <- flight[-train,]
delay.test <- delay[-train]
tree.c <- rpart(delay~.-DepDelay, flight[train,], control = rpart.control(minsplit = 5, cp = 0.01, maxdepth = 8))
summary(tree.c)
plot(tree.c, compress = TRUE)
text(tree.c, use.n = TRUE)
c.pred <- predict(tree.c, flight.test, type = "class")
table(c.pred, delay.test)

set.seed(3)
plotcp(tree.c)
printcp(tree.c)

precison1 <- 152526/(96917+152526)
precison1
recall1 <- 152526/(145543+152526)
recall1


# Regression tree

library(MASS)

flight.r <- flight
flight.r$Carrier <- as.numeric(flight.r$Carrier)
tree.r <- rpart(DepDelay~.-delay, flight.r, subset = train, control = rpart.control(minsplit = 10, cp = 0.001, maxdepth = 8))


yhat <- predict(tree.r, newdata = flight.r[-train,])
delay.test <- flight[-train, "DepDelay"]
sse <- sum((yhat-delay.test)^2)
sst <- sum((mean(delay.test)-delay.test)^2)
R2 <- 1-sse/sst
R2

# Classification Random Forest
# Due to memory limit
train1 <- sample(1:n, n*0.05)
library(randomForest)
set.seed(1)
crf.flight <- randomForest(delay~.-DepDelay, data = flight, subset = train1, mtry = 2)
yhat.rf <- predict(crf.flight, newdata = flight[-train,])
delay.test <- delay[-train]
table(yhat.rf, delay.test)

precison2 <- 165125/(104766+165125)
precison2
recall2 <- 165125/(132944+165125)
recall2

# Regression Random Forest
train2 <- sample(1:n, n*0.01)
set.seed(1)
rrf.flight <- randomForest(DepDelay~.-delay, data = flight.r, subset = train2, mtry = 1)
yhat <- predict(rrf.flight, newdata = flight.r[-train,])
delay.test <- flight[-train, "DepDelay"]
sse <- sum((yhat-delay.test)^2)
sst <- sum((mean(delay.test)-delay.test)^2)
R2 <- 1-sse/sst
R2


