# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(here)
library(purrr)

## External Functions -----
source(here("src", "utils", "get_content.R"), local = TRUE)

# Definition -----

get_meeting_dates <- function(input_df, input_col) {
  
  temp_mødeid_df <- as.data.frame(unique(input_df[[input_col]]))

  temp_dato_df <- map_dfr(
    temp_mødeid_df[[1]],
    function(temp_mødeid) {
      resp <- paste0(
        "https://oda.ft.dk/api/M%C3%B8de(",
        temp_mødeid,
        ")?$select=dato"
      ) %>% get_content()
      
      tibble::tibble(
        mødeid = temp_mødeid,
        dato   = resp$dato
      )
    }
  )
  
  møder_df <- temp_dato_df %>%
    distinct(mødeid, .keep_all = TRUE)
  
  result_df <- input_df %>%
    left_join(møder_df, by = "mødeid")
  
  return(result_df)
}