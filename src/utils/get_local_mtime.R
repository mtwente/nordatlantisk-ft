# Definition -----

get_local_mtime <- function(local_path) {
  if (!file.exists(local_path)) return(NULL)
  
  as.POSIXct(
    file.info(local_path)$mtime,
    tz = "UTC"
  )
}
