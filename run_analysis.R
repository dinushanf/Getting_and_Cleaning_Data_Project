library(dplyr)

#Link to the data
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "data_project", method = "curl")

#Unzipping the data
file <- "data_project.zip"
unzip("data_project")

#Creating the tables and assigning columns
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#Step 1 - Merging the training and test sets to create one data set
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)
join <- cbind(subject, x, y)


#Step 2 - Extract only the measurements on the mean and standard deviation for each measurement
selected_data <- select(join, subject, code, contains("mean"), contains("std"))


#Step 3 - Uses descriptive activity names to name the activities in the data set
selected_data$code <- activities[selected_data$code, 2]


#Step 4 - Appropriately labels the data set with descriptive variable names.
names(selected_data)<-gsub("code","activity", names(selected_data))
names(selected_data)<-gsub("Acc", "Accelerometer", names(selected_data))
names(selected_data)<-gsub("Gyro", "Gyroscope", names(selected_data))
names(selected_data)<-gsub("BodyBody", "Body", names(selected_data))
names(selected_data)<-gsub("Mag", "Magnitude", names(selected_data))
names(selected_data)<-gsub("^t", "Time", names(selected_data))
names(selected_data)<-gsub("^f", "Frequency", names(selected_data))
names(selected_data)<-gsub("tBody", "TimeBody", names(selected_data))
names(selected_data)<-gsub("-mean()", "Mean", names(selected_data), ignore.case = TRUE)
names(selected_data)<-gsub("-std()", "STD", names(selected_data), ignore.case = TRUE)
names(selected_data)<-gsub("-freq()", "Frequency", names(selected_data), ignore.case = TRUE)
names(selected_data)<-gsub("angle", "Angle", names(selected_data))
names(selected_data)<-gsub("gravity", "Gravity", names(selected_data))


#Step 5 - From the data set in step 4, create a second, independent tidy data set 
#with the average of each variable for each activity and each subject.

grouped_data <- group_by(selected_data, subject, activity)
averaged_data <- summarize_all(grouped_data, mean)
write.table(averaged_data, "Tidy_data.txt", row.names = FALSE)