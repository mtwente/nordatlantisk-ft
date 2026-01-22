# Setup -----
## Packages -----
library(dplyr)
library(here)
library(readr)

match_party_affiliation <- function(input_df,
                                  mp_dates_path = here("data", "processed", "MP_dates.rds")) {
  
  # Load MP_dates
  MP_dates <- readRDS(mp_dates_path)
  
  # Prepare MP_dates
  MP_dates <- MP_dates %>%
    mutate(
      MP_id = as.factor(MP_id),
      # replace current MPs' end dates with Sys.Date:
      end = coalesce(end, Sys.Date())
    ) %>%
    select(MP_id, start, end, party)
  
  output_df <- input_df %>%
    mutate(
      MP_id = as.factor(MP_id),
      ballot_date = as.Date(ballot_date)
    ) %>%
    left_join(MP_dates, by = "MP_id") %>%
    filter(ballot_date >= start & ballot_date <= end) %>%
    select(-start, -end) %>%
    mutate(party = factor(party)) %>%
    relocate(party, .after = surname)
  
  return (output_df)
}