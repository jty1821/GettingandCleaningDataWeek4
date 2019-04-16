#Getting and Cleaning Data Week 4 Project Assignment
#Downloading the file from the website
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset.zip"
download.file(fileurl, dest, method = "curl")
#unzip the file
unzip(zipfile = "/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset.zip", 
      exdir = "/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset")
#checking the files
list.files("C:/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4")
#checking the working directory
getwd()

#reading train dataset
sub_t <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/train/subject_train.txt")
xt <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/train/X_train.txt")
yt <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/train/y_train.txt")

#reading test datasets
sub_test <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/test/y_test.txt")

#reading features
feat <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/features.txt")

#reading activity labels
act <- read.table("/Users/10012220/Documents/Coursera/GettingandCleaningDataWeek4/projectdataset/UCI HAR Dataset/activity_labels.txt")
#fix variable names
colnames(xt) = feat[,2]
colnames(yt) = "activityID"
colnames(sub_t) = "subjectID"
colnames(xtest) = feat[,2]
colnames(ytest) = "activityID"
colnames(sub_test) = "subjectID"
colnames(act) = c("activityID", "activityType")    
#merge files
#bind trainsets
X_set <- rbind(xt, xtest) #binding all X sets
y_set <- rbind(yt, ytest) #binding all y sets
sub_set <- rbind(sub_t, sub_test) #binding all subject sets
#extracting mean and std
extract_mean <- X_set[grep("mean", names(X_set))]
extract_std <- X_set[grep("std", names(X_set))]
#combine all sets
AllInOne <- cbind(extract_mean,extract_std, sub_set, y_set)
AllInOne <- merge(AllInOne, act, by = "activityID") 
#
names(AllInOne) <- gsub("^t", "Time", names(AllInOne))
names(AllInOne) <- gsub("^f", "FrequencyDomain", names(AllInOne)) 
names(AllInOne) <- gsub("Acc", "Accelerometer", names(AllInOne))
names(AllInOne) <- gsub("mean()", "Mean", names(AllInOne))
names(AllInOne) <- gsub("Gyro", "Gryoscope", names(AllInOne)) 
names(AllInOne) <- gsub("Mag", "Magnitude", names(AllInOne))
names(AllInOne) <- gsub("BodyBody", "Body", names(AllInOne))
names(AllInOne) <- gsub("Freq()", "Frequency", names(AllInOne))
names(AllInOne) <- gsub("std", "StandardDeviation", names(AllInOne))
names(AllInOne) <- gsub("Frequencyuency", "Frequency", names(AllInOne))

#aggregate values to create new dataset
TidyData <- aggregate(. ~subjectID + activityType, AllInOne, mean)
TidyData <- TidyData[order(TidyData$subjectID,TidyData$activityType),]
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)

