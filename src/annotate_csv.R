library(jsonlite)
library(here)
library(lubridate)

annotate <- function(
    data,
    dataset_description,
    primary_key = names(data)[1],
    column_title,
    column_description,
    license = "https://creativecommons.org/licenses/by-sa/4.0/",
    about_url = "/README.md",
    lang = "en"
    ) {
  
  # ---- paths ---------------------------------------------------------------
  
  data_r_object <- deparse(substitute(data))
  csv_filename <- paste0(data_r_object, ".csv")
  csv_path <- paste0(here("data", "processed", "csv", csv_filename))
  json_file <- file.path(paste0(csv_path, "-metadata.json"))
  
  # ---- validation ----------------------------------------------------------
  
  if (length(column_description) != ncol(data)) {
    stop("Length of column_description must match number of data columns.")
  }
  
  # ---- creator metadata ----------------------------------------------------
  
  creator <- list(
    name = "Moritz Twente",
    email = "mtwente@protonmail.com",
    orcid = "0009-0005-7187-9774"
  )
  
  # ---- datetype ------------------------------------------------------------
  
  infer_datatype <- function(x) {
    
    # Date (yyyy-MM-dd) with range
    if (inherits(x, "Date")) {
      rng <- range(x, na.rm = TRUE)
      
      dt <- list(
        base = "date",
        format = "yyyy-MM-dd"
      )
      
      if (all(is.finite(rng))) {
        dt$minimum <- format(rng[1], "%Y-%m-%d")
        dt$maximum <- format(rng[2], "%Y-%m-%d")
      }
      
      return(dt)
    }
    
    # Datetime with range
    if (inherits(x, c("POSIXct", "POSIXt"))) {
      rng <- range(x, na.rm = TRUE)
      
      dt <- list(
        base = "dateTime",
        format = "yyyy-MM-dd'T'HH:mm:ss"
      )
      
      if (all(is.finite(rng))) {
        dt$minimum <- format(rng[1], "%Y-%m-%dT%H:%M:%S")
        dt$maximum <- format(rng[2], "%Y-%m-%dT%H:%M:%S")
      }
      
      return(dt)
    }
    
    # Boolean
    if (is.logical(x)) {
      return("boolean")
    }
    
    # Character
    if (is.character(x)) {
      return("string")
    }
    
    # Factor
    if (is.factor(x)) {
      return("factor")
    }
    
    # Integer
    if (is.integer(x)) {
      return(list(base = "integer"))
    }
    
    # Numeric with range
    if (is.numeric(x)) {
      rng <- range(x, na.rm = TRUE)
      dt <- list(base = "number")
      
      if (all(is.finite(rng))) {
        dt$minimum <- rng[1]
        dt$maximum <- rng[2]
      }
      return(dt)
    }
    
    # Fallback
    "string"
  }
  
  # ---- build column schema --------------------------------------------------

  columns <- lapply(seq_along(colnames(data)), function(i) {
    col_name <- colnames(data)[i]
    
    list(
      name = col_name,
      `dc:title` = column_title[[i]],
      `dc:description` = column_description[[i]],
      datatype = infer_datatype(data[[i]])
    )
  })
  
  # ---- assemble CSVW metadata ----------------------------------------------
  
  metadata <- list(
    `@context` = list(
      "http://www.w3.org/ns/csvw",
      list(`@language` = lang)
    ),
    url = csv_filename,
    `dc:title` = data_r_object,
    `dc:isPartOf` = "nordatlantisk-ft",
    `dc:creator` = creator,
    `dc:description` = dataset_description,
    `dc:modified` = list(
      `@value` = format(
        file.info(csv_path)$mtime,
        "%Y-%m-%dT%H:%M:%S%z"
      ),
      `@type` = "xs:dateTime"
    ),
    `dc:type` = "Dataset",
    `dc:format` = "text/csv",
    `dc:license` = list(`@id` = license),
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
