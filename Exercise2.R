library(readr)
library(tidyverse)
library(ggpubr)
library(tidyr)
library(dplyr)

#Basic and Netflix files
list_of_basic <- list.files(path = "D:/School/CSE 534/Lab2Ex2Data",
                            recursive = TRUE,
                            pattern = "^basic.*\\.csv$",
                            full.names = TRUE)
list_of_netflix <- list.files(path = "D:/School/CSE 534/Lab2Ex2Data",
                            recursive = TRUE,
                            pattern = "^netflix.*\\.csv$",
                            full.names = TRUE)

bdf <- readr::read_csv(list_of_basic, id = "file_name")
ndf <- readr::read_csv(list_of_netflix, id = "file_name")



netflixAverageRate180 <- NULL
basicAverageRate180<- NULL
netflixAverageRate300 <- NULL
basicAverageRate300<- NULL

netflixVariance <- NULL
basicVariance <- NULL
for (x in 1:18)
{
  #Title
  file_path = unique(bdf$file_name)[x]
  title <- gsub("^[^_]*_(.*)\\.csv","\\1", file_path)

  #Current Files
  netflixA = ndf[ndf$file_name == unique(ndf$file_name)[x], ]
  basicA = bdf[bdf$file_name == unique(bdf$file_name)[x], ]

  #Bit-Rate ANOVA
  if(gsub("^[^_]*_(.*)_", "\\2", title) == "180")
  {
    netflixAverageRate180 <- c(netflixAverageRate180, mean(subset(netflixA, Action != "Writing")$Bitrate))
    basicAverageRate180 <- c(basicAverageRate180, mean(subset(basicA, Action != "Writing")$Bitrate))
  }
  else
  {
    netflixAverageRate300 <- c(netflixAverageRate300, mean(subset(netflixA, Action != "Writing")$Bitrate))
    basicAverageRate300 <- c(basicAverageRate300, mean(subset(basicA, Action != "Writing")$Bitrate))
  }
  netflixNumRows <- length(subset(netflixA, Action != "Writing")$Bitrate)
  basicNumRows <- length(subset(basicA, Action != "Writing")$Bitrate)

  #Variance ANOVA
  netflixVariance <- c(netflixVariance, var(subset(netflixA, Action != "Writing")$Bitrate) * (netflixNumRows - 1)/netflixNumRows)
  basicVariance <- c(basicVariance, var(subset(basicA, Action != "Writing")$Bitrate) * (basicNumRows - 1)/basicNumRows)


  #Tables similar to data-analysis in FABRIC
  netflixA$policy <- "netflix"
  basicA$policy <- "basic"

  df <- rbind(basicA, netflixA)

  bit_rate = ggplot(df, aes(x = EpochTime, y = Bitrate, color = policy)) + geom_line(data = subset(df, Action != "Writing")) + labs(title = "Bit-rate")
  buffer = ggplot(df, aes(x = EpochTime, y = CurrentBufferSize, color = policy)) + geom_line(data = subset(df, Action != "Writing")) + labs(title = "Buffer")

  combined_plot <- ggarrange(bit_rate, buffer, nrow = 2, ncol = 1)
  final_plot <- annotate_figure(combined_plot, top = text_grob(title, face = "bold", size = 14))
  print(final_plot)
  Sys.sleep(1)
}

#Plot ANOVA STUFF
policy <- c(rep('basic', 9), rep('netflix', 9))
policyVariance <- c(rep('basic', 18), rep('netflix', 18))
bit_rate180 <- c(basicAverageRate180, netflixAverageRate180)
bit_rate300 <- c(basicAverageRate300, netflixAverageRate300)
variance <- c(basicVariance, netflixVariance)

plot(bit_rate180 ~ factor(policy), data = data.frame(policy, bit_rate180), main = "bit_rate for 3 mins")
plot(bit_rate300 ~ factor(policy), data = data.frame(policy, bit_rate300), main = "bit_rate for 5 mins")
plot(variance ~ factor(policyVariance), data = data.frame(policyVariance, variance), main = "variance")


bit_rate180.aov <- aov(bit_rate180 ~ factor(policy), data = data.frame(policy, bit_rate180))
bit_rate300.aov <- aov(bit_rate300 ~ factor(policy), data = data.frame(policy, bit_rate300))
variance.aov <- aov(variance ~ factor(policyVariance), data = data.frame(policyVariance, variance))

summary(bit_rate180.aov)
summary(bit_rate300.aov)
summary(variance.aov)
