## Cleaning the ScrapeStorm data

library(readxl)
library(rex)
library(stringr)
library(tidyr)
library(scales)
library(plyr)
library(ggplot2)
library(PerformanceAnalytics)
library(tidyverse)
library(dplyr)

## URL's from Zillow searches in Newark, DE, each has ~500 homes
## Limmited to townhouses and houses
## Between $100,000 and $500,000
## There was an abundance of data...
## url_Sqrft_yearBuiltLow_yearBuiltHigh
## url_underSqrft_...


url_2000_1995_ = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22min%22:2000},%22built%22:{%22min%22:1995}}}'
url_2000_1975_1995 = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22min%22:2000},%22built%22:{%22min%22:1975,%22max%22:1995}}}'
url_2000_1900_1975 = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22min%22:2000},%22built%22:{%22min%22:1900,%22max%22:1975}}}'
url_u2000_1995_ = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22max%22:2000},%22built%22:{%22min%22:1995}}}'
url_u2000_1989_1995 = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22max%22:2000},%22built%22:{%22max%22:1995,%22min%22:1989}}}'
url_u2000_1978_1989 = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22max%22:2000},%22built%22:{%22max%22:1989,%22min%22:1978}}}'
url_u2000_1964_1978 = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22max%22:2000},%22built%22:{%22max%22:1978,%22min%22:1964}}}'
url_u2000_1955_1964 = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22max%22:2000},%22built%22:{%22max%22:1964,%22min%22:1955}}}'
url_u2000_1900_1955 = 'https://www.zillow.com/newark-de/sold/house,townhouse_type/?searchQueryState={%22usersSearchTerm%22:%22Newark,%20DE%22,%22regionSelection%22:[{%22regionId%22:6183,%22regionType%22:6}],%22isMapVisible%22:true,%22mapBounds%22:{%22west%22:-75.88276105957033,%22east%22:-75.5188389404297,%22south%22:39.51863476965846,%22north%22:39.80242983152242},%22mapZoom%22:11,%22isListVisible%22:true,%22pagination%22:{},%22dplyr::filterState%22:{%22price%22:{%22min%22:100000,%22max%22:500000},%22monthlyPayment%22:{%22min%22:378,%22max%22:1891},%22isForSaleByAgent%22:{%22value%22:false},%22isForSaleByOwner%22:{%22value%22:false},%22isNewConstruction%22:{%22value%22:false},%22isForSaleForeclosure%22:{%22value%22:false},%22isComingSoon%22:{%22value%22:false},%22isAuction%22:{%22value%22:false},%22isPreMarketForeclosure%22:{%22value%22:false},%22isPreMarketPreForeclosure%22:{%22value%22:false},%22isMakeMeMove%22:{%22value%22:false},%22isRecentlySold%22:{%22value%22:true},%22isMultiFamily%22:{%22value%22:false},%22isCondo%22:{%22value%22:false},%22isManufactured%22:{%22value%22:false},%22isLotLand%22:{%22value%22:false},%22sqft%22:{%22max%22:2000},%22built%22:{%22max%22:1955,%22min%22:1900}}}'
#data <- read_xlsx("2019-6-10-Recently Sold Homes - 1,660 Transactions  Zillow-ScrapingData-ScrapeStorm.xlsx")
setwd(
  "/Volumes/GoogleDrive/My Drive/1 FSAN/Summer Paper/SummerPaper"
)

files <- list.files(path = paste0(getwd(), "/Data"))

data <- data.frame()
for (file in files) {
  temp <- read.csv(paste0(getwd(), "/Data/", file))
  colnames(temp) <-
    c(
      "Address",
      "Link",
      "SaleDate",
      "Thumbnail",
      "SalePrice",
      "Sqft",
      "Street",
      "CityStateZip",
      "Zip",
      "Baths",
      "Beds",
      "Sqft2",
      "LotSize",
      "PriceHistory"
    )
  data <- rbind(data, temp)
  data <- dplyr::distinct(data, Address, .keep_all = TRUE)
}

priceHistory <- data %>%
  dplyr::select(Address, PriceHistory)

