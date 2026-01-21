# Setup -----
## Packages -----
library(here)

## Create Data -----

elections <- data.frame(
  election = factor(c(
    rep("General Election", 7)
  )),
  date = as.Date(c(
    "2001-11-20",
    "2005-02-08",
    "2007-11-13",
    "2011-09-15",
    "2015-06-18",
    "2019-06-05",
    "2022-11-01"
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
