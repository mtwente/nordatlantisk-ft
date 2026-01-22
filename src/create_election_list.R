# Setup -----
## Packages -----
library(here)

## Create Data -----

elections <- data.frame(
  election = factor(c(
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
  elections,
  here("data", "processed", "csv", "election_dates.csv"),
  row.names = FALSE
)

saveRDS(
  elections,
  here("data", "processed", "election_dates.rds")
)
