library(PROcess)
library(ggplot2)
  data <- read.csv(file='data.csv', header=T)
  png("heartbeat.png")
  qplot(data=data, frame, intensity, geom="line")
  dev.off()
  peaks <- peaks(data$intensity,span=10)
  peak_times <- which(peaks==T, arr.in=T)
intervals <- c()
  i <- 1
  while (i < length(peak_times)) {
    intervals <- append(intervals, peak_times[i+1] - peak_times[i])
      i <- i + 1
  }
average <- round(mean(intervals))
  print(paste("Average interval between peak intensities is", average))
heartbeat_rate <- round(60 * (30/average))
  print(paste("Heartbeat rate is",heartbeat_rate))
