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

#initialize png graphic devce, run the plot function and then close the device
png("plot1.png")
hist(dat$Global_active_power, main = "Global Active Power", col = "red", xlab ="Global Active Power (kilowatts)")
dev.off()
