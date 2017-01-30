This readme file contains information about executing the run_analysis.R script.  For information about how the script transforms the data, refer to the CodeBook.md file.

Only one script was written for this project and it is called run_analysis.R

######run_analysis.R:

The analysis script should be installed and run from the working directory, which should be the "UCI HAR Dataset" directory that is created when unzipping the source files.

To execute the file, in the R console, simply type:

  <p>source("run_analysis.R")</p>

All required R libraries that the script relies on will be loaded by the script.

Refer to the CodeBook for details on the source data directory.

The output of the script will be some progress messages printed to the console, a view of the tidy dataset loaded to the source pane and a file written to the working directory called tidy.txt.

The following path/files should be in the working directory:
The following is a list of files that were used from the source data:

* activity_labels.txt
* features.txt
* test/subject_text.txt
* test/X_test.txt
* test/y_test.txt
* train/subject_train.txt
* train/X_train.txt
* train/y_train.txt

###tidy1.txt
This is the tidy dataset.  Load into R for viewing using (substitute file_path with path to the local file):
    
    data <- read.table(file_path, header = TRUE) 
    View(data)
