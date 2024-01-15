# Setup -----
## Packages -----
library(httr)
library(magrittr)

# Definition -----

get_content <- function(URL) {
  paste0(URL) %>%
    GET() %>%
    content()
}