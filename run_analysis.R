
## Read and rename relevant columns for all the data
y_test <- read.table("test/y_test.txt", col.names=c("ActivityID"))
y_train <- read.table("train/y_train.txt", col.names=c("ActivityID"))
subject_test <- read.table("test/subject_test.txt", col.names=c("SubjectID"))
subject_train <- read.table("train/subject_train.txt", col.names=c("SubjectID"))
features <- read.table("features.txt", as.is=T, col.names=c("MeasureID", "MeasureName"))
X_test <- read.table("test/X_test.txt",header=F, col.names=features$MeasureName)
X_train <- read.table("train/X_train.txt",header=F, col.names=features$MeasureName)

## Matching column names containg mean and std and then subsetting them from the data
sub_features<- grep(".*mean\\(\\)|.*std\\(\\)", features$MeasureName)
X_test <- X_test[,sub_features]
X_train <- X_train[,sub_features]

## Append the activity and Subject IDs and merge the data
X_test$ActivityID <- y_test$ActivityID
X_test$SubjectID <- subject_test$SubjectID
X_train$ActivityID <- y_train$ActivityID
X_train$SubjectID <- subject_train$SubjectID

data <- rbind(X_test, X_train)


## Label the data set with descriptive activity names and create the first data set
activities <- read.table("activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
activities$ActivityName <- as.factor(activities$ActivityName)

firstDataSet <- merge(data,activities)



## melt the dataset and put it back in a data frame
library(reshape2) # Needed for melt & dcast
id_vars = c("ActivityID", "ActivityName", "SubjectID")
measure_vars = setdiff(colnames(firstDataSet), id_vars)
meltedData <- melt(firstDataSet, id=id_vars, measure.vars=measure_vars)
tidyDataSet <- dcast(meltedData, ActivityName + SubjectID ~ variable, mean)

## Create the second, tidy, data set
write.table(tidyDataSet,"tidyDataSet.txt")