# Setup -----
## Packages -----
library(httr)
library(magrittr)

## External Functions -----
source(here("src", "get_max_skip_index.R"))

# Definition -----

get_max_page_number <- function(URL) {
  paste0(URL) %>%
    GET() %>%
    content() %$%
    as.numeric(odata.count) %>%
    get_max_skip_index()
}