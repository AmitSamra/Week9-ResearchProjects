# Set wd
setwd("/Users/asamra/dev/R_Project")

# Shows program info
sessionInfo()

# Install packages
#install.packages("readr")
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("corrplot")
#install.packages("tidyverse")

# Load packages
library(readr)
library(plyr)
library(dplyr)
library(ggplot2)
library(corrplot)
#library(tidyverse)

# Import CSV and create DF using readr
nyc_crime <- read_csv("NYPD_Arrests_Data__Historic_.csv")

# View first 5 lines of df
head(nyc_crime[1:5])

# Show DF in new window
View(nyc_crime)

# Show summary of data including NA's
summary(nyc_crime)

# Remove all rows with NA's in any column
# Save as new DF using <-
nyc_crime2 <- na.omit(nyc_crime)

# Shows new DF in new tab
View(nyc_crime2)
summary(nyc_crime2)

# Shows object type
typeof(nyc_crime)
typeof(nyc_crime2)

# Shows object class
class(nyc_crime)
class(nyc_crime2)

# Change ARREST_DATE in nyc_crime2 from character to date
nyc_crime2$ARREST_DATE <- as.Date(nyc_crime2$ARREST_DATE, format = "%m/%d/%Y")

# Check to see if date was changed
head(nyc_crime2$ARREST_DATE)

# Check to see if date was changed
summary(nyc_crime2)

# Order ARREST_DATE by ascending
nyc_crime2 <- nyc_crime2[order(nyc_crime2$ARREST_DATE),]

# Order ARREST_DATE by descending
nyc_crime2 <- nyc_crime2[rev(order(nyc_crime2$ARREST_DATE)),]
View(nyc_crime2)

# Create new columns for Year Month Day
nyc_crime2$ARREST_YEAR <- format(as.Date(nyc_crime2$ARREST_DATE, format = "%m/%d/%Y"),"%Y")
nyc_crime2$ARREST_MONTH <- format(as.Date(nyc_crime2$ARREST_DATE, format = "%m/%d/%Y"),"%m")
nyc_crime2$ARREST_DAY <- format(as.Date(nyc_crime2$ARREST_DATE, format = "%m/%d/%Y"),"%d")
View(nyc_crime2)

head(nyc_crime2[1:5])
# Grab a particular value df[r,c]
nyc_crime2[2,3]

# Count all rows
count(nyc_crime2)

# Group all rows by year column we created and count
count(nyc_crime2, ARREST_YEAR)

# Count rows based on condition
# Shows count of all arrests in 2006
length(which(nyc_crime2$ARREST_YEAR == "2006"))

# Count / Group rows by year and count using plyr
count(nyc_crime2, ARREST_YEAR)
count(nyc_crime2, ARREST_MONTH)
count(nyc_crime2, ARREST_DAY)

# Filter using base R command to create a subset 
df_2006_base <- nyc_crime2[nyc_crime2$ARREST_YEAR == 2006, ]
View(df_2006_base)

# Using dplyr, we can simplify the syntax to create a subset 
# Filter using dplyr and create new df
df_2006_dplyr <- filter(nyc_crime2, (ARREST_YEAR == 2006))
View(df_2006_dplyr)

# Filter all rows by multiple conditions using dplyr
df_2006_drugs <- filter(nyc_crime2, (ARREST_YEAR == 2006 & KY_CD == 235))
View(df_2006_drugs)

# Plot total arrests using base R
table(nyc_crime2$ARREST_YEAR) %>% plot(type='l')

# Plot total arrests for all years
nyc_crime2 %>% 
  group_by(ARREST_YEAR) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = total_arrests, group = 1 ) ) + geom_line()

# Plot total drug arrests for all years
nyc_crime2 %>% 
  filter(KY_CD == 235) %>% 
  group_by(ARREST_YEAR) %>% 
  summarize(drug_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = drug_arrests, group = 1 ) ) + geom_line()

# Plot total arrests with line for each year
nyc_crime2 %>% 
  group_by(ARREST_YEAR, ARREST_MONTH) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_MONTH, y = total_arrests, group = ARREST_YEAR, color = ARREST_YEAR) ) + geom_line()

# Plot total arrests with line for each KY_CD
nyc_crime2 %>% 
  #filter(KY_CD == 235) %>% 
  group_by(ARREST_YEAR, KY_CD) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = total_arrests, group = KY_CD, color = KY_CD) ) + geom_line()

# Count unique KY_CD
all_KY_CD <- unique( nyc_crime2$KY_CD )
length(all_KY_CD)

# Top 10 crimes by total arrests
crimes_by_KY_CD <- nyc_crime2 %>% 
  group_by(KY_CD) %>% 
  summarize(total_arrests = n())
# order top 10 crimes desc
top10_crimes <- top_n(crimes_by_KY_CD, 10, total_arrests) %>% arrange(desc(total_arrests))

top10_crimes

# Plot total drug arrests by year bar
nyc_crime2 %>% 
  filter(KY_CD == 235) %>% 
  group_by(ARREST_YEAR) %>% 
  summarize(drug_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = drug_arrests, group = ARREST_YEAR) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue')

# Plot total drug arrests by year bar adjust axis
nyc_crime2 %>% 
  filter(KY_CD == 235) %>% 
  group_by(ARREST_YEAR) %>% 
  summarize(drug_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = drug_arrests, group = ARREST_YEAR ) ) + 
  geom_bar(stat = 'identity', fill='steelblue') + 
  theme_minimal() +
  ggtitle('Drug Arrests by Year') +
  xlab('Year') +
  ylab('Number') +
  scale_y_continuous(breaks = seq(0,100000,5000))

