### Reading Melbourne_Housing dataset
##Loading packages
require(tidyverse)
require(ISLR)
require(MASS)

##Reading the dataset
MelbourneData <- read.csv("http://www.utdallas.edu/~nxv170005/Datasets/Melbourne_housing_FULL.csv", header = T, stringsAsFactors = F)
#View(MelbourneData)
#http://www.utdallas.edu/~nxv170005/Datasets/Melbourne_housing_FULL.csv
#Making it a dataframe
Melbourne_housing_FULL <- data.frame(MelbourneData, stringsAsFactors = F)
#class(Melbourne_housing_FULL)

##Find out the columnnames of this dataset
colnames(Melbourne_housing_FULL)

#Find out the structure of this dataset
str(Melbourne_housing_FULL)

#Descriptive Analysis
summary(Melbourne_housing_FULL)


### Data Preprocessing : Removing NA Values from the dataset :

library(ggplot2)
#Melbourne_housing_FULL <- read.csv("D:/Melbourne_housing_FULL.csv",stringsAsFactors = FALSE)
Melbourne_housing_FULL_1<-data.frame(lapply(Melbourne_housing_FULL,function(x) { gsub("#N/A", NA, x) }))
#class(Melbourne_housing_FULL)


#Find The number of NA values in each column
NA_count_of_each_col<-sapply(Melbourne_housing_FULL,function(x) sum(is.na(x)==TRUE))
NA_count_of_each_col                             

# Find percent of nulls in each column

for(i in 1:ncol(Melbourne_housing_FULL)) {
  colName <- colnames(Melbourne_housing_FULL[i])
  pctNull <- sum(is.na(Melbourne_housing_FULL[,i]))/length(Melbourne_housing_FULL[,i])
  if (pctNull > 0.50) {
    print(paste("Column ", colName, " has ", round(pctNull*100, 3), "% of nulls"))
  }
}

#Drop columns with more than 50 percent NA values

Melbourne_housing_FULL[,c("BuildingArea","YearBuilt")]<-NULL


Melbourne_housing_FULL_clean<-na.exclude(Melbourne_housing_FULL)

Melbourne_housing_FULL_clean$Suburb<-as.factor(Melbourne_housing_FULL_clean$Suburb)
Melbourne_housing_FULL_clean$Type<-as.factor(Melbourne_housing_FULL_clean$Type)
Melbourne_housing_FULL_clean$Method<-as.factor(Melbourne_housing_FULL_clean$Method)
Melbourne_housing_FULL_clean$SellerG<-as.factor(Melbourne_housing_FULL_clean$SellerG)
Melbourne_housing_FULL_clean$Propertycount<-as.numeric(Melbourne_housing_FULL_clean$Propertycount)
Melbourne_housing_FULL_clean$Regionname<-as.factor(Melbourne_housing_FULL_clean$Regionname)
Melbourne_housing_FULL_clean$CouncilArea<-as.factor(Melbourne_housing_FULL_clean$CouncilArea)
Melbourne_housing_FULL_clean$Distance<-as.numeric(Melbourne_housing_FULL_clean$Distance)

head(Melbourne_housing_FULL_clean)


### Finding Top 10 Suburbs with highest no. of observations:

require("dplyr")
require("ggplot2")

top10sub_by_houses <- Melbourne_housing_FULL_clean %>% group_by(Suburb) %>%
  summarise(Number = n()) %>% arrange(desc(Number)) %>%
  head(10)
top10sub_by_houses

ggplot(top10sub_by_houses, aes(reorder(Suburb, Number), Number, fill = Suburb))+
  geom_bar(stat = "identity")+
  theme(legend.position = "none")+
  labs(x = "Suburb", y = "Number of Houses",
       title = "Top10 Suburbs by the Number of Houses")+
  coord_flip()


#Suburb Price Analysis (table format){.tabset}

## Top 20 Most Costliest Suburbs
suburbData = Melbourne_housing_FULL_clean %>% filter(!is.na(Price)) %>%
  group_by(Suburb) %>% 
  summarise(AvgPricePerSuburb = round(median(Price),0)) %>%
  arrange(desc(AvgPricePerSuburb))

suburbData$AvgPriceSuburb = scales::dollar(suburbData$AvgPricePerSuburb)

suburbDataFull = suburbData %>% select(Suburb,AvgPriceSuburb)
suburbData = suburbData[0:19,]

suburbData$AvgPricePerSuburb2 = scales::dollar(suburbData$AvgPricePerSuburb)

