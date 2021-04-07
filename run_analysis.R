#load packages
library(dplyr)

#download and unzip data file
filepath <- "~/Documents/R/CleaningData/Getting-and-Cleaning-Data-Course-Project/"
input_file <- paste(filepath, "raw_dataset.zip")
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, input_file, method = "curl")
unzip(input_file)

#read raw data
features <- read.table(paste0(filepath, "UCI HAR Dataset/features.txt"), col.names = c("feat_id", "feature"))
activities <- read.table(paste0(filepath, "UCI HAR Dataset/activity_labels.txt"), col.names = c("act_id", "activity"))
subject_test <- read.table(paste0(filepath,"UCI HAR Dataset/test/subject_test.txt"), col.names = c("subject"))
x_test <- read.table(paste0(filepath, "UCI HAR Dataset/test/X_test.txt"), col.names = features$feature)
y_test <- read.table(paste0(filepath, "UCI HAR Dataset/test/y_test.txt"), col.names = "act_id")
subject_train <- read.table(paste0(filepath,"UCI HAR Dataset/train/subject_train.txt"), col.names = c("subject"))
x_train <- read.table(paste0(filepath, "UCI HAR Dataset/train/X_train.txt"), col.names = features$feature)
y_train <- read.table(paste0(filepath, "UCI HAR Dataset/train/y_train.txt"), col.names = "act_id")

#merge the training and test data sets into one data set
test_all <- cbind(subject_test, y_test, x_test)
train_all <- cbind(subject_train, y_train, x_train)
data_all <- rbind(test_all, train_all)

#extracts only the measurements on the mean and standard deviation for each measurement. 
mean_std <- select(data_all, subject, act_id, contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE))

#uses descriptive activity names to name the activities in the data set
mean_std$act_id <- activities$activity[mean_std$act_id]

#appropriately labels the data set with descriptive variable names. 
names(mean_std) <- gsub("^t", "time", names(mean_std))
names(mean_std) <- gsub("^f", "frequency", names(mean_std))
names(mean_std) <- gsub("Acc", "acceleration", names(mean_std))

#creates an independent tidy data set with the average of each variable for each activity and each subject.
group_by_data <- mean_std %>% group_by(subject, act_id)
new_data <- group_by_data %>% summarize_if(is.numeric, mean, na.rm = TRUE) 
      
#write the tidy data to a text file.
filename <- paste0(filepath, "new_tidy.txt")
write.table(new_data,filename, row.name = FALSE)

