# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(here)

## External Functions -----
source(here("src", "get_content.R"), local = TRUE)

# Definition -----

get_meeting_dates <- function(input_df, input_col) {
  
  temp_mødeid_df <- as.data.frame(unique(input_df[[input_col]]))

  temp_dato_df <- data.frame()
  
  for (k in 1:nrow(temp_mødeid_df)) {
    temp_mødeid <- temp_mødeid_df[k, 1]
    
    temp_content_møde <- paste0("https://oda.ft.dk/api/M%C3%B8de(", temp_mødeid,")") %>%
      get_content()
    
    temp_dato_df <- bind_rows(temp_dato_df, temp_content_møde[9])
  }
  
  møder_df <- cbind("mødeid" = temp_mødeid_df, "dato" = temp_dato_df) %>%
    set_colnames(c("mødeid", "dato"))
  
  result_df <- merge(input_df, møder_df,
                             by = "mødeid")
  
  return(result_df)
}