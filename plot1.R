library(ggplot2)
library(curl)
library(lubridate)

source("helpers.R")

data <- fetch.data()

GlobalActivePower <- as.numeric(data$Global_active_power)

png("plot1.png")
hist(GlobalActivePower, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()
