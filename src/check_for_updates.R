# Setup -----
library(httr)
library(magrittr)

# Definition -----

check_for_updates <- function(
    count_url,
    ordered_url,
    local_count,
    data_path
) {
  
  # ---- Local file info ----
  if (file.exists(data_path)) {
    mod_date <- file.info(data_path)$mtime
  } else {
    mod_date <- NA
  }
  
  # ---- Online count ----
  first_page <- count_url %>%
    GET() %>%
    content()
  
  total_count <- as.integer(first_page[["odata.count"]])
  
  # ---- Latest update timestamp ----
  ordered_page <- ordered_url %>%
    GET() %>%
    content()
  
  server_last_update <- if (length(ordered_page$value) > 0) {
    as.POSIXct(
      ordered_page$value[[1]]$opdateringsdato,
      format = "%Y-%m-%dT%H:%M:%OS",
      tz = "UTC"
    )
  } else {
    NA
  }
  
  # ---- Comparison logic ----
  count_matches <- !is.na(total_count) && local_count == total_count
  timestamp_up_to_date <-
    !is.na(mod_date) &&
    !is.na(server_last_update) &&
    server_last_update <= mod_date
  
  needs_update <- !(count_matches && timestamp_up_to_date)
  
  list(
    needs_update = needs_update,
    total_count = total_count,
    mod_date = mod_date,
    server_last_update = server_last_update
  )
}
