#### LOAD LIBRARY AND CLOSE ANY POSSIBLE OPEN DEVICES AND RESET PAR() ####

library(data.table)
dev.off()

#### DOWNLOAD AND READ FILE #####

if(!file.exists("./data")){
  
  dir.create("./data")
  
}

if(!file.exists("./data/Database.zip")){
  
  zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
  download.file(zipurl,destfile="./data/Database.zip")
  
}

if (!file.exists("household_power_consumption.txt")) { 
  
  unzip(zipfile="./data/Database.zip",exdir="./data")
  
}

dataset <- read.table("./data/household_power_consumption.txt",header=TRUE,
                      colClasses = c('character','character','numeric',
                                     'numeric','numeric','numeric','numeric','numeric','numeric'),
                      sep = ";",na.strings = '?')

#### DATA CLEANING ####

dataset$Date <- as.Date(dataset$Date, "%d/%m/%Y")

dataset <- subset(dataset,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

dataset <- dataset[complete.cases(dataset),]

dateTime <- setNames(paste(dataset$Date, dataset$Time), "DateTime")

dataset <- cbind(dateTime, dataset)

dataset$dateTime <- as.POSIXct(dateTime)

#### GRAPH PLOTTING ####

plot(dataset$Sub_metering_1 ~ dataset$dateTime, type = 'l',xlab="", 
     ylab = "Global Active Power (kilowatts)", col="black")
lines(dataset$Sub_metering_2 ~ dataset$dateTime, col="red")
lines(dataset$Sub_metering_3 ~ dataset$dateTime, col="blue")

legend('topright', legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"),lwd=c(1,1,1))

#### SAVE GRAPH IN PNG DEVICE ####

dev.copy(png,"plot3.png")
dev.off()