#Objective of this script is the following:
#1. Merge the training and test sets to create one data set
#2. Extract only the measurements on the mean and standard deviation for each measurement
#3. Use descriptive activity names to name the activities in the dataset
#4. Appropriately labels the data set with descriptive variable names
#5. From data set in step 4, create a second, independant tidy data set with the average
#   of each variable for each activity and each subject

#load required libraries
print("Loading required libraries...")
library(plyr)
library(dplyr)
library(reshape2)     #for melt

print("Loading data source files...")
#start by loading the data sets
#features list
features <- read.table(file="features.txt")

#activity labels
activity <- read.table(file="activity_labels.txt")
names(activity) <- c("activityid", "activity")
activity[,2]<- tolower(activity[,2])    #fix labels...

#load training tables
xtrain <- read.table(file="train/X_train.txt")
ytrain <- read.table(file="train/y_train.txt")
subject_train <- read.table(file="train/subject_train.txt")

#load testing tables
xtest <- read.table(file="test/X_test.txt")
ytest <- read.table(file="test/y_test.txt")
subject_test <- read.table(file="test/subject_test.txt")

print("Merging source files...")

#merge the training tables
xtrain <- cbind(data.frame(ytrain), data.frame(xtrain))
xtrain <- cbind(data.frame(subject_train), data.frame(xtrain))

#merge the test tables()
xtest <- cbind(data.frame(ytest), data.frame(xtest))
xtest <- cbind(data.frame(subject_test), data.frame(xtest))

print("Appending source files...")

#append test data table to training data table to create one large table of test
#and training data together
har_all <- rbind(data.frame(xtest), data.frame(xtrain))

print("Renaming variables...")

#add features(column) labels
names(har_all) <- c("subjectid", "activityid", as.vector(features$V2))

print("Extracting mean and standard deviation variables...")

#extract only mean and std for each measurement
stdmean <- har_all[,grep("subjectid|activityid|std|mean", names(har_all), ignore.case = TRUE)]

#add activity labels
print("Add activity labels...")

stdmean <- join(stdmean, activity, by="activityid", type="left")
#remove the activityid column and make activty the 2nd column - just because I like it this way!!
stdmean <- stdmean[ ,c(1, ncol(stdmean),3:(ncol(stdmean)-1))]

print("Fix column labels...")

#appropriate col names
tolower(names(stdmean)) 

print("Make tidy data frame...")

##TIDY DATASET

#melt the dataset - unique records id'd by subjectid, activity
#calculate mean on the resulting columns
stdmean <- melt(stdmean, id=c("subjectid", "activity"), measure.vars=as.vector(names(stdmean)[3:ncol(stdmean)]))

#calculate the averages for variables across subject and activity
tidy1 <- ddply(stdmean, .(subjectid, activity, variable), summarize, mean=mean(value))
tidy1<- arrange(tidy1, subjectid, activity, variable)

print("Writing tidy.txt to workinging directory")
write.table(tidy1, "tidy1.txt", row.name=FALSE)

View(tidy1)
print("Complete...")

