# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble", "dplyr", "ggplot2", "here", "httr", "magrittr", "purrr", "strex", "rmarkdown") # packages that your targets need to run
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  #   controller = crew::crew_controller_local(workers = 2)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package. The following
  # example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     workers = 50,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.0".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multicore")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the ~~R/~~ functions/targets/ folder with your custom functions:
tar_source(files = "src/targets")
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:

tar_plan(
  
  tar_target(
    MP_names_file,
    here("data", "processed", "MP_names.rds"),
    format = "file"
  ),
  
  MP_names = readRDS(MP_names_file),
  
  tar_target(
    name = raw_voting_records,
    command = get_voting_records(MP_names),
    cue = tar_cue_age(
      name = cleaned_voting_records,
      age = as.difftime(12, units = "weeks")
    )
  ),
  
  cleaned_voting_records = clean_voting_records(raw_voting_records),
  
  tar_target(
    name = ballot_info,
    command = get_ballot_info(),
    cue = tar_cue_age(
      name = cleaned_ballot_results,
      age = as.difftime(12, units = "weeks")
    )
  ),

  ballot_info_with_dates = get_meeting_dates(ballot_info, "mødeid"),
  
  raw_ballot_results = get_missing_info(ballot_info_with_dates),
  
  cleaned_ballot_results = clean_ballot_results(raw_ballot_results),
  
  northatlantic_ft = join_results(cleaned_voting_records, cleaned_ballot_results, MP_names),
  
  #codebook = render_codebook()
)