# load train and test features, labels and subjects
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# read activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors=F)

# STEP 1
# stack rows to create one joint dataset frmo train and test
X <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subjects <- rbind(subject_train, subject_test)

# install.packages('dplyr')
library(dplyr)
# STEP 2
# extract only columns which store information about mean or standard deviation
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors=F)
featuresWithMeanOrStd <- dplyr::filter(features, grepl("-mean", features$V2, ignore.case = T) | grepl("-std", features$V2, ignore.case = T))
# fetch the column indices which contain a mean or a standard deviation measurement
idcs <- featuresWithMeanOrStd$V1
# Xm stores onlthe columns of the joint feature vectors which have a measurement of a mean in them
Xm <- X[,idcs]
# ym are the labels of the corresponding entries in the Xm matrix
ym <- y

# STEP 3
# rename column for activity labels
ym <- data.frame(activity = ym$V1)
# map activity names
for (i in 1:dim(activities)[1]) {
  ym[ym$activity == activities[i,1],] <- activities[i,2]
}
subjects <- data.frame(subjectId = subjects$V1)

# STEP 4
# rename variables in feature vectors
names(Xm) <- features[idcs,2]
# create a joint dataset from subject id, mapped activities and the feature vectors
dataset <- data.frame(subjects, y = ym, Xm)

# STEP 5
dplyr_dataset <- tbl_df(dataset)
# aggregate all columns over the grouped by columns subjectId and activity
meanDatasetBySubjectAndActivity <- aggregate(dplyr_dataset[,3:81], list(dplyr_dataset$subjectId, dplyr_dataset$activity), mean)
# renamed columns into aggregated dataframe
names(meanDatasetBySubjectAndActivity)[names(meanDatasetBySubjectAndActivity) == 'Group.1'] <- "subjectId"
names(meanDatasetBySubjectAndActivity)[names(meanDatasetBySubjectAndActivity) == 'Group.2'] <- "activity"

# rename columns, replace multiple dots with -
names(meanDatasetBySubjectAndActivity) <- sub("\\.\\.\\.", "-", names(meanDatasetBySubjectAndActivity))
names(meanDatasetBySubjectAndActivity) <- sub("\\.\\.", "", names(meanDatasetBySubjectAndActivity))
names(meanDatasetBySubjectAndActivity) <- sub("\\.", "-", names(meanDatasetBySubjectAndActivity))

# save grouped and processed dataset
write.table(meanDatasetBySubjectAndActivity, file = "datasetMeanBySubjectAndActivity.txt", row.names = F)
