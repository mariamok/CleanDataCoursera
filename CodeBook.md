#Getting and Cleaning Data - Codebook for Course Project
####Author:  Maria Mokrzycki

###Purpose:
This codebook explains how this author obtained the project data and then derived the data for the final output.

###Project Objective:
The goal of the project was to create a tidy dataset from a variety of source data files.

###Data Source files:
Data for the project was obtained from the following website:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

For a full description of the data, please refer to:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data was downloaded and unzipped.  No changes were made to the resulting file structure and no files were moved for processing. 

###Analysis Script: run_analysis.R

For more information about run_analysis.R, please refer to readme.md

###Source file installation:
Once the zip file was downloaded, it was unzipped.  No changes were made to the resulting file structure and no file were moved before processing.

###Source tables:
The following describes the structure of the data frames created when the source files were loaded into R:

activity: from activity_labels.txt

    data.frame:	6 obs. of  2 variables:
    $ activityid: int  1 2 3 4 5 6
    $ activity  : chr  "walking" "walking_upstairs" "walking_downstairs" "sitting", "standing", "laying"

features: from features.txt (for more detail refer to documentation listed in Data Source Files)
    
    'data.frame':	561 obs. of  2 variables:
    $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
    $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..

subject_test:  from subject_test.txt

    'data.frame':	2947 obs. of  1 variable:
    $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
 
xtest.txt:  from test/X_test.txt

    'data.frame':	2947 obs. of  563 variables:
    $ V1  : int  2 2 2 2 2 2 2 2 2 2 ...
    $ V1  : int  5 5 5 5 5 5 5 5 5 5 ...
    $ V1.1: num  0.257 0.286 0.275 0.27 0.275 ...
    $ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
    ...

ytest:  from test/y_test.txt

    'data.frame':	2947 obs. of  1 variable:
    $ V1: int  5 5 5 5 5 5 5 5 5 5 ...
 
subject_train:  from train/subject_train.txt

    'data.frame':	7352 obs. of  1 variable:
    $ V1: int  1 1 1 1 1 1 1 1 1 1 ...

xtrain:  from train/X_train.txt

    'data.frame':	7352 obs. of  563 variables:
    $ V1  : int  1 1 1 1 1 1 1 1 1 1 ...
    $ V1  : int  5 5 5 5 5 5 5 5 5 5 ...
    $ V1.1: num  0.289 0.278 0.28 0.279 0.277 ...
    $ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
    $ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
    ...
 
ytrain:  from train/y_train.txt

    'data.frame':	7352 obs. of  1 variable:
    $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

For a detailed explaination of these files, refer to the section Data Source Files.

###The tidy Dataset Recipe:

Once the source files were loaded, the following steps were performed to create the tidy dataset:

1.  Perform a column merge (cbind) on the training tables subject_train, ytrain and xtrain
    <p>xtrain <- cbind(data.frame(ytrain), data.frame(xtrain))
    xtrain <- cbind(data.frame(subject_train), data.frame(xtrain))</p>

2.  Perform a column merge (cbind) on the test tables subject_test, ytest, xtest
    xtest <- cbind(data.frame(ytest), data.frame(xtest))
    xtest <- cbind(data.frame(subject_test), data.frame(xtest))
    
3.  Append the test table to the training table to create one large table (result is 10299 rows x 563 cols)
    <p>har_all <- rbind(data.frame(xtest), data.frame(xtrain))</p>

4.  Add feature (column) labels
    <p>names(har_all) <- c("subjectid", "activityid", as.vector(features$V2))</p>

5.  Extract only mean and standard deviation measurements
    <p>stdmean <- har_all[,grep("subjectid|activityid|std|mean", names(har_all), ignore.case = TRUE)]</p>

6.  add activity labels
    <p>stdmean <- join(stdmean, activity, by="activityid", type="left")
    stdmean <- stdmean[ ,c(1, ncol(stdmean),3:(ncol(stdmean)-1))]</p>

7.  Lable columns appropriately (clean up the names - more could possibly be done here, but I didn't find it necessary)
    tolower(names(stdmean)) 

8.  Transform the data from a wide dataset (563 cols) into a long, skinny dataset (4 cols).  The resulting data frame will have 1 row for every measurement taken (subject, activity, feature, measurement)
    <p>stdmean <- melt(stdmean, id=c("subjectid", "activity"), measure.vars=as.vector(names(stdmean)[3:ncol(stdmean)]))</p>

9.  Calculate the averages for each subject/activity/variable - every row is a unique combination of subject/activity/feature 
    <p>tidy1 <- ddply(stdmean, .(subjectid, activity, variable), summarize, mean=mean(value))</p>
    
10.  Write the tidy data to a file in the working directory
    <p>write.table(tidy1, "tidy1.txt")</p>


The resulting structure of the tidy data is:

    'data.frame':	15480 obs. of  4 variables:
    $ subjectid: int  1 1 1 1 1 1 1 1 1 1 ...
    $ activity : chr  "laying" "laying" "laying" "laying" ...
    $ variable : Factor w/ 86 levels "tBodyAcc-mean()-X",..: 1 2 3 4 5 6 7 8 9 10 ...
    $ mean     : num  0.2216 -0.0405 -0.1132 -0.9281 -0.8368 ...
    
Why is this structure tidy?
1. variable names are lower case, descriptive, unique
2. factor variables are descriptive and readable
3. (the mean of) each observation forms a row
4. each observation (row) is unique



