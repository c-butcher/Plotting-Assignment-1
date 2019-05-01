library(ggplot2)
library(curl)
library(lubridate)

source("helpers.R")

# You can read about the fetch.data function in the
# helpers.R source file.
data <- fetch.data()

GlobalActivePower <- as.numeric(data$Global_active_power)
Time <- ymd_hms(paste(data$Date, data$Time))

png("plot2.png")
plot(Time, GlobalActivePower, type="l", ylab="Global Active Power (kilowatts)", xlab="")
dev.off()
