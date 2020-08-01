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

#rename SubjectData columns
names(SubjectData) <- "Subject"

#rename FeaturesData columns using columns from FeaturesNames
names(FeaturesData) <- FeaturesNames$V2

#create one dataset from SubjectData, Activity, FeaturesData
DataSet <- cbind(SubjectData, Activity)
DataSet <- cbind(DataSet, FeaturesData)

###Create New datasets by extracting only the measurements on the mean and standard deviation for each measurement
subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeaturesNames))
DataSet <- subset(DataSet, select=DataNames)

#####Rename the columns of the large dataset using more descriptive activity names
names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))

####Create a second, independent tidy data set with the average of each variable for each activity and each subject
SecondDataSet<-aggregate(. ~Subject + Activity, DataSet, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]

#Save this tidy dataset to local file
write.table(SecondDataSet, file = "tidydata.txt",row.name=FALSE)
