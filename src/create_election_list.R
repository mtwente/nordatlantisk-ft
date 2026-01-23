# Setup -----
## Packages -----
library(here)

## External Functions -----
source(here("src", "annotate_csv.R"), local = TRUE)

## Create Data -----

election_dates <- data.frame(
  
  election = c(
    "ft_2001", "ft_2005", "ft_2007", "ft_2011",
    "ft_2015", "ft_2019", "ft_2022",
    
    "ina_2002", "ina_2005", "ina_2009", "ina_2013",
    "ina_2014", "ina_2018", "ina_2021", "ina_2025",
    
    "lt_2004", "lt_2008", "lt_2011", "lt_2015",
    "lt_2019", "lt_2022"
  ),
  
  election_type = factor(c(
    rep("Folketing Election", 7),
    rep("Inatsisartut Election", 8),
    rep("Løgting Election", 6)
    
  )),
  date = as.Date(c(
    
    ## Folketing
    "2001-11-20",
    "2005-02-08",
    "2007-11-13",
    "2011-09-15",
    "2015-06-18",
    "2019-06-05",
    "2022-11-01",
    
    ## Inatsisartut
    "2002-12-03",
    "2005-11-15",
    "2009-06-02",
    "2013-03-12",
    "2014-11-28",
    "2018-04-24",
    "2021-04-06",
    "2025-03-11",
    
    ## Løgting
    "2004-01-20",
    "2008-01-19",
    "2011-10-28",
    "2015-09-01",
    "2019-08-31",
    "2022-12-08"
  ))
  )

## Export -----

write.csv(
  election_dates,
  here("data", "processed", "csv", "election_dates.csv"),
  row.names = FALSE
)

saveRDS(
  election_dates,
  here("data", "processed", "election_dates.rds")
)

## Metadata -----

annotate_csv(election_dates,
         dataset_description = "This repository is shipped with a list of all elections to the parliaments in Denmark (Folketinget), Greenland (Inatsisartut) and the Faroe Islands (Løgtingið) that led to the formation of the parliaments in session during the time period covered by this data set. Refer to the documentation for more details.",
         column_title = c(
           "Election",
           "Type of Election",
           "Date of Election"
           ),
         column_description = c(
           "Each recorded election can be reliably identified by using the unique `election` variable",
           "The `election_dates` dataset includes elections to three different parliaments: Danish Folketinget, Greenlandic Inatsisartut and Faroese Løgtingið. To distinguish between elections, the type of election is stored in `election_dates$election_type`.",
           "The date of each election is stored in `election_dates$date`, indicating the day of voting")
         )