date <- "[1]*[0-9]+[[/]]+[1-3]*[0-9]+[[/]]+[0-9]{4}"
event <-
  "((Sold)|(Listed for sale)|(Listed for rent)|(Listing removed)|(Price change)|(Pending sale)|(Back on market)|(Price reduced))+"
price <- "(([[$]]+\\d+([,]+\\d+)?)|(----))+"

dateEventPrice <- paste0(date, event, price)


priceHistories <- data.frame(matrix(ncol = 4, nrow = 0))
cnames <- c("Address", "Date", "Event", "Price")
colnames(priceHistories) <- cnames

for (i in 1:nrow(data)) {
  address <- data$Address[i]
  history <- data$`PriceHistory`[i]
  
  dateEventPrice_all <-
    stringr::str_extract_all(history, dateEventPrice)[[1]]
  
  if (is.na(dateEventPrice_all[1])) {
    next
  }
  
  dates <-
    data.frame(matrix(unlist(
      stringr::str_extract_all(dateEventPrice_all, date)
    ), byrow = T), stringsAsFactors = F)
  events <-
    data.frame(matrix(unlist(
      stringr::str_extract_all(dateEventPrice_all, event)
    ), byrow = T), stringsAsFactors = F)
  prices <-
    data.frame(matrix(unlist(
      stringr::str_extract_all(dateEventPrice_all, price)
    ), byrow = T), stringsAsFactors = F)
  
  prices[, ] <- as.numeric(gsub("\\$", "", gsub(",", "", prices[, ])))
  
  hist <- data.frame(rep(address, nrow(prices)), dates, events, prices)
  colnames(hist) <- cnames
  hist$Date <- as.Date(hist$Date, "%m/%d/%Y")
  
  priceHistories <- rbind(priceHistories, hist)
}

merged <- merge(data, priceHistories, by = "Address") %>%
  arrange(Date)

listPrices <- merged %>%
  dplyr::select(Date, Event, Price) %>%
  dplyr::filter(Event == "Listed for sale",
         Price < 1000000) %>%
  mutate(roll3 = (lag(Price, 1) + lag(Price, 2) + lag(Price, 3) + lag(Price, 4)) /
           4)

ggplot(listPrices) +
  geom_line(aes(x = listPrices$Date, y = listPrices$roll3)) +
  scale_y_continuous(labels = dollar)

write.csv(merged, paste0(getwd(), "/Data/merged_Data.csv"))

merged %>%
  mutate(Listed = ifelse(Event == "Listed for rent", 1, 0)) %>%
  ungroup() %>%
  dplyr::summarise(Listings = sum(Listed))

clean <- merged %>%
  dplyr::filter(Event != "Listed for rent") %>%
  mutate(
    Sqft = as.numeric(gsub(",", "", Sqft)),
    Sqft2 = as.numeric(gsub(",", "", Sqft2)),
    LotSize = as.numeric(gsub(",", "", LotSize)),
    SqFt = max(Sqft, Sqft2, na.rm = TRUE)
  ) %>%
  mutate(
    SqrFt = ifelse((SqFt > 5000) && (is.na(LotSize)), LotSize, SqFt),
    LotSize = ifelse((SqFt > LotSize), SqFt, LotSize),
    LotSize = ifelse(Address == "119 Richards Ln, Newark, DE", 4356, LotSize),
    SqrFt = ifelse(Address == "119 Richards Ln, Newark, DE", 0.1 *
                     SqrFt, SqrFt),
    SqrFt = ifelse(Address == "2 Festival Ct, Newark, DE", 1700, SqrFt),
    Price = ifelse(Price <= 10000, Price * 10, Price),
    Price = ifelse(Price < 100000, Price * 10, Price)
  ) %>%
  dplyr::select(Address, Zip, Date, Event, Price, Beds, Baths, SqrFt, LotSize) %>%
  arrange(Address, Date) %>%
  group_by(Address)



##write.csv(clean,paste0(getwd(), "/Data/clean_Data.csv"))

## Found some data by hand, not much...
clean <- read.csv(paste0(getwd(), "/Data/clean_Data.csv"))

