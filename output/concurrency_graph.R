# This script processes JMeter output file and produces a concurrency graph for main samplers
# Modify to point to your file and to include/exclude samplers

# Read data from the file
f <- read.csv("aggregate.csv")

# Transform timestamp and elapsed into the same format: seconds, 
# with timestamps in seconds since the beginning of the test 
f$timeStamp <- as.numeric(as.POSIXct(f$timeStamp, format="%Y/%m/%d %H:%M:%S"))
f$timeStamp <- f$timeStamp - f$timeStamp[1]
f$elapsed <- f$elapsed/1000

# Prepare data: remove unnecessary columns and rows with samplers we are not interested in
graphing <- subset(f,select=c("threadName","label","timeStamp","elapsed"))
s <- grep("/[a-z,A-A]+", graphing$label, value=TRUE, invert=TRUE)
s <- grep("User Delay", s, value=TRUE, invert=TRUE)
s <- grep("10000ms - 30000ms", s, value=TRUE, invert=TRUE)
graphing <- subset(graphing, graphing$label %in% s)

# Randomise colors, so that adjustent sections look differently
col.par = function(n) sample(seq(0.5, 1, length.out=50),n);
n <- nlevels(as.factor(s))
cols = rainbow(n, s=col.par(n), v=col.par(n))[sample(1:n,n)]

# Save the graph to a file
jpeg('concurrency-graph.jpg', width = 2500, height = 600, units = "px")
ggplot(graphing) + 
    geom_segment(aes(x=timeStamp, y=as.numeric(threadName), xend=timeStamp+elapsed, yend=as.numeric(threadName), color=label), size=2) +
    scale_y_reverse() + theme(legend.direction ="vertical",legend.position = "right") + guides(colour=guide_legend(ncol=1)) + 
    scale_colour_manual(values=cols) + xlab("Time in seconds since the beginning of the test") +
    ylab("Thread number") + labs(title = "Concurrency graph")
dev.off()