library(jsonlite)
library(here)
library(lubridate)

annotate <- function(
    data,
    primary_key = names(data)[1],
    column_description,
    column_datatype,
    license = "https://creativecommons.org/licenses/by-sa/4.0/",
    about_url = "/README.md",
    lang = "en"
) {
  
  # ---- helpers -------------------------------------------------------------
  
  infer_datatype <- function(x) {
    if (is.factor(x) || is.character(x)) {
      list(datatype = "string")
    } else if (is.integer(x)) {
      list(
        datatype = list(
          base = "integer"
        )
      )
    } else if (is.numeric(x)) {
      rng <- range(x, na.rm = TRUE)
      dt <- list(base = "number")
      if (all(is.finite(rng))) {
        dt$minimum <- rng[1]
        dt$maximum <- rng[2]
      }
      list(datatype = dt)
    } else {
      list(datatype = "string")
    }
  }
  
  creator <- list(
    name = "Moritz Twente",
    email = "mtwente@protonmail.com",
    orcid = "0009-0005-7187-9774"
  )
  
  data_r_object <- deparse(substitute(data))
  
  csv_filename <- paste0(data_r_object, ".csv")
  
  csv_path <- paste0(here("data", "processed", "csv", csv_filename))
  
  json_file <- file.path(paste0(csv_path, "-metadata.json"))
  
  # ---- build column schema --------------------------------------------------
  
  if (length(column_description) != ncol(data) || length(column_datatype) != ncol(data)) {
    stop("Lengths of column_description and column_datatype must match number of data columns.")
  }
  
  # Build tableSchema ----
  columns <- lapply(seq_along(colnames(data)), function(i) {
    col_name <- colnames(data)[i]
    list(
      name = col_name,
      titles = col_name,
      `dc:description` = column_description[[i]],
      datatype = column_datatype[[i]]
    )
  })
  
  # ---- assemble CSVW metadata ----------------------------------------------
  
  metadata <- list(
    `@context` = list("http://www.w3.org/ns/csvw", list(`@language` = lang)),
    url = csv_filename,
    `dc:title` = data_r_object,
    `dc:isPartOf` = "nordatlantisk-ft",
    `dc:creator` = creator,
    `dc:modified` = list(`@value` = format(file.info(csv_path)$mtime, "%Y-%m-%dT%H:%M:%S%z"), `@type` = "xs:dateTime"),
    `dc:type` = "Dataset",
    `dc:format` = "text/csv",
    `dc:license` = license,
    tableSchema = list(
      aboutUrl = about_url,
      columns = columns,
      primaryKey = primary_key
    ),
    dialect = list(
      delimiter = ",",
      quoteChar = "\"",
      encoding = "UTF-8"
    )
  )
  
  # ---- write JSON -----------------------------------------------------------
  
  toJSON(metadata, auto_unbox = TRUE) |>
    prettify() |>
    write(json_file)
  
  invisible(metadata)
}
