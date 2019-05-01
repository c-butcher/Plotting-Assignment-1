library(ggplot2)
library(curl)
library(lubridate)

source("helpers.R")

# You can read about the fetch.data function in the
# helpers.R source file.
data <- fetch.data()

GlobalActivePower <- as.numeric(data$Global_active_power)
Time <- ymd_hms(paste(data$Date, data$Time))

png('plot3.png')
plot(Time, data$Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
points(Time, data$Sub_metering_2, type="l", col="red")
points(Time, data$Sub_metering_3, type="l", col="blue")
legend("topright", col=c("black", "red", "blue"), lty=c(1,1), legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))
dev.off()
