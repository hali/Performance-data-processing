# This script processes JMeter output csv files and aggregates them
# into a nice format that can be futher used to build graphs.
# It is assumed that all csv files in the current directory
# are JMeter output files as produced by e.g. Aggregate Report.

# Get the name of all csv files in current directory
filenames <- list.files(pattern="*.csv")

# Go through all of the files and process them
for (filename in filenames) {
    # Read the data from another file
    test1 <- read.csv(filename, header=FALSE)
    
    # Calculate Median and 90th percentile
    x <- aggregate(V2 ~ V3, data=test1, FUN=median)
    names(x) <- c("Sample", "Median")
    x90 <- aggregate(V2 ~ V3, data=test1, FUN=quantile, 0.9)
    x[,"90th Line"] <- x90$V2

    # Calculate Throughput
    xcount <- aggregate(V2 ~ V3, data=test1, FUN=length)
    # Getting the time difference between first and last occurances of the sample
    xfirst <- aggregate(V1 ~ V3, data=test1, FUN=min)
    xlast <- aggregate(V1 ~ V3, data=test1, FUN=max)
    # Get Throughput as number of samples per millisecond
    xcount$V2 <- xcount$V2 / (xlast$V1 - xfirst$V1)
    # Move to Throughput per minute and add it as a column to main dataset
    x[,"Throughput per minute"] <- xcount$V2 * 60000

    # Subsetting rows to only include those properly named which are not delays
    samples <- grep("/[a-z,A-A]+", x$Sample, value=TRUE, invert=TRUE)
    samples <- grep("User Delay", samples, value=TRUE, invert=TRUE)
    x <- x[x$Sample %in% samples,]
    
    # Save results in a new file
    write.csv(x, file=paste("processed-", filename, sep=""))
}

