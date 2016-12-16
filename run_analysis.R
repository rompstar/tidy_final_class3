
## STEP 0 - Take care of all dependencies

# check if dyplr is installed and if not, install it
packages <- c("dplyr") 
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

library(dplyr)

## STEP 1 download the data set, look at it and unzip it if files does not exists 

## set the working direcotry for the project  
setwd("~/class3_final/");
project_directory <- getwd();
project_directory

downloadfile <- "UCIHAR_Dataset.zip"

## if file does not exists, download it into the already set Working Directory on my workstation
if (!file.exists(downloadfile)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, downloadfile, method="curl")
}

## grab all the file names inside the ZIP file without unzipping to see what is inside
fileNames <- unzip(downloadfile, list = TRUE)$Name
fileNames

## now that we know the structure of the zip file, unzip all components, checking first if file exits first.
if (!file.exists("UCI HAR Dataset")) { 
  unzip(downloadfile, exdir=project_directory )
}

## STEP 2 Read in all the data and subject/activity files into variables 

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")

Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

## STEP 3 Merge all the Data and adjust the column names 

# merge datasets and add labels
Y_merge <- rbind(Y_train, Y_test)
X_merge <- rbind(X_train, X_test)
subject_data <- rbind(subject_train, subject_test)
# rename column to "subject"
names(subject_data) <- "subject"

## STEP 4 Use Regular Expressions to find the mean and std and then correc the column names using the same logic 
## then process Y data by nested column matching

# use regex and find the mean and standard deviation from the features
# filter the X_merge to only the found using grep in previous step
X_merge2 <- X_merge[,grep("-(mean|std)\\(\\)", features[, 2])]
names(X_merge2) <- features[grep("-(mean|std)\\(\\)", features[, 2]), 2]

# select the first column in Y_Merge and then match it and bring back the activities, assign 
# and correct column name
Y_merge[, 1] <- activities[Y_merge[, 1], 2]
Y_merge2 <- Y_merge
names(Y_merge2) <- "activity"

## STEP 4 // Final Data Merge after filters on mean and std were applied 

# merge eveything together all the data in a single data set
all_merge <- cbind(X_merge2, Y_merge2, subject_data)

## STEP 5 Produce a tidydata set inside R
# use dyplry to apply mean over all the columns and re-order activity and subject
tidydata <- all_merge %>% group_by(subject,activity) %>% summarise_each(funs(mean))

## FINAL STEP 6 Produce the Tidy data file and suppress the row names
write.table(tidydata, "UCI HAR Dataset/tidy_data.txt", row.name=FALSE)



