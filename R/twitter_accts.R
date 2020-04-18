# Download updated data from google sheets

# install.packages('gsheet')
library(gsheet)

# read data as table from google sheet
twitter <- gsheet2tbl('https://docs.google.com/spreadsheets/d/15s_bO2TgGo4KPJX8ExNPjluI8E_1Ur8e_IWTde_a2NE/edit#gid=665301748')
# save as an .RDS file in the data folder
save(twitter, file = "data/twitter.rda")

# load('data/twitter.rda')
