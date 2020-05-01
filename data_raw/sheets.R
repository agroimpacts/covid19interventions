# Download updated data from google sheets

# install.packages('gsheet')
library(gsheet)

# read data as table from google sheets
twitter <- gsheet2tbl('https://docs.google.com/spreadsheets/d/15s_bO2TgGo4KPJX8ExNPjluI8E_1Ur8e_IWTde_a2NE/edit#gid=665301748')
# master <- gsheet2tbl('https://docs.google.com/spreadsheets/d/1qg5SG9dqgJof7dYQREGEhLYgLhd2hApm1i7jkbrkStk/edit#gid=0')

# mobility data
mobility <- read_csv("./data/Global_Mobility_Report.csv")
mobility$date = as.Date(mobility$date, format = '%m/%d/%Y')
# filter data to county level data only
mobility <- mobility %>% filter(!is.na(sub_region_2))


# Save as .rds
usethis::use_data(twitter, overwrite = TRUE)
# usethis::use_data(master, overwrite = TRUE)
usethis::use_data(mobility, overwrite = TRUE)

