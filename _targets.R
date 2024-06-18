library(targets)
library(tarchetypes)
library(here)
library(purrr)

here::i_am("_targets.R")

# Run the R scripts in the functions/ folder with your custom functions:
tar_source(here("functions", "functions.R"))
options(clustermq.schedular = "multicore")
tar_option_set(
  packages = c(
    "tidyverse",
    "targets",
    "here",
    "DBI",
    "RSQLite"
  ),
  format = "rds"
)

list(
  tar_target(
    db_path,
    build_a_db(file_path),
    format = "rds"
  ),
  tar_target(
    market_info,
    download_data(
      here("data", "market-orders-latest.v3.csv.bz2"),
      "https://data.everef.net/market-orders/market-orders-latest.v3.csv.bz2"
    ),
    format = "rds"
  ),
  tar_target(
    invtypes,
    download_data(
      here("data", "invTypes.csv.bz2"),
      "https://www.fuzzwork.co.uk/dump/latest/invTypes.csv.bz2"
    ),
    format = "rds"
  ),
  tar_target(
    target_list,
    {
      list(
        market_info = market_info,
        invtypes = invtypes
      )
    },
  ),
  tar_target(
    db_writes,
    mapply(writeto_db, target_list, db_path)
  ),
  format = "rds"
)
