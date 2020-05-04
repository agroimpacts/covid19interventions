# install.packages('gsheet')
library(gsheet)
library(dplyr)
library(zoo)

# --DATA LOAD--
# From Google Sheets
# master table with interventions collected by county
master <- gsheet2tbl('https://docs.google.com/spreadsheets/d/1ccGuWTmiX35REcr_JOFOCixNf-GIPII2jS76qxwO2kY/edit#gid=0')
twitter <- gsheet2tbl('https://docs.google.com/spreadsheets/d/15s_bO2TgGo4KPJX8ExNPjluI8E_1Ur8e_IWTde_a2NE/edit#gid=665301748')
# mobility data downloaded from google (as of April 9)
mobility <- read_csv("./data/Global_Mobility_Report.csv")


# --DATA CONVERSION--
# convert date columns for final data load
county_interventions <- master %>% filter(!is.na(SAH_County_Date))
county_interventions$SAH_County_Date = as.Date(county_interventions$SAH_County_Date,
                                               format = '%m/%d/%Y')
county_interventions$SAH_State_Date = as.Date(county_interventions$SAH_State_Date,
                                               format = '%m/%d/%Y')
mobility$date = as.Date(mobility$date, format = '%m/%d/%Y')
# filter data to county level data only
mobility <- mobility %>% filter(!is.na(sub_region_2))
# interpolate for missing workplace mobility data
mobility <- mobility %>%
  group_by(sub_region_1, sub_region_2) %>%
  mutate(workplace_int = na.approx(workplaces_percent_change_from_baseline,
                                   na.rm = FALSE)) %>%
  ungroup()

# --SAVE AS R OBJECT--
usethis::use_data(twitter, overwrite = TRUE)
usethis::use_data(county_interventions, overwrite = TRUE)
usethis::use_data(mobility, overwrite = TRUE)

