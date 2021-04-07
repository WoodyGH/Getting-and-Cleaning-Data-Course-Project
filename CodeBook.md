### Code Book ###

Run_analysis.R executes the following sections of code to generate a tidy table with the averages of each variable for each activity and each subject. 

1. Download a file from URL and unzip data file

2. Read data into the following dataframes
  - features
  - activities
  - subject_test
  - x_test
  - y_test
  - subject_train
  - x_train
  - y_train

3. Merge the training and test data sets into one data set
  - Combine columns for test data
  > test_all <- cbind(subject_test, y_test, x_test)
  - Combine columns for train data
  > train_all <- cbind(subject_train, y_train, x_train)
  - Merge test and train data into one dataset
  > data_all <- rbind(test_all, train_all)

4. Extracts only the measurements on the mean and standard deviation for each measurement and store them into a new dataframe (mean_std) 
  > mean_std <- select(data_all, subject, act_id, contains("mean", ignore.case = TRUE), contains("std", ignore.case = TRUE))

5. Use descriptive activity names to name the activities in the data set
  > mean_std$act_id <- activities$activity[mean_std$act_id]

6. Appropriately labels the data set with descriptive variable names
  - Replace "t" at the beginning with "time"
  > names(mean_std) <- gsub("^t", "time", names(mean_std))
  - Replace "f" at the beginning with "frequency" 
  > names(mean_std) <- gsub("^f", "frequency", names(mean_std))
  - Replace "Acc" with "acceleration"
  > names(mean_std) <- gsub("Acc", "acceleration", names(mean_std))

7. Create an independent tidy data set with the average of each variable for each activity and each subject
  - Group data by subject and activity
  > group_by_data <- mean_std %>% group_by(subject, act_id)
  - Calculate the average value of all numeric columns and store it into a new data frame (new_data)
  > new_data <- group_by_data %>% summarize_if(is.numeric, mean, na.rm = TRUE) 
      
8. Write the tidy data to a text file named as "new_tidy.txt"
  > filename <- paste0(filepath, "new_tidy.txt")
  > write.table(new_data,filename, row.name = FALSE)

