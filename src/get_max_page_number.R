# Setup -----
## Packages -----
library(httr)
library(magrittr)

## External Functions -----
source(here("src", "round.R"))

# Definition -----

get_max_page_number <- function(URL) {
  paste0(URL) %>%
    GET() %>%
    content() %$%
    as.numeric(odata.count) %>%
    round_to_hundred()
}