ggplot(suburbData, aes(x = reorder(Suburb, AvgPricePerSuburb), 
                       y = AvgPricePerSuburb)) +
  geom_bar(stat='identity',colour="white") +
  geom_text(aes(x = Suburb, y = 1, label = paste0("(",AvgPriceSuburb,")",sep="")),
            hjust=0, vjust=.5, size = 4, colour = 'black',
            fontface = 'bold') +
  labs(x = 'Suburb', y = 'Price', title = 'Price and  Suburb') +
  coord_flip() + 
  theme_bw()


### Plot for distribution of observations in different price range

ggplot(Melbourne_housing_FULL_clean, aes(Price))+
  geom_histogram(binwidth = 100000,color = "black")+
  scale_x_continuous(breaks = c(1000000,2000000,3000000,4000000),
                     labels = c("$1m","$2m","$3m","$4m"))


### Distribution of different Type of houses over the regions:
ggplot(data =Melbourne_housing_FULL_clean) + 
  geom_bar(mapping = aes(x = Regionname, fill = Type),position = "dodge")


###Distribution of observations for different Method used for selling over the Regions:

ggplot(data=Melbourne_housing_FULL_clean) +geom_bar(mapping=aes(x=Regionname,fill=Method))

###Finding Correlation between Categorical Variables :

#Finding correlation between Categorical variables Suburb, Postcode, CouncilArea, Regionname,Type,Method Seller
DF <- data.frame(suburb=Melbourne_housing_FULL_clean$Suburb,postcode=Melbourne_housing_FULL_clean$Postcode,
                 council=Melbourne_housing_FULL_clean$CouncilArea,
                 region=Melbourne_housing_FULL_clean$Regionname,
                 type=Melbourne_housing_FULL_clean$Type,
                 method=Melbourne_housing_FULL_clean$Method,
                 seller=Melbourne_housing_FULL_clean$SellerG)


DF[] <- lapply(DF,as.integer)
cor(DF)

# visualize it
library(corrplot)
corrplot(cor(DF))



###Observations:

#head(Melbourne_housing_FULL_clean)
datetxt <- as.Date(Melbourne_housing_FULL_clean$Date, "%d-%m-%Y")
#head(datetxt)

#Split Date into Day, Month, Year
df <- data.frame(Date = datetxt,
                 year = as.numeric(format(datetxt, format = "%Y")),
                 month = as.numeric(format(datetxt, format = "%m")),
                 day = as.numeric(format(datetxt, format = "%d")))

Melbourne_housing_FULL_clean$year <- as.factor(df$year)
Melbourne_housing_FULL_clean$month <- as.factor(df$month)
#Melbourne_clean$day <- df$day

#Remove Date
Melbourne_housing_FULL_clean$Date <- NULL

#head(Melbourne_housing_FULL_clean)

### Number of sales in each year/each month

barplot(table(Melbourne_housing_FULL_clean$year),main = "Distribution of Observations over the years")


barplot(table(Melbourne_housing_FULL_clean$month),main = "Distribution of Observations over the months")


### Observations:

plot(Melbourne_housing_FULL_clean$year, Melbourne_housing_FULL_clean$Price)


###Observation:


#plot(Melbourne_housing_FULL_clean$Suburb, Melbourne_housing_FULL_clean$Price)

#plot(Melbourne_housing_FULL_clean$month, Melbourne_housing_FULL_clean$Price)

#boxplot(Melbourne_clean$Price ~ Melbourne_clean$SellerG)
#boxplot(Melbourne_clean$Price ~ Melbourne_clean$CouncilArea)


###Covariation between Region and Type of housing property:

ggplot(data = Melbourne_housing_FULL_clean) +
  geom_count(mapping = aes(x = Regionname, y = Type))


###Covariation betweeen Type and Method


ggplot(data = Melbourne_housing_FULL_clean) +
  geom_count(mapping = aes(x = Method, y = Type))


##Basic Plots and visualizations

##Histogram for the column Rooms
hist(Melbourne_housing_FULL_clean$Rooms, col = "blue", xlab = "Rooms", ylab = "Count", xlim = c(1,8), ylim = c(0,8000),main = "Histogram for the column Rooms")

##Histogram for the column Price
hist(Melbourne_housing_FULL_clean$Price, col = "red", xlab = "Price", ylab = "Count" , xlim = c(10^5,6*10^6), ylim = c(0,8000), main = "Histogram for the column Price")

