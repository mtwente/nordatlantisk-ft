# Setup -----
## Packages -----
library(httr)
library(here)

## External Functions -----
source(here("src", "utils", "get_content.R"))

# Definition -----

get_updated_records <- function(base_url) {
  results <- list()
  skip <- 0
  
  repeat {
    page <- paste0(base_url, "&$skip=", skip) %>%
      get_content()
    
    # Case 1: Proper OData collection
    if (is.list(page) && !is.null(page$value)) {
      values <- page$value
    }
    # Case 2: Single object returned
    else if (is.list(page) && !is.null(page$id)) {
      values <- list(page)
    }
    # Case 3: Nothing usable
    else {
      break
    }
    
    if (length(values) == 0) break
    
    results <- c(results, values)
    skip <- skip + length(values)
  }
  
  results
}
