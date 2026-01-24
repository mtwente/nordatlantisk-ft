# Definition -----

needs_update_ballot_info <- function(data_path) {
  
  if (!file.exists(data_path)) {
    return(TRUE)
  }
  
  local_mtime <- file.info(data_path)$mtime
  
  ordered_url <- paste0(
    "https://oda.ft.dk/api/Afstemning?",
    "$orderby=opdateringsdato%20desc&$top=1"
  )
  
  response <- ordered_url %>%
    GET() %>%
    content()
  
  if (length(response$value) == 0) {
    return(FALSE)
  }
  
  server_last_update <- as.POSIXct(
    response$value[[1]]$opdateringsdato,
    format = "%Y-%m-%dT%H:%M:%OS",
    tz = "UTC"
  )
  
  server_last_update > local_mtime
}
