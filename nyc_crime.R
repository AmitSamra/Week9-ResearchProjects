setwd("/Users/asamra/dev/R_Project")


# Import CSV and create DF
library(readr)
nyc_crime <- read_csv("NYPD_Arrests_Data__Historic_.csv")
View(nyc_crime)

# Show summary of data including NA's
summary(nyc_crime)

# Remove all rows with NA's in any column
# Save as new DF
nyc_crime2 <- na.omit(nyc_crime)

# Shows object type
typeof(nyc_crime)
typeof(nyc_crime2)

# Shows new DF in new tab
View(nyc_crime2)
summary(nyc_crime2)

# Change ARREST_DATE from character to date
# Coulmn in nyc_crime2 was replaced
nyc_crime2$ARREST_DATE <- as.Date(nyc_crime2$ARREST_DATE, format = "%m/%d/%Y")

# Check to see if date was changed
nyc_crime2$ARREST_DATE

# Check to see if date was changed
summary(nyc_crime2)
