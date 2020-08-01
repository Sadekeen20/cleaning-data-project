#read_files
setwd("./UCI HAR Dataset")

#read activity files
ActivityTest <- read.table("./test/y_test.txt", header = F)
ActivityTrain <- read.table("./train/y_train.txt", header = F)

#read feature files
FeaturesTest <- read.table("./test/X_test.txt", header = F)
FeaturesTrain <- read.table("./train/X_train.txt", header = F)

#read subject files
SubjectTest <- read.table("./test/subject_test.txt", header = F)
SubjectTrain <- read.table("./train/subject_train.txt", header = F)

#read activity Labels
ActivityLabels <- read.table("./activity_labels.txt", header = F)

#read feature Names
FeaturesNames <- read.table("./features.txt", header = F)


#merge training & test sets
ActivityData<-rbind(ActivityTest,ActivityTrain)
FeaturesData <- rbind(FeaturesTest, FeaturesTrain)
SubjectData <- rbind(SubjectTest, SubjectTrain)


#rename activity data & label's columns
names(ActivityData)<-"ActivityNum"
names(ActivityLabels)<-c("ActivityNum","Activity")


library(dplyr)

#join activity data and labels
Activity <- left_join(ActivityData, ActivityLabels, by="ActivityNum")

?left_join

#mean and sd of each measurement 