##Plot for Rooms vs Prices
plot(Melbourne_housing_FULL_clean$Price ~ Melbourne_housing_FULL_clean$Rooms, pch = 19, col = "blue", xlim = c(0,12), ylim = c(10^5,10^7), xlab = "Rooms", ylab = "Price", main = "Plot for Rooms vs Price")

##Visualizations
require(ggplot2)
require(scales)

###Barplot for number of rooms most popularly found in homes
ggplot(Melbourne_housing_FULL_clean, aes(x = Rooms)) + geom_bar(fill = "blue", color = "red", size = 1.25) + labs(title = "Barplot for number of rooms most popularly found in homes", xlab = "Rooms", ylab = "Count") + scale_x_discrete(limits = c("1","2","3","4","5","6","7","8"))

###Price vs Rooms
ggplot(Melbourne_housing_FULL_clean, aes(Rooms , Price)) + geom_bar(stat = "identity", fill = "orange", size = 1.25) + labs(title = "Price vs Rooms", xlab = "Rooms", ylab = "Price") + scale_x_discrete(limits = c("1","2","3","4","5","6","7","8"))

###Popularity of Region based on number of houses bought
ggplot(Melbourne_housing_FULL_clean, aes(x = Regionname)) + geom_bar(fill = "green", color = "blue", size = 1.25) + labs(title = "Popularity of Region based on number of houses bought", xlab = "Region Name", ylab = "Count") + ylim(0,6000)

###Price vs Cars
ggplot(Melbourne_housing_FULL_clean, aes(Car, Price)) + geom_bar(stat = "identity", fill = "red", size = 1.25) + labs(title = "Price vs Cars", xlab = "Cars", ylab = "Price") + xlim(0,8)

###Price vs Bathrooms
ggplot(Melbourne_housing_FULL_clean, aes(Bathroom, Price)) + geom_jitter(color = "navy blue", size = 1.25, size = 3) + labs(title = "Price vs Bathrooms", xlab = "Bathrooms", ylab = "Price") + xlim(0,8) + ylim(1e+05,10e+06)

#Correlations

## Rooms vs Bathrooms
cor(Melbourne_housing_FULL_clean$Rooms, Melbourne_housing_FULL_clean$Bathroom)

##Price vs Rooms
cor(Melbourne_housing_FULL_clean$Rooms, Melbourne_housing_FULL_clean$Price)

##Price vs Car
cor(Melbourne_housing_FULL_clean$Car, Melbourne_housing_FULL_clean$Price)



###Distribution of observations over the 3 years

ggplot(Melbourne_housing_FULL_clean, aes(Melbourne_housing_FULL_clean$year, Melbourne_housing_FULL_clean$Price)) + 
  geom_bar(stat = "identity") + 
  labs(y = "Price", x = "Year")

#Linear Regression

# Inspecting rooms vs bedroom2 

## checking the correlation
cor.test(Melbourne_housing_FULL_clean$Rooms, Melbourne_housing_FULL_clean$Bedroom2)

# So we can drop Bedroom2

ggplot(data =Melbourne_housing_FULL_clean ) + 
  geom_point(mapping = aes(x = Suburb, y = Price))
ggplot(data = Melbourne_housing_FULL_clean) + 
  geom_point(mapping = aes(x = SellerG, y = Price))
ggplot(data = Melbourne_housing_FULL_clean) + 
  geom_point(mapping = aes(x = Method, y = Price))
ggplot(data = Melbourne_housing_FULL_clean) + 
  geom_boxplot(mapping = aes(x = Postcode, y = Price))


# Eliminate any home where it is claimed it has more bathrooms than rooms

## Eliminate rows having 0 bathrooms or more and 5
Melbourne_housing_FULL_clean <- Melbourne_housing_FULL_clean %>%
  filter(Bathroom > 0 & Bathroom <= 5)
#summary(Melbourne_housing_FULL_clean)

## Eliminate rows with 0 Landsize
Melbourne_housing_FULL_clean<- Melbourne_housing_FULL_clean %>%
  filter(Landsize > 0)
#summary(Melbourne_housing_FULL_clean)

## Analysing the lowest values of landsize
head(Melbourne_housing_FULL_clean) %>%
  select(Landsize, Type) %>%
  arrange(Landsize)

lm.fit <- lm(Price~Suburb+Rooms+Type+Method+SellerG+Bathroom+Car+Landsize+Lattitude+Longtitude+year+month, data=Melbourne_housing_FULL_clean)
summary(lm.fit)

plot(lm.fit)

