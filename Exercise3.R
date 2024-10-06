policy <- list('basic','netflix')
buffer <- list('10', '50', '100')
rate <- list('constant', 'valley', 'hill')
length <- list('180', '300')




data <- scan("D:/School/CSE 534/LA/LA/LA_Lab2.tsv", "")
print(data)
data <- data[-(1:3)]
print(data)
data <- as.numeric(data) + 1
print(data)
data <- matrix(data, ncol = 4, byrow = TRUE)
print(data)

file_path <- "D:/School/CSE 534/Lab2Ex2Data/"
print("Bit rate")
for(x in 1:nrow(data))
{
  file <- read.csv(paste0(file_path, policy[data[x, 1]], "_", buffer[data[x, 2]], "_", rate[data[x, 3]], "_", length[data[x,4]], ".csv"))
  #print(paste0(file_path, policy[data[x, 1]], "_", buffer[data[x, 2]], "_", rate[data[x, 3]], "_", length[data[x,4]], ".csv"))
  avgRate <- mean(subset(file, Action != "Writing")$Bitrate)
  cat(avgRate, "\n")
}
print("Variance")
for(x in 1:nrow(data))
{
  file <- read.csv(paste0(file_path, policy[data[x, 1]], "_", buffer[data[x, 2]], "_", rate[data[x, 3]], "_", length[data[x,4]], ".csv"))
  fileNumRows <- length(subset(file, Action != "Writing")$Bitrate)
  #print(paste0(file_path, policy[data[x, 1]], "_", buffer[data[x, 2]], "_", rate[data[x, 3]], "_", length[data[x,4]], ".csv"))
  variance <- var(subset(file, Action != "Writing")$Bitrate) * (fileNumRows - 1)/fileNumRows
  cat(variance, "\n")
}
