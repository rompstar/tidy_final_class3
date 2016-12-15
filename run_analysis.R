

getwd();

## create a folder within the working directory dedicated to the project and download the file there 
dir.create("class3_final")
download_file <- "class3_final/UCIHAR_Dataset.zip"

## if file does not exists, download it into the already set Working Directory on my workstation
if (!file.exists(download_file)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, download_file, method="curl")
}

## grab all the file names inside the ZIP file without unzipping to see what is inside
fileNames <- unzip(download_file, list = TRUE)$Name
fileNames

## now that we know the structure of the zip file, unzip all components, checking first if file exits first.
if (!file.exists("UCI HAR Dataset")) { 
  unzip(download_file, exdir="class3_final/")
}

# using the plyr library
#library(plyr)

X_train <- read.table("class3_final/UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("class3_final/UCI HAR Dataset/test/X_test.txt")

Y_train <- read.table("class3_final/UCI HAR Dataset/train/Y_train.txt")
Y_test <- read.table("class3_final/UCI HAR Dataset/test/Y_test.txt")

subject_train <- read.table("class3_final/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("class3_final/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("class3_final/UCI HAR Dataset/features.txt")
activities <- read.table("class3_final/UCI HAR Dataset/activity_labels.txt")

# merge datasets and add labels
Y_merge <- rbind(Y_train, Y_test)
X_merge <- rbind(X_train, X_test)
subject_data <- rbind(subject_train, subject_test)
# rename column to "subject"
names(subject_data) <- "subject"

# use regex and find the mean and standard deviation from the features
# filter the X_merge to only the found using grep in previous step
X_merge2 <- X_merge[,grep("-(mean|std)\\(\\)", features[, 2])]
names(X_merge2) <- features[grep("-(mean|std)\\(\\)", features[, 2]), 2]

# select the first column in Y_Merge and then match it and bring back the activities, assign 
# and correct column name
Y_merge[, 1] <- activities[Y_merge[, 1], 2]
Y_merge2 <- Y_merge
names(Y_merge2) <- "activity"

# merge eveything together all the data in a single data set
all_merge <- cbind(X_merge2, Y_merge2, subject_data)

# use dyplry to apply mean over all the columns and re-order activity and subject
tidydata <- reordercolumns %>% group_by(subject,activity) %>% summarise_each(funs(mean))

# Create the Tidy data file and suppress the row names
write.table(tidy_data, "class3_final/UCI HAR Dataset/tidy_data.txt", row.name=FALSE)