noMissing <- clean %>% dplyr::filter(
  !is.na(Price),!is.na(Beds),!is.na(Baths),!is.na(SqrFt),
  SqrFt != -Inf,!is.na(LotSize), SqrFt != "#NAME?",
  LotSize != -Inf,!is.na(Date)
)

write.csv(noMissing, paste0(getwd(), "/Data/noMiss.csv"))

## How's 3201 data points?
noMissing %>%
  mutate(Listed = ifelse(Event == "Listed for sale", 1, 0)) %>%
  dplyr::summarise(Listings = sum(Listed))

## Still some data cleaning around prices and organizing
## Will do that later
homes_data <- read.csv(paste0(getwd(), "/Data/noMiss.csv"))
homes_data$Date <- as.Date(homes_data$Date, "%m/%d/%y")

listSale <-dplyr::filter(homes_data, Event == "Listed for sale" |
           Event == "Sold")

listSale <- listSale %>%
  mutate(Time = as.numeric(listSale$Date)) %>%
  mutate(Time = Time - min(Time) + 1) %>%
  arrange(Address, Time)

## Time is in Days
listSale$DaysOnMarket = NA
## Calculate the days on market for every Listing
## If there is a Sale then this is Days to Sale
## If the listing is removed, then we have another metric for Seller time preferences
## However, the data is too messy for this to be feasible atm
## perhaps future work will utilize this aspect of the data

for (r in 1:nrow(listSale)) {
  if (listSale[r, "Event"] == "Sold") {
    next
  }
  else if (listSale[r, "Event"] == "Listed for sale") {
    for (s in (r + 1):nrow(listSale)) {
      if(listSale[s,"Address"] != listSale[r,"Address"]){
        break
      }
      if (listSale[s, "Event"] == "Sold") {
        for (i in r:s) {
          if (listSale[i, "Address"] == listSale[s, "Address"])
            listSale[i, "DaysOnMarket"] = floor(difftime(listSale[s, "Date"], listSale[r, "Date"], units = "days"))
        }
        remove(i)
        break
      }
    }
    remove(s)
  }
}
## Remove NA's from time since they are Sales we do not have Listings for
## This avoids biasing my results to Buyer's generated from irrelevant data from
## the market at a different time
listSaleTime <- dplyr::filter(listSale,
                       !is.na(DaysOnMarket),
                       DaysOnMarket < 400) %>%
  mutate(Time = Time - min(Time) + 1) %>%
  arrange(Date)

## Now I need rolling windows for the time on market
## I will arbitrarily use 15 Listings/Sales as the window width
## Realtors often show the last x transactions, typically of similiar houses,
## but for simplicity, I will hold to this method

listSaleTime_Listings <- dplyr::filter(listSaleTime,
                                Event == "Listed for sale")
listSaleTime_Sales <- dplyr::filter(listSaleTime,
                             Event == "Sold")


listSaleTime_Listings$RollTimeAv <- rollapply(listSaleTime_Listings$DaysOnMarket, 15, mean, na.rm=TRUE, fill=NA, align='right')
listSaleTime_Sales$RollTimeAv <- rollapply(listSaleTime_Sales$DaysOnMarket, 15, mean, na.rm=TRUE, fill=NA, align='right')


## dplyr::filter down to only the helpful data
dataToDraw <- rbind(listSaleTime_Listings, listSaleTime_Sales) %>%
  dplyr::filter(!is.na(RollTimeAv)) %>%
  dplyr::filter(Date >= as.Date("2016-06-04")) %>%
  arrange(Date,Address)

dataToDraw <- dataToDraw %>%
  mutate(Time = as.numeric(dataToDraw$Date)) %>%
  mutate(Time = Time - min(Time) + 1)


## The Data we will draw from to generate Buyers and Sellers
write.csv(dataToDraw, paste0(getwd(), "/Data/dataToDraw.csv"))
write.csv(dataToDraw,paste0(getwd(), "/dataToDraw.csv"))




