# Setup -----
## Packages -----
library(here)

# Definition -----

render_codebook <- function() {
  
  path_to_Rmd <- paste0(here("docs", "codebook.Rmd"))
  
  render(path_to_Rmd, "all")
  
}