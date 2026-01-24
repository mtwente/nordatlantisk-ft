# Definition -----

get_local_vote_count <- function(MP_id, existing_df) {
  if (is.null(existing_df) || nrow(existing_df) == 0) return(0)
  
  sum(existing_df$aktørid == MP_id, na.rm = TRUE)
}