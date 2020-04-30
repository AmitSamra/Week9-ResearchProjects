# Set wd
setwd("/Users/asamra/dev/R_Project")
# Shows program info
sessionInfo()


# Import CSV and create DF
#install.packages("readr")
library(readr)
nyc_crime <- read_csv("NYPD_Arrests_Data__Historic_.csv")
View(nyc_crime)

# Show summary of data including NA's
summary(nyc_crime)

# Remove all rows with NA's in any column
# Save as new DF
nyc_crime2 <- na.omit(nyc_crime)

# Shows new DF in new tab
View(nyc_crime2)
summary(nyc_crime2)

# Shows object type
# Note a df is a list
typeof(nyc_crime)
typeof(nyc_crime2)

# Change ARREST_DATE from character to date
# Coulmn in nyc_crime2 was replaced
nyc_crime2$ARREST_DATE <- as.Date(nyc_crime2$ARREST_DATE, format = "%m/%d/%Y")

# Check to see if date was changed
nyc_crime2$ARREST_DATE

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

# Count all rows
count(nyc_crime2)

# Group all rows by year column we created and count
count(nyc_crime2, ARREST_YEAR)

# Count rows based on condition
# Shows count of all arrests in 2006
length(which(nyc_crime2$ARREST_YEAR == "2006"))

# Count / Group rows by year and count using plyr
#install.packages("plyr")
library(plyr)
count(nyc_crime2, ARREST_YEAR)
count(nyc_crime2, ARREST_MONTH)
count(nyc_crime2, ARREST_DAY)

# Filter using base R command
df_2006_base <- nyc_crime2[nyc_crime2$ARREST_YEAR == 2006, ]
View(df_2006_base)

# Using dplyr, we can simplify the syntax

# Filter using dplyr and create new df
#install.packages("dplyr")
library(dplyr)
df_2006 <- filter(nyc_crime2, (ARREST_YEAR == 2006))
View(df_2006)

# Filter all rows by condition using dplyr
df_2006_drugs <- filter(nyc_crime2, (ARREST_YEAR == 2006 & KY_CD == 235))
View(df_2006_drugs)

# Install ggplot
#install.packages("ggplot2")
library("ggplot2")

# Plot total drug arrests for all years
nyc_crime2 %>% 
  filter(KY_CD == 235) %>% 
  group_by(ARREST_YEAR) %>% 
  summarize(drug_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = drug_arrests, group = 1 ) ) + geom_line()

# Plot total arrests for all years
nyc_crime2 %>% 
  #filter(KY_CD == 235) %>% 
  group_by(ARREST_YEAR) %>% 
  summarize(drug_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = drug_arrests, group = 1 ) ) + geom_line()

# Plot total drug arrests by year
nyc_crime2 %>% 
  filter(KY_CD == 235) %>% 
  group_by(ARREST_YEAR) %>% 
  summarize(drug_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_YEAR, y = drug_arrests, group = 1) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue')

# Plot total arrrests by borough
nyc_crime2 %>% 
  group_by(ARREST_BORO) %>% 
  summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = ARREST_BORO, y = total_arrests, group = 1) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue')

# Plot total arrrests by month
nyc_crime2 %>% 
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

# Plot total arrrests by month
top10_name %>% 
  group_by(OFNS_DESC) %>% 
  #summarize(total_arrests = n()) %>% 
  ggplot( aes ( x = OFNS_DESC, y = total_arrests, group = 1) ) + 
  geom_bar(stat = 'identity', fill = 'steelblue') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

