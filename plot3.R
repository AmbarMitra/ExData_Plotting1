#loading required package/s
library(dplyr)
#read the raw txt file
dat <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")

#filter the dataset for 2007-02-01 and 2007-02-02 and do necessary data type changes for the columns
dat <- dat %>% filter(Date %in% c("1/2/2007", "2/2/2007")) %>% mutate(Date = as.Date(Date, format = "%d/%m/%Y")
                                                                      ,Time = strptime(paste(Date, Time), format = "%Y-%m-%d %H:%M:%S")
                                                                      ,Global_active_power = as.numeric(Global_active_power)
                                                                      ,Global_reactive_power = as.numeric(Global_reactive_power)
                                                                      ,Voltage = as.numeric(Voltage)
                                                                      ,Sub_metering_1 = as.numeric(Sub_metering_1)
                                                                      ,Sub_metering_2 = as.numeric(Sub_metering_2)
                                                                      ,Sub_metering_3 = as.numeric(Sub_metering_3))

#create another dataset for creating the chart where each sub metering type is a level in a column by using gather
#datatype of time had to be changed to POSIXct as otherwise error was being encountered in executing gather
dat2 <- dat %>% mutate(Time = as.POSIXct(Time)) %>% gather(key = sub_metering_type, value = sub_metering_value, Sub_metering_1:Sub_metering_3)

#initialize png graphic devce, run the plot function and then close the device
png("plot3.png")
plot(dat2$Time, dat2$sub_metering_value, xlab = "", ylab = "Energy sub metering", type = "n")
#separate lines for separate subsets of the newly created sub metering type column
with(subset(dat2, sub_metering_type == "Sub_metering_1"), lines(Time,sub_metering_value, col = "black"))
with(subset(dat2, sub_metering_type == "Sub_metering_2"), lines(Time,sub_metering_value, col = "red"))
with(subset(dat2, sub_metering_type == "Sub_metering_3"), lines(Time,sub_metering_value, col = "blue"))
#creating legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)
dev.off()
