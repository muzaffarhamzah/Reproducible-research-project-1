#----- Load and preprocess data--------------------------------------------------------
data<-read.csv("./data/activity.csv")
data$date<-as.Date(data$date)

#----- Create histogram and find mean total number of steps taken per day--------------
sum_steps<-aggregate(data$steps,by=list(data$date),FUN=sum,na.rm=TRUE) 

hist(sum_steps$x, 
     breaks=seq(from=0, to=25000, by=2500),
     col="yellow", 
     xlab="Total number of steps", 
     ylim=c(0, 20), 
     main="Histogram of the total number of steps taken each day\n(NA removed)")

mean(sum_steps$x)

median(sum_steps$x)

#----- Create plot based on average daily activity pattern------------------------------
avg_steps<-aggregate(data$steps,by=list(data$interval),FUN=mean,na.rm=TRUE)

colnames(avg_steps)<-c("interval","steps")

library(ggplot2)

ggplot(aes(x=interval,y=steps),data=avg_steps)+geom_line()

avg_steps[avg_steps$steps==max(avg_steps$steps),1]

sum(is.na(data$steps))

#----- Imputing missing values----------------------------------------------------------
data$steps[is.na(data$steps)]<-mean(data$steps,na.rm=TRUE)

head(data)

## Using filled dataset, create histogram of total number of steps taken per day
sum_steps<-aggregate(data$steps,by=list(data$date),FUN=sum,na.rm=TRUE) 

hist(sum_steps$x, 
     breaks=seq(from=0, to=25000, by=2500),
     col="yellow", 
     xlab="Total number of steps", 
     ylim=c(0, 30), 
     main="Total number of steps taken each day\n(NA replaced by mean)")

## Calculate the mean and median total number of steps
mean(sum_steps$x)

median(sum_steps$x)

#----- Finding the difference in activity patterns between weekdays and weekend---------
## Convert date into weekdays

data$days=tolower(weekdays(data$date))

## Now categorised days into weekend and weekdays

data$day_type<-ifelse(data$days=="saturday"|data$days=="sunday","weekend","weekday")

## Take mean steps taken on weekend or weekday in the intervals

avg_steps<-aggregate(data$steps,by=list(data$interval,data$day_type),FUN=mean,na.rm=TRUE)

colnames(avg_steps)<-c("interval","day_type","steps")

## Create panel plot between average steps and interval seperated by day type

ggplot(aes(x=interval,y=steps),data=avg_steps)+geom_line()+facet_wrap(~avg_steps$day_type)