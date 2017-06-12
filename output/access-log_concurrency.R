#install.packages("readr")
library(readr)
overlap <- function(x1,y1,x2,y2){
  overlap <- 0
  if (x2 >= x1) {
    if (x2 <= y1) {
      overlap <- 2
    }
  }
  else if (y2 >= x1) {
    overlap <- 1
  }
  overlap
}

f <- read_log( "access.log", skip=0, col_names=FALSE )
df <- f[,c("X4","X2","X7")]
df$X2 <- as.numeric(as.POSIXct(df$X2, format="%d/%b/%Y:%H:%M:%S %z"))
df$X2 <- (df$X2 - df$X2[1])*1000
df[,"end"] <- df$X2 + df$X7
names(df) <- c("label","timeStamp","elapsed","end")
df[,"concurrency"] <- 1
df$label <- sapply(strsplit(df$label," "),"[",2)
df$label <- sapply(strsplit(df$label,"?token",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"documentCacheId",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"csrfToken",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"conToken",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"con_token",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"documentRepository",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"id=",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"RequestID",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"REF_NO",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"accession_number",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"documentId",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"attribute.Facility",fixed=TRUE),"[",1)
df$label <- sapply(strsplit(df$label,"encryptedRequest",fixed=TRUE),"[",1)

byLabel <- split(df, df$label)
n <- nlevels(as.factor(df$label))
for (i in 1:n) {
  rowsn <- nrow(byLabel[[i]])
  if (rowsn > 1)
  {
    for (j in 1:(rowsn-1)) {
      x1 <- byLabel[[i]]$timeStamp[j]
      y1 <- byLabel[[i]]$end[j]
      for (k in (j+1):rowsn) {
        x2 <- byLabel[[i]]$timeStamp[k]
        y2 <- byLabel[[i]]$end[k]
        overlapCheck <- overlap(x1, y1, x2, y2)
        if (overlapCheck == 1) {
          byLabel[[i]]$concurrency[j] <- byLabel[[i]]$concurrency[j] + 1 }
        else if (overlapCheck == 2) {
          byLabel[[i]]$concurrency[k] <- byLabel[[i]]$concurrency[k] + 1
        }
      }
    }
  }
}
remerged <- byLabel[[1]] 
for (i in 2:n) {
  remerged <- rbind(remerged, byLabel[[i]])
}
n <- nlevels(as.factor(remerged$label))

if (n < 30) {
  jpeg('access-concurrencyValues-graph.jpg', width = 2500, height = 600, units = "px")
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
x <- aggregate(concurrency ~ label, data=remerged, FUN=mean)
write.table(x, file='mean-access.log-concurrency.csv', quote=FALSE,sep=",", row.names=FALSE, col.names=TRUE)
