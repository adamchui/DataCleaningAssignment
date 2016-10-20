---
title: "Getting And Cleaning Data Assignment"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Purpose


The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Preparation of Data

Download and Unzip the Data
```{r}

ZipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(ZipURL, destfile = "UCI_DataSet.zip")
unzip("UCI_DataSet.zip")

```

### Load Training and Testing Data, Labeling the Columns and Merge as a Set

```{r}

ActivityName <- "Activity"
ActivityIDName <- "ActivityID"
SubjectName <- "Subject"

#Load X, Y, and Subject data from Data Source ( Training Set )
X_Train<- read.csv("./UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
Y_Train<- read.csv("./UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
Train_Subject <- read.csv("./UCI HAR Dataset/train/subject_train.txt", header= FALSE)

#Load X, Y, and Subject data from Data Source ( Testing Set )
X_Test<- read.csv("./UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
Y_Test<- read.csv("./UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
Test_Subject <- read.csv("./UCI HAR Dataset/test/subject_test.txt", header= FALSE)

#Rename the Column of Y (Prepare for further mapping)
names(Y_Train) <- ActivityIDName
names(Y_Test) <- ActivityIDName

#Rename the Column of Subject ( to increase readability )
names(Train_Subject) <- SubjectName
names(Test_Subject) <- SubjectName

#Rename the Column of Features ( to increase readability )
features_name <- (read.csv("./UCI HAR Dataset/features.txt", sep="", header=FALSE))$V2
names(X_Train) <- features_name
names(X_Test) <- features_name

#Load the Activity Label
activity_name <- (read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE))
names(activity_name) <- c(ActivityIDName, ActivityName)


#Combine the Y, Subject and X Data
Train_Set <- cbind(Y_Train,Train_Subject, X_Train)
Test_Set <- cbind(Y_Test,Test_Subject, X_Test)

#Combine the Training Set and Testing Set
Pre_Complete_Set <- rbind(Train_Set, Test_Set)

#Convert the ActivityID to ActivityName
Complete_Set <- merge(x =Pre_Complete_Set, y =  activity_name, by = ActivityIDName)

```

### Extract Mean and Stardard Deviation Columns

```{r}

#Grep the names with mean() and std()
MeanStdNames<-grep(pattern = "mean\\(\\)|std\\(\\)", features_name, value = TRUE)

#All the required column names
AllRequiredNames <- append(append(ActivityName,SubjectName),  MeanStdNames)

#Select the Set with only required columns
Required_Set <- Complete_Set[, AllRequiredNames]

```


### Calculate the average of each variable for each activity and each subject.

```{r}

FinalResult <- aggregate( . ~ Activity + Subject, Required_Set, mean)

#Check Result of first 5 columns
head(FinalResult[, 1:7],5)

#Save Data into an independent Data Set
write.table(FinalResult, file = "FinalResult.txt", row.names = FALSE)

```

