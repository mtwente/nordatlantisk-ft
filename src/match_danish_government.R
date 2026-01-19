# Setup -----
## Packages -----
library(dplyr)
library(lubridate)
library(readr)
library(here)

# Definition -----

match_danish_government <- function(
    input_df,
    cabinets_dk_path = here("data", "static", "cabinets_dk.csv")
) {
  
  # Load Danish cabinet timeline
  cabinets_dk <- read_delim(cabinets_dk_path)
  
  # Prepare cabinet timeline
  cabinets_dk <- cabinets_dk %>%
    mutate(
      start = ymd(start),
      end   = ymd(end),
      end   = coalesce(end, Sys.Date())
    )
  
  output_df <- input_df %>%
    rowwise() %>%
    mutate(
      gvt_dk_bloc = {
        cab <- cabinets_dk %>%
          filter(
            ballot_date >= start,
            ballot_date <= end
          )
        
        if (nrow(cab) == 0) {
          NA_character_
        } else {
          cab$bloc[1]
        }
      },
      
      gvt_dk_type = {
        cab <- cabinets_dk %>%
          filter(
            ballot_date >= start,
            ballot_date <= end
          )
        
        if (nrow(cab) == 0) {
          NA_character_
        } else {
          cab$type[1]
        }
      }
    ) %>%
    ungroup()
  
  return(output_df)
}