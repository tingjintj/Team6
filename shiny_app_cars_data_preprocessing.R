# Load libraries
library(tidyverse)
library(data.table)
library(janitor)

# Import Data
df <- read.csv("https://raw.githubusercontent.com/tingjintj/Team6/main/autoscout24-germany-dataset.csv")

# Drop missing values
df <- df %>% drop_na()

# Check on unique values for each categorical variable, to ensure that there are no doublings etc.
unique(df$make)
unique(df$model)
unique(df$fuel)
unique(df$gear)
unique(df$offerType)
unique(df$year)

# Show samples where df$make is "Caravans-Wohnm"
df %>% filter(make == "Caravans-Wohnm") %>% head()

# Based on research, we know that "Caravans-Wohnm" is a model of "VW". Therefore, 
# we first add "Caravans-Wohnm" as a model in those instances where the make is "Caravans-Wohnm"
# and then add VW as the actual make of those models
df$model[df$make == "Caravans-Wohnm"] <- "Caravans-Wohnm"
df$make[df$make == "Caravans-Wohnm"] <- "VW"

# Show samples where df$make is "Trailer-Anhänger"
df %>% filter(make == "Trailer-Anhänger") %>% head()

# We decide to drop instances with make "Trailer-Anhänger" as they are not 
# relevant for our analysis (they are not cars)
df <- df %>% filter(make != "Trailer-Anhänger")

# Convert categorical values into factors
data_final <- df %>%
  mutate(
    make = factor(make, levels = unique(df$make)),
    model = factor(model, levels = unique(df$model)),
    fuel = factor(fuel, levels = unique(df$fuel)),
    gear = factor(gear, levels = unique(df$gear)),
    offerType = factor(offerType, levels = unique(df$offerType))
  )

save(data_final, file = '/home/ubuntu/data_final.RData') #adjust the path to save the model locally