### Now to get the generation frequencies of Buyers and Sellers
dataToDraw_freq <- dataToDraw %>%
  dplyr::select(Address,Zip,Date,Event,Price,Beds,Baths,SqrFt,LotSize,Time,DaysOnMarket,RollTimeAv) %>%
  dplyr::filter(Date >= as.Date("2016-06-04")) %>%
  mutate(isListing = ifelse(Event == "Listed for sale", 1,0)) %>%
  mutate(isSale = ifelse(Event == "Sold", 1,0)) %>%
  mutate(Year = substr(Date,1,4)) %>%
  mutate(Month = substr(Date,6,7)) %>%
  arrange(Date)

## Rolling Average Number of Sales and Listings
timeLine <- dataToDraw_freq %>% 
  dplyr::select(Date,Year,Month,DaysOnMarket,isListing,isSale) %>%
  group_by(Date) %>%
  dplyr::summarise(ListingsToday = sum(isListing),
            SalesToday = sum(isSale))
head(timeLine)

minDate <- min(dataToDraw$Date)
maxDate <- max(dataToDraw$Date)

numDays <- as.numeric(difftime(maxDate,minDate, units = c("days"))) + 1

allDays <- as.data.frame(seq(from = minDate, to = maxDate, by = 1))
colnames(allDays) <- c("Date")

timeLineFull <- full_join(timeLine,allDays, by = c("Date")) %>%
  arrange(Date) %>%
  mutate(ListingsToday = ifelse(is.na(ListingsToday), 0, ListingsToday)) %>%
  mutate(SalesToday = ifelse(is.na(SalesToday), 0, SalesToday)) %>%
  mutate(RollAvWeeklyListings = roll_mean(as.matrix(ListingsToday),7)) %>%
  mutate(RollAvWeeklySales = roll_mean(as.matrix(SalesToday),7)) %>%
  mutate(RollSdWeeklySales = roll_sd(as.matrix(SalesToday),7)) %>%
  mutate(RollSdWeeklyListings = roll_sd(as.matrix(ListingsToday),7)) %>%
  dplyr::filter(Date >= as.Date("2016-06-10"))

## For Listings (Seller Generation), we can just spin a 1-100 spinner
ggplot(timeLineFull) +
  geom_bar(aes(x=factor(ListingsToday), y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent) +
  ylab("Frequencies")

timeLineFull$ListingsToday <- as.factor(timeLineFull$ListingsToday)
timeLineFull$SalesToday <- as.factor(timeLineFull$SalesToday)

## Generate Thresholds
listingFrequency <- timeLineFull %>%
  group_by(ListingsToday) %>%
  mutate(count = 1) %>%
  dplyr::summarise(freq = sum(count)/nrow(timeLineFull)) %>%
  mutate(High = ifelse(is.na(lag(freq)),freq,cumsum(freq))) %>%
  mutate(Low = ifelse(is.na(lag(freq)),0,lag(High)))

## For Sales (Buyer Generation), we can just spin a 1-100 spinner
ggplot(timeLineFull) +
  geom_bar(aes(x=factor(SalesToday), y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent) +
  ylab("Frequencies")


## Generate the thresholds
saleFrequency <- timeLineFull %>%
  group_by(SalesToday) %>%
  mutate(count = 1) %>%
  dplyr::summarise(freq = sum(count)/nrow(timeLineFull)) %>%
  mutate(High = ifelse(is.na(lag(freq)),freq,cumsum(freq))) %>%
  mutate(Low = ifelse(is.na(lag(freq)),0,lag(High)))

## The Data we will use to generate buyers and sellers at random
write.csv(listingFrequency, paste0(getwd(), "/Data/listingFrequency.csv"))
write.csv(saleFrequency, paste0(getwd(), "/Data/saleFrequency.csv"))

write.csv(listingFrequency,paste0(getwd(), "/listingFrequency.csv"))
write.csv(saleFrequency,paste0(getwd(), "/saleFrequency.csv"))

seller_prob <- read.csv(paste0(getwd(),"/listingFrequency.csv"))
n <- runif(1,0,1)
num <- seller_prob %>%
  dplyr::filter(High >= n) %>%
  dplyr::filter(Low <= n) %>%
  arrange(ListingsToday) %>%
  dplyr::summarise(toGen = min(ListingsToday))

as.numeric(num)