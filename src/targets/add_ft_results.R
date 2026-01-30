# Setup -----
library(httr)
library(dplyr)
library(purrr)
library(tibble)
library(here)
library(strex)

## External Functions -----
source(here("src", "utils", "get_content.R"))

# helper (in case it is not defined elsewhere)
`%||%` <- function(x, y) if (is.null(x)) y else x

# Definition -----
add_ft_results <- function(input_df) {
  
  # ---- Ensure correct columns exist ----
  stopifnot(all(c(
    "id", "nummer", "konklusion", "vedtaget", "kommentar",
    "mødeid", "typeid", "sagstrinid", "opdateringsdato", "dato"
  ) %in% colnames(input_df)))
  
  # ---- Prepare initial dataframe ----
  output_df <- input_df %>%
    mutate(
      ft_for        = NA_integer_,
      ft_against    = NA_integer_,
      ft_abstention = NA_integer_,
      ft_absent     = NA_integer_
    )
  
  # ---- Step 1: Fill counts from konklusion strings ----
  has_results <- !is.na(output_df$konklusion) & output_df$konklusion != ""
  
  output_df$ft_for[has_results]        <- str_nth_number(output_df$konklusion[has_results], n = 1)
  output_df$ft_against[has_results]    <- str_nth_number(output_df$konklusion[has_results], n = 2)
  output_df$ft_abstention[has_results] <- str_nth_number(output_df$konklusion[has_results], n = 3)
  
  # ---- Step 2: load / initialize vote-count cache ----
  cache_path <- here("data", "raw", "ballot_vote_counts_raw.rds")
  
  vote_cache <- if (file.exists(cache_path)) {
    readRDS(cache_path)
  } else {
    tibble(
      id             = integer(0),
      ft_for         = integer(0),
      ft_against     = integer(0),
      ft_abstention  = integer(0)
    )
  }
  
  # ---- Step 3: determine which ballots actually need API calls ----
  missing_ballots <- output_df$id[!has_results]
  missing_ballots <- setdiff(missing_ballots, vote_cache$id)
  
  if (length(missing_ballots) > 0) {
    
    message(
      "Fetching vote counts from API for ",
      length(missing_ballots),
      " previously unprocessed ballots..."
    )
    
    get_counts_for_ballot <- function(ballot_id) {
      
      get_count <- function(typeid) {
        url <- paste0(
          "https://oda.ft.dk/api/Afstemning(", ballot_id, ")/Stemme?",
          "$inlinecount=allpages&$filter=typeid%20eq%20", typeid, "&$top=0"
        )
        parsed <- tryCatch(get_content(url), error = function(e) list(odata.count = 0))
        as.integer(parsed[["odata.count"]] %||% 0)
      }
      
      tibble(
        id             = as.integer(ballot_id),
        ft_for         = get_count(1),
        ft_against     = get_count(2),
        #ft_absent      = get_count(3), calculate below instead of API call
        ft_abstention  = get_count(4)
      )
    }
    
    new_counts <- map_dfr(missing_ballots, get_counts_for_ballot)
    
    # ---- Update cache ----
    vote_cache <- bind_rows(vote_cache, new_counts) %>%
      distinct(id, .keep_all = TRUE)
    
    saveRDS(vote_cache, cache_path)
  }
    
    # ---- Merge API counts back ----

    output_df <- output_df %>%
    left_join(vote_cache, by = "id", suffix = c(".local", ".api")) %>%
      mutate(
        ft_for        = coalesce(ft_for.local, ft_for.api),
        ft_against    = coalesce(ft_against.local, ft_against.api),
        ft_abstention = coalesce(ft_abstention.local, ft_abstention.api),
        #ft_absent     = coalesce(ft_absent.local, ft_absent.api) see below
      ) %>%
      select(-ends_with(".local"), -ends_with(".api"))
  
  # ---- Calculate count of absentees ----
  has_complete_counts <-
    !is.na(output_df$ft_for) &
    !is.na(output_df$ft_against) &
    !is.na(output_df$ft_abstention)
  
  output_df$ft_absent[has_complete_counts] <-
    179L -
    (
      output_df$ft_for[has_complete_counts] +
        output_df$ft_against[has_complete_counts] +
        output_df$ft_abstention[has_complete_counts]
    )
  
  output_df <- output_df %>%
    relocate(ft_absent, .after = ft_abstention)
  
  output_df
}
