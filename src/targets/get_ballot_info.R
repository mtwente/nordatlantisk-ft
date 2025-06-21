# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(here)

## External Functions -----
source(here("src", "get_content.R"), local = TRUE)
source(here("src", "get_max_page_number.R"), local = TRUE)

# Definition -----

get_ballot_info <- function() {
  
  temp_downloaded_ballot_results <- data.frame()
  
  temp_content_list <- list() # temporäres Element, zu dem je Loop jeweils 100 Stimmvorgänge hinzugefügt werden
  
  max_ballot_page_number <- get_max_page_number("https://oda.ft.dk/api/Afstemning?$inlinecount=allpages&$skip=0")
  
  for (n in seq(0, max_ballot_page_number, 100)) {
    temp_content_ballot_results <- paste0("https://oda.ft.dk/api/Afstemning?$inlinecount=allpages&$skip=", n) %>%
      get_content()
    
    # save ballot results from nested list into temp_content_list, append vector to data frame
    for (i in seq_along(temp_content_ballot_results[[3]])) {
      entry <- temp_content_ballot_results[[3]][[i]]
      
      if (!is.list(entry)) {
        warning("Skipping non-list element at index ", i, " on page ", n)
        next
      }
      
      temp_content_list <- lapply(entry, function(x) if (is.null(x)) NA else x)
      temp_content_df <- as.data.frame(t(unlist(temp_content_list)))
      temp_downloaded_ballot_results <- rbind(temp_downloaded_ballot_results, temp_content_df)
    }
  }
  
  write.csv(temp_downloaded_ballot_results, file = here("data", "raw", "ballot_info_raw.csv"),
            row.names = FALSE)
  
  return(temp_downloaded_ballot_results)
}