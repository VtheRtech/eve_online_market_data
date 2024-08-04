library(targets)
library(tarchetypes)
library(here)
library(purrr)

here::i_am("_targets.R")
# another test
# second ish test``
# test commit need a second test
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

url1 <- "https://docs.google.com/spreadsheets/d/107qO9HOfhtj7n7oz19FW0Qk1zAsqfWeF9M8GKsoEQ_w/edit?usp=drive_link"

list(
  tar_target(
    db_path,
    build_a_db(file_path),
    format = "rds"
  ),
  tar_target(
    market_info,
    download_data(here("data", "market-orders-latest.v3.csv.bz2"),
                  "https://data.everef.net/market-orders/market-orders-latest.v3.csv.bz2"),
    format = "rds"
  ),
  tar_target(
    invgroup,
    download_data(here("data", "invGroups.csv.bz2"),
                  "https://www.fuzzwork.co.uk/dump/latest/invGroups.csv.bz2"),
    format = "rds"
  ),
  tar_target(
    invtypes,
    download_data(here("data", "invTypes.csv.bz2"),
                  "https://www.fuzzwork.co.uk/dump/latest/invTypes.csv.bz2" ),
    format = "rds"
  ),
  tar_target(
    staStation,
    download_data(here("data", "staStation.csv.bz2"),
                  "https://www.fuzzwork.co.uk/dump/latest/staStations.csv.bz2" ),
    format = "rds"
  ),
  tar_target(
    invmeta_groups,
    download_data(here("data", "invMetaGroups.csv.bz2"),
                  "https://www.fuzzwork.co.uk/dump/latest/invMetaGroups.csv.bz2" ),
    format = "rds"
  ),
  tar_target(
    invMetaGroups_db,
    writeto_db(invmeta_groups, db_path),
    format = "rds"
  ),
  tar_target(
    invgroup_db,
    writeto_db(invgroup, db_path),
    format = "rds"
  ),
  tar_target(
    inv_types_db,
    writeto_db(invtypes, db_path),
    format = "rds"
  ),
  tar_target(
    station_db,
    writeto_db(staStation, db_path),
    format = "rds"
  ),
  tar_target(
    market_information_db,
    writeto_db(market_info, db_path),
    format = "rds"
  ),
  tar_target(
   write_db_to_excel,
    link_excel_to_db(url1),
    format = "rds"
  )
)
