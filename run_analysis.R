#0 Pre-processing of data 

# Get data from the internet
dataDesc = "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
dataURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataURL, destfile = "data.zip")
unzip("data.zip")

# store files into tables
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train = read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

#1 Merge the training and the test sets to create one data set
x = rbind(x_train, x_test)
y = rbind(y_train, y_test)
subject = rbind(subject_train, subject_test)
dataset = cbind(x,y,subject)

#2 Extract only measurements on mean and standard deviation
library(dplyr)

extracted = dataset %>%
            select(subject, code, contains("mean"), contains("std"))

#3 Use descriptive activity names to name the activities in the data set
extracted$code = activities[extracted$code, 2]

#4 Appropriately label the data set with descriptive variable names.
names(extracted)[2] = "activity"
names(extracted)<-gsub("Acc", "Accelerometer", names(extracted))
names(extracted)<-gsub("Gyro", "Gyroscope", names(extracted))
names(extracted)<-gsub("BodyBody", "Body", names(extracted))
names(extracted)<-gsub("Mag", "Magnitude", names(extracted))
names(extracted)<-gsub("^t", "Time", names(extracted))
names(extracted)<-gsub("^f", "Frequency", names(extracted))
names(extracted)<-gsub("tBody", "TimeBody", names(extracted))
names(extracted)<-gsub("-mean()", "Mean", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-std()", "STD", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("-freq()", "Frequency", names(extracted), ignore.case = TRUE)
names(extracted)<-gsub("angle", "Angle", names(extracted))
names(extracted)<-gsub("gravity", "Gravity", names(extracted))

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

ans = extracted %>%
  group_by(subject,activity) %>%
  summarise_all(funs(mean))

write.table(ans, "FinalData.txt",row.name=FALSE)






