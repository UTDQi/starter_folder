#### Preamble ####
# Purpose: Clean the downloaded data for further use
# Author: David Qi
# Date: 26 September 2024
# Contact: david.qi@mail.utoronto.ca
# License: MIT
# Pre-requisites: simulated data ready in "data/raw_data/fire_incidents_data_raw.csv"
# Any other information needed? None.

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
raw_data <- read_csv("data/raw_data/fire_incidents_data_raw.csv")

# keep only the columns we want
cleaned_data = raw_data %>% select(Estimated_Dollar_Loss,Number_of_responding_personnel,Possible_Cause,TFS_Alarm_Time,Civilian_Casualties)

# data for dollar loss vs responding personnel graph
cleaned_data_personnel_dollarloss = cleaned_data %>% select(Estimated_Dollar_Loss,Number_of_responding_personnel) %>% drop_na()

# data for Civilian_Casualties vs responding personnel graph
cleaned_data_personnel_casualties = cleaned_data %>% select(Civilian_Casualties,Number_of_responding_personnel) %>% drop_na()

#data for time of event 

  # select relevant column, remove missing entries 
  cleaned_data_year = cleaned_data %>% select(TFS_Alarm_Time) %>% drop_na()

  # Create a new column `Year` to store the year of each incident
  cleaned_data_year <- cleaned_data_year %>%
    mutate(Year = format(TFS_Alarm_Time, "%Y"))
  
# data for dollar loss
  cleaned_data_dollar_loss = analysis_data %>% select(Estimated_Dollar_Loss) %>% drop_na()

# data for causes
  cleaned_data_cause = analysis_data %>% select(Possible_Cause) %>% drop_na()
  
# data for the graph that list average dollar loss and Civilian Casualties for each possible cause
  cleaned_data_fire_cause_compare <- analysis_data %>%  select(Estimated_Dollar_Loss,Possible_Cause,Civilian_Casualties) %>%
    drop_na() %>%
    group_by(Possible_Cause) %>%
    summarise(Avg_Dollar_Loss = mean(Estimated_Dollar_Loss, na.rm = TRUE),
              Count = n(),
              Avg_Civilian_Casualties = mean(Civilian_Casualties, na.rm = TRUE)) %>%
    arrange(desc(Count))  # Sort by count in descending order
  

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/fire_incidents_data_general.csv")
write_csv(cleaned_data_personnel_dollarloss, "data/analysis_data/fire_incidents_data_respondPersonnel_Dollar_loss.csv")
write_csv(cleaned_data_year, "data/analysis_data/fire_incidents_data_time.csv")
write_csv(cleaned_data_dollar_loss, "data/analysis_data/fire_incidents_data_dollar_loss.csv")
write_csv(cleaned_data_dollar_loss, "data/analysis_data/fire_incidents_data_possible_cause.csv")
write_csv(cleaned_data_fire_cause_compare , "data/analysis_data/fire_incidents_data_cause_compare.csv")
write_csv(cleaned_data_personnel_casualties, "data/analysis_data/fire_incidents_data_respondPersonnel_Casualties.csv")