# Plot total arrrests by borough
nyc_crime2 %>%
  #filter(ARREST_YEAR == 2018) %>%
  #filter(KY_CD == 235) %>%
  group_by(ARREST_BORO) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_BORO, y = total_arrests, group = 1) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue')

# Remove scientific notation in R
options(scipen=999)
  
# Plot total arrrests by month
nyc_crime2 %>% 
  #filter(ARREST_YEAR == 2017) %>%
  group_by(ARREST_MONTH) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_MONTH, y = total_arrests, group = 1) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue')

# Top 10 crimes by name
crimes_by_OFNS_DESC <- nyc_crime2 %>%
  #filter(ARREST_YEAR == 2018) %>% 
  group_by(OFNS_DESC) %>% 
  summarize(total_arrests = n())
# order top 10 crimes desc
top10_name <- top_n(crimes_by_OFNS_DESC, 10, total_arrests) %>% arrange(desc(total_arrests))

top10_name

# Plot total arrrests of top crimes
top10_name %>% 
  group_by(OFNS_DESC) %>% 
  #summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = OFNS_DESC, y = total_arrests, group = 1) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Filter crimes for two years and save as df
arrests_2018_2017 <- nyc_crime2 %>% 
  filter(ARREST_YEAR %in% c(2018, 2017)) %>% 
  group_by(ARREST_MONTH, ARREST_YEAR) %>% 
  summarize(total_arrests = n())

arrests_2018_2017

# Plot filter for two years
nyc_crime2 %>% 
  filter(ARREST_YEAR %in% c(2018, 2017)) %>% 
  group_by(ARREST_MONTH, ARREST_YEAR) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_MONTH, y = total_arrests, group = ARREST_YEAR, color = ARREST_YEAR) ) + geom_line()

# Create subset for 2018 grouped by month
arrests_2018 <- nyc_crime2 %>% 
  filter(ARREST_YEAR %in% c(2018)) %>% 
  group_by(ARREST_MONTH) %>% 
  summarize('2018' = n())

# Create subset for 2017 grouped by month
arrests_2017 <- nyc_crime2 %>% 
  filter(ARREST_YEAR %in% c(2017)) %>% 
  group_by(ARREST_MONTH) %>% 
  summarize('2017' = n())

# Create subset for 2016 grouped by month
arrests_2016 <- nyc_crime2 %>% 
  filter(ARREST_YEAR %in% c(2016)) %>% 
  group_by(ARREST_MONTH) %>% 
  summarize('2016' = n())

# Merge 2017 and 2018
arrests_17_18 <- merge(arrests_2017, arrests_2018)
arrests_17_18

# Merge 2016 and 2018_2017 
arrests_16_17_18 <- merge(arrests_2016, arrests_17_18)
arrests_16_17_18

# Drop month column
arrests_3col <- select(arrests_16_17_18, -1)
arrests_3col

# Compute correlation matrix for joined df
cor(arrests_3col)

# Compute correlation manually for two columns only
cor(arrests_2017[2], arrests_2018[2])

# Plot correlations 
corrplot(cor(arrests_3col), method='circle')

# Plot total arrrests by age - note weird result unless we filter by year
nyc_crime2 %>% 
  #filter(ARREST_YEAR %in% c(2018, 2017, 2016)) %>%
  group_by(AGE_GROUP, ARREST_YEAR) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = AGE_GROUP, y = total_arrests) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue')

# Plot above shows many differnt age groups. Why?
# Because there are many age groups.
all_age <- unique( nyc_crime2$AGE_GROUP )
length(all_age)
all_age
# Above shows 91 age groups.

# Fix plot above by filtering by age groups
nyc_crime2 %>% 
  filter(AGE_GROUP %in% c("25-44","65+","45-64","18-24","<18")) %>%
  group_by(AGE_GROUP) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = AGE_GROUP, y = total_arrests) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue')

# Save data above into df
arrests_age <- nyc_crime2 %>% 
  filter(AGE_GROUP %in% c("25-44","65+","45-64","18-24","<18")) %>%
  group_by(AGE_GROUP) %>% 
  summarize(total_arrests = n())
arrests_age

# Plot total arrests by race
nyc_crime2 %>%
  group_by(PERP_RACE) %>%
  summarize(total_arrests = n()) %>%
  ggplot(aes(x = PERP_RACE, y = total_arrests)) +
  geom_bar(stat = 'identity', fill = 'steelblue') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Plot total arrests by age 
nyc_crime2 %>% 
  filter(AGE_GROUP %in% c("25-44","65+","45-64","18-24","<18")) %>%
  group_by(ARREST_YEAR, AGE_GROUP) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot(aes(x=ARREST_YEAR, y = total_arrests, group = AGE_GROUP, color = AGE_GROUP)) + geom_line()

# Plot arrests by gender
nyc_crime2 %>% 
  group_by(PERP_SEX) %>% 
  summarize(total_arrests = n()) %>%
  ggplot(aes(x = PERP_SEX, y = total_arrests)) +  
  geom_bar(stat = 'identity', fill = 'steelblue') +
  theme(axis.text.x = element_text(angle = 0, hjust = 1))

# Pie plot arrests by gender
nyc_crime2 %>% 
  group_by(PERP_SEX) %>%
  summarize(total_arrests = n()) %>%
  ggplot(aes(x = "", y = total_arrests, fill=PERP_SEX)) +  
  geom_bar(stat = 'identity', width=1) +
  coord_polar('y', start=0) +
  theme_void()