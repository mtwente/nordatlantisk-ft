# Setup -----
## Packages -----
library(here)

# Definition -----

match_party_affiliation <- function(input_df, MP_dates) {
  
  MP_dates <- MP_dates %>%
    mutate(
      MP_id = as.factor(MP_id),
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
    
  return(output_df)
}
