##Download zip file
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

##save to file path
download.file(fileurl, destfile = ".\\Week4Data\\wearables.zip", method = "curl")

##check that file was saved
list.files(".\\Week4Data")


##load dplyr package
library(dplyr)

# Read X test data
x.test <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\test\\X_test.txt", sep="",
                   header=FALSE)

# Read Y test labels
y.test <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\test\\y_test.txt", sep="",
                   header=FALSE)

# Read test subject data
subject.test <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\test\\subject_test.txt",
                         sep="", header=FALSE)

# Merge test data into dataframe
test <- data.frame(subject.test, y.test, x.test)

# Read X training data
x.train <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\train\\X_train.txt", sep="",
                    header=FALSE)

# Read Y training labels
y.train <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\train\\y_train.txt", sep="",
                    header=FALSE)

# Read training subject data
subject.train <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\train\\subject_train.txt",
                          sep="", header=FALSE)

# Merge test training data into dataframe
train <- data.frame(subject.train, y.train, x.train)

# Combine test and training data
running.data <- rbind(train, test)

# Remove redundant files 
remove(subject.test, x.test, y.test, subject.train,
       x.train, y.train, test, train)

# Read measurement labels data
features <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\features.txt", sep="", header=FALSE)

# Create vector for column2
column.names <- as.vector(features[, 2])

# Create column names from measurement labels 
colnames(running.data) <- c("subject_id", "activity_labels", column.names)

# Select mean and standard deviation columns with subject and label
running.data <- select(running.data, contains("subject"), contains("label"),
                   contains("mean"), contains("std"), -contains("freq"),
                   -contains("angle"))

# Read labels data
activity.labels <- read.csv("C:\\Users\\erins\\Documents\\datasciencecoursera\\Week4Data\\UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt", 
                            sep="", header=FALSE)

# Replace the activity codes with labels from the activity labels data
running.data$activity_labels <- as.character(activity.labels[
  match(running.data$activity_labels, activity.labels$V1), 'V2'])


# Group running data by subject and activity, calc mean of measurements
running.data.summary <- running.data %>%
  group_by(subject_id, activity_labels) %>%
  summarize(across(where(is.numeric), mean))

# Write running.data.summary to file
write.table(running.data.summary, file="running_data_summary.txt", row.name=FALSE)

