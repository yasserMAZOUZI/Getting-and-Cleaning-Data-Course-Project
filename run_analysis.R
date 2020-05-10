# download and unzip
if(!file.exists("UCI HAR Dataset")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                "courseProject.zip")
  unzip("courseProject.zip")
}


# loading general data
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
features <- read.table("UCI HAR Dataset/features.txt")

# loading test data
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("UCI HAR Dataset/test/y_test.txt")

# loading train data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("UCI HAR Dataset/train/y_train.txt")

# merge test and train data
X <- rbind(XTrain, XTest)
Y <- rbind(YTrain, YTest)
subject <- rbind(subjectTrain, subjectTest)

# selecting only mean and std data
X <- X[,grep("mean|std",features$V2)]

# name activities
actLab <- function(n){
   activityLabels$V2[[which(activityLabels$V1 == n)]]
}

# name variables
Y$V1 <- sapply(Y$V1, actLab)
names(Y) <- "activity"
names(subject) <- "subject"
names(X) <- features$V2[grep("mean|std",features$V2)]

# result
mydata <- cbind(subject, Y, X)

# create tidy data average by activity and subject
library(dplyr)
summydata <- mydata %>%group_by(activity, subject)%>% summarise_each(mean)


write.table(summydata, "Tidy_data_Yasser_MAZOUZI.txt", row.names = FALSE)