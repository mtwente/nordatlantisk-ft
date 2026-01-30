# Setup -----
## External Functions -----
source(here("src", "utils", "get_content.R"))

# Definition -----

get_updated_records <- function(base_url) {
  results <- list()
  skip <- 0
  
  repeat {
    page <- paste0(base_url, "&$skip=", skip) %>%
      get_content()
    
    values <- page$value
    if (length(values) == 0) break
    
    results <- c(results, values)
    skip <- skip + length(values)
  }
  
  results
}
