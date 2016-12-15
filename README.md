# Data Science Specialization, Class #3 / "Getting and Cleaning Data", Final Course Project

This is the final project for the "Getting and Cleaning Data" Coursera course class #3
out of #10 within the Data Science Specialization track.

The accompaning R script, `run_analysis.R`, does the following:

1. The script downloads the dataset if it does not already exists into a subfolder of the working directory.
2. The script then looks at the files names of the downloaded ZIP file without un-zipping the file.
3. The script then un-zipps the files if not already un-zipped.
4. The script reads in the X_train, X_test, Y_train, Y_test, subjects_train and subjects_test data into independent variables.
5. The script then reads in the features and activities information.
6. The script finds the mean and standard deviation using grep, on the X_merge and assignes to X_merge2 and updates the column(names) also using grep, discarding the remain not matched by grep.
7. The script then matches the activies from the Y_merge data set for only the ones from the train and test data and updates the column name.
8. The script then merged using column-bind the X, Y and subject data.
9. The script creates a tidydata set using dyplr group.by and summarize, utilizing chaining.
10. Finally the script creates the secondary independent tidy data set file tidy_data.txt, suppressing the row names.

The End.
