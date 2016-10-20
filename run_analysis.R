ZipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(ZipURL, destfile = "UCI_DataSet.zip")
unzip("UCI_DataSet.zip")

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


#Grep the names with mean() and std()
MeanStdNames<-grep(pattern = "mean\\(\\)|std\\(\\)", features_name, value = TRUE)

#All the required column names
AllRequiredNames <- append(append(ActivityName,SubjectName),  MeanStdNames)

#Select the Set with only required columns
Required_Set <- Complete_Set[, AllRequiredNames]

FinalResult <- aggregate( . ~ Activity + Subject, Required_Set, mean)

#Check Result of first 5 columns
head(FinalResult[, 1:7],5)

#Save Data into an independent Data Set
write.table(FinalResult, file = "FinalResult.csv")
