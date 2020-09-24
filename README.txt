The scrip Run_analysis.R takes accellerometer data from "Human Activity Recognition Using Smartphones Dataset, Version 1.0" and accomplishes these tasks:

1. Opens connection to the data file and uploads the files stored within into the R project 
environment

2. Merges the training and the test sets to create one data set.
  The resulting data set is called "binded_df"

3. Appropriately labels the data set with descriptive variable names. 
  Either new names, or taken from the original dataset.

4. Extracts only the measurements on the mean and standard deviation for each measurement.
  The result is stored into "extracted_dt" data table and then viewed.

5.  From the data set in step 4, creates a second, independent tidy data set 
with the average of each variable for each activity and each subject.
  Result is stored into second_dt data table. 
  
  Most variables are taken from the original data set, where their descriptions can be found. 
  Additional variables: "type", "subject", "activity" are new and described in the "run_analysis code" .rmd file.
