# Setup -----
## Packages -----
library(httr)
library(magrittr)
library(purrr)

## External Functions -----
source(here("src", "utils", "get_local_mtime.R"))
source(here("src", "utils", "format_api_datetime.R"))
source(here("src", "utils", "get_updated_records.R"))

# Definition -----

get_MP_record <- function(MP_id, local_mtime_utc = NULL) {
  
  base_url <- paste0(
    "https://oda.ft.dk/api/Akt%C3%B8r(",
    MP_id,
    ")/Stemme?$inlinecount=allpages"
  )
  
  api_url <- if (!is.null(local_mtime_utc)) {
    paste0(
      base_url,
      "&$filter=opdateringsdato%20gt%20DateTime'",
      format_api_datetime(local_mtime_utc),
      "'"
    )
  } else {
    base_url
  }
  
  entries <- get_updated_records(api_url)
  
  if (length(entries) == 0) {
    return(data.frame())
  }
  
  message("MP ", MP_id, ": fetching ", length(entries), " new or updated votes…")
  
  purrr::map_dfr(
    entries,
    function(entry) {
      tibble::tibble(
        id              = as.integer(entry$id),
        typeid          = as.integer(entry$typeid %||% NA),
        afstemningid    = as.integer(entry$afstemningid %||% NA),
        aktørid         = as.integer(entry$aktørid %||% NA),
        opdateringsdato = as.POSIXct(
          entry$opdateringsdato,
          format = "%Y-%m-%dT%H:%M:%OS",
          tz = "UTC"
        )
      )
    }
  )
}
