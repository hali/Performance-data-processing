#install.packages("ggplot2")
library(ggplot2)

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
graphing$threadName <- as.numeric(graphing$threadName)
graphing <- droplevels(graphing)
graphing[,"concurrency"] <- 1
graphing[,"end"] <- graphing$timeStamp + graphing$elapsed
graphing <- graphing[order(graphing$timeStamp),]
byLabel <- split(graphing, graphing$label)
n <- nlevels(graphing$label)
for (i in 1:n) {
  rowsn <- nrow(byLabel[[i]])
  if (rowsn > 1)
  {
    for (j in 1:(rowsn-1)) {
      y1 <- byLabel[[i]]$end[j]
      for (k in (j+1):rowsn) {
        x2 <- byLabel[[i]]$timeStamp[k]
          if (x2 <= y1) {
            byLabel[[i]]$concurrency[k] <- byLabel[[i]]$concurrency[k] + 1
          }
	  else {break}
      }
    }
  }
}
remerged <- byLabel[[1]] 
for (i in 2:n) {
  remerged <- rbind(remerged, byLabel[[i]])
}

col.par = function(n) sample(seq(0.5, 1, length.out=50),n);
n <- nlevels(as.factor(remerged$label))
cols = rainbow(n, s=col.par(n), v=col.par(n))[sample(1:n,n)]

if (n < 30) {
  jpeg('concurrencyValues-graph.jpg', width = 2500, height = 600, units = "px")
  col.par = function(n) sample(seq(0.5, 1, length.out=50),n);
  cols = rainbow(n, s=col.par(n), v=col.par(n))[sample(1:n,n)]
  ggplot(remerged, 
         aes(x=timeStamp, y=concurrency, colour=label, group=label, shape=label)) + 
    geom_point(alpha=0.6) + 
    guides(colour=guide_legend(ncol=1)) +
    scale_colour_manual(values=cols) + 
    xlab("Time in seconds since the beginning of the test") +
    ylab("Concurrency") + labs(title = "Concurrency graph") + 
    scale_shape_manual(values=1:nlevels(remerged$label))
  dev.off()
}

# Graph filtered requests only, filtered by label and time
ggplot(remerged[remerged$label %in% c('ClickingPathwayTabAgainToGetInitialFormId2') 
                & remerged$timeStamp > 0 
                & remerged$timeStamp < 4000,], 
       aes(x=timeStamp, y=concurrency, colour=label, group=label, shape=label)) + 
  geom_point(alpha=0.6) + 
  guides(colour=guide_legend(ncol=1)) +
  scale_colour_manual(values=cols) + 
  xlab("Time in seconds since the beginning of the test") +
  ylab("Concurrency") + labs(title = "Concurrency graph") + 
  scale_shape_manual(values=1:nlevels(remerged$label))

# Get aggregated concurrency value per sampler
x <- aggregate(concurrency ~ label, data=remerged, FUN=mean)
y <- aggregate(concurrency ~ label, data=remerged, FUN=max)
x[,"max"] <- y$concurrency
names(x) <- c("label", "Mean concurrency", "Max concurrency")
write.table(x, file='mean-concurrency.csv', quote=FALSE,sep=",", row.names=FALSE, col.names=TRUE)
