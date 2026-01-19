# Setup -----
## Packages -----
library(dplyr)

# Definition -----

match_home_government <- function(input_df,
                                  cabinets_fo_gl_path = here("data", "processed", "cabinets_fo_gl.csv")) {
  
  # Load cabinet dates
  cabinets_fo_gl <- read_delim(cabinets_fo_gl_path)
  
  # Prepare cabinet timeline
  cabinets_fo_gl <- cabinets_fo_gl %>%
    mutate(
      start = ymd(start),
      end   = ymd(end),
      end   = coalesce(end, Sys.Date())
    )
  
  output_df <- input_df %>%
    rowwise() %>%
    mutate(
      gvt_party_at_home = {
        
        cab <- cabinets_fo_gl %>%
          filter(
            location == origin,
            ballot_date >= start,
            ballot_date <= end
          )
        
        if (nrow(cab) == 0) {
          FALSE
        } else {
          party_col <- paste0(origin, "_", party)
          
          if (!party_col %in% names(cab)) {
            FALSE
          } else {
            isTRUE(cab[[party_col]][1])
          }
        }
      }
    ) %>%
    ungroup()

  return(output_df)
}
