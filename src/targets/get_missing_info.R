# Setup -----
## Packages -----
library(httr)
library(dplyr)
library(here)

## External Functions -----
source(here("src", "get_content.R"), local = TRUE)
source(here("src", "get_max_page_number.R"), local = TRUE)

# Definition -----

get_missing_info <- function(input_df) {
  
  missing_results_df <- input_df %>%
    filter(konklusion == "")
  
  input_df <- input_df %>%
    mutate(ft_for = 0, ft_imod = 0, ft_hverken = 0)
  
  input_df$ft_for[input_df$konklusion != ""] <- NA
  input_df$ft_imod[input_df$konklusion != ""] <- NA
  input_df$ft_hverken[input_df$konklusion != ""] <- NA
  
  for (p in seq_len(nrow(missing_results_df))) {
    
    temp_NAafst_id <- missing_results_df$id[p]
    
    for (q in seq(0, 100, 100)) { # captures all 179 votes spread out on two pages with max. 100 entries each
      temp_NAcontent_results <- paste0("https://oda.ft.dk/api/Afstemning(", temp_NAafst_id, ")/Stemme?$inlinecount=allpages&$skip=", q) %>%
        get_content()
      
      for (z in 1:length(temp_NAcontent_results[[3]])) {
        
        vote_type_id <- temp_NAcontent_results[[3]][[z]][[2]]
        switch(vote_type_id,
               "1" = {input_df[input_df$id == temp_NAafst_id, "ft_for"] <- input_df[input_df$id == temp_NAafst_id, "ft_for"] + 1},
               "2" = {input_df[input_df$id == temp_NAafst_id, "ft_imod"] <- input_df[input_df$id == temp_NAafst_id, "ft_imod"] + 1},
               #"3" = { temp_sum_fravaer <- temp_sum_fravaer + 1 }, implemented in clean_ballot_results(), since this detail is not included in this particular list
               "4" = {input_df[input_df$id == temp_NAafst_id, "ft_hverken"] <- input_df[input_df$id == temp_NAafst_id, "ft_hverken"] + 1}
        )
      }
    }
  }
  return(input_df)
}