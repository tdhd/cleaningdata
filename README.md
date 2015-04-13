# UCI HAR Dataset sample script

This repo includes a script **run_analysis.R** which assumes that the **UCI HAR Dataset** folder is in the same directory as the script. The script performs five steps in total:

1. merge training and test data
2. only keep variables that measure the mean and standard deviation
3. renames the activities to text
4. renames the features to their respective names
5. creates a new dataset from the data in step 4 by aggregating the mean for each subject and activity

The script will produce a file **datasetMeanBySubjectAndActivity.txt** which contains the aggregated dataset from step 5. It might be required to install the [dplyr] library.

### Codebook of the generated dataset

Please see the file Codebook.md.

[dplyr]:http://cran.r-project.org/web/packages/dplyr/index.html

