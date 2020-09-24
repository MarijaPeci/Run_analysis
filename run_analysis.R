#loading the necessary libraries

library(tidyverse)
library(data.table)
library(easycsv)

#setting url and directory of the data file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destination <- "accelerometer_data.zip"

#downloading the file and storing it into computer memory
download.file(url, destfile = destination)

#read the txt files stored in folder into R
test_folder <- easycsv::fread_zip(file = destination, 
                                  extension = "TXT")


#1 - "Merges the training and the test sets to create one data set."

test_set <- bind_cols(mget(
        grep(
                pattern = "^UCI HAR Datasettest+[^Internal]", 
                x = ls(),
                value=TRUE)
), .id= "test")

##merging train set with labels and subject variables
train_set <- bind_cols(mget(
        grep(
                pattern = "^UCI HAR Datasettrain+[^Internal]", 
                x = ls(),
                value=TRUE)
), .id = "train")

## merge test_set with train_set
binded_df <- bind_rows(test_set, train_set)

#4 - "Appropriately labels the data set with 
#descriptive variable names." 

binded_df <- binded_df %>% 
        rename(activity = V1...1, subject = V1...2, V1 = V1...3) %>%
        select(type=.id, subject, activity, starts_with("V"))

varnames <- unlist(as.list(`UCI HAR Datasetfeatures`[,2]), 
                   recursive = TRUE, 
                   use.names = FALSE)

colnames(binded_df)[4:ncol(binded_df)]<- varnames
colnames(binded_df) <- tolower(names(binded_df))

#2 - "Extracts only the measurements on the mean and standard deviation 
# for each measurement." 

cols <- grep(pattern = "mean|std|activity|subject|type", names(binded_df))
extracted_dt <- binded_df[, ..cols]

#3 - "Uses descriptive activity names to name the activities in the data set"

activities <- as.data.table(mget(
        grep(pattern = "^UCI HAR+(.*)activity", 
             x = ls(), 
             value = TRUE
        )
))

colnames(activities) <- c("V1", "V2")

extracted_dt[, activity := as.character(activity)]

for (i in 1: nrow(extracted_dt)){
        extracted_dt[activity == i, activity := activities[V1 == i, V2]]
}
View(extracted_dt)

#5 - "From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject."

second_dt <- extracted_dt[, lapply(.SD, "mean", -1), 
                          by= c("subject", "activity"), 
                          .SDcols = 4:length(cols)]
second_dt<- arrange(second_dt, subject, .by_group = TRUE)

write.table(second_dt, file = "second_dt.txt", row.names = FALSE)


