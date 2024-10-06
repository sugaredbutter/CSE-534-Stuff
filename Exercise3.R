policy <- list('basic','netflix')
buffer <- list('10', '50', '100')
rate <- list('constant', 'valley', 'hill')
length <- list('180', '300')
options(scipen=999)



data <- scan("D:/School/CSE 534/LA/LA/LA_Lab2.tsv", "")
print(data)
data <- data[-(1:7)]
print(data)
data <- as.numeric(data) + 1
print(data)
data <- matrix(data, ncol = 4, byrow = TRUE)
print(data)

file_path <- "D:/School/CSE 534/Lab2Ex2Data/"
print("bitrate variance")
for(x in 1:nrow(data))
{
  file <- read.csv(paste0(file_path, policy[data[x, 1]], "_", buffer[data[x, 2]], "_", rate[data[x, 3]], "_", length[data[x,4]], ".csv"))
  print(paste0(file_path, policy[data[x, 1]], "_", buffer[data[x, 2]], "_", rate[data[x, 3]], "_", length[data[x,4]], ".csv"))
  avgRate <- mean(subset(file, Action != "Writing")$Bitrate)
  fileNumRows <- length(subset(file, Action != "Writing")$Bitrate)
  variance <- var(subset(file, Action != "Writing")$Bitrate) * (fileNumRows - 1)/fileNumRows
  cat("Average Bit-rate:", avgRate, "\nVariance:", variance, "\n")
  #cat(avgRate, variance, "\n")
}
