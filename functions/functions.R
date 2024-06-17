library(tibble)
library(targets)
library(here)
library(DBI)
library(RSQLite)

# Define the URL and destination file path
dest_file <- here("data", "market-orders-latest.v3.csv.bz2")
sql_db <- here("data", "eve_online_market.sqlite3")
url <- "https://data.everef.net/market-orders/market-orders-latest.v3.csv.bz2"
url2 <- "https://www.fuzzwork.co.uk/dump/latest/invTypes.csv.bz2"
dest_file2 <- here("data", "invTypes.csv.bz2")

# Function to download the file with error handling
download_data <- function(dest_file, url) {
  tryCatch(
    {
      download.file(url, dest_file, mode = "wb")
      message("File downloaded successfully to ", dest_file)
    },
    error = function(e) {
      message("An error occurred: ", e$message)
    }
  )
  market_data <- read.csv(dest_file)
  market_data <- as_tibble(market_data)
  return(market_data)
}

# function to write to db
writeto_db <- function(tibble, table_name, database) {
  con <- dbConnect(RSQLite::SQLite(), database)
  dbWriteTable(con, table_name, tibble, overwrite = TRUE)
  db_name <- dbGetInfo(con)$dbname
  db_name <- basename(db_name)
  dbDisconnect(con)
  return(db_name)
}

# run function
market_data <- download_data(dest_file, url)
writeto_db(market_data, "market_data", sql_db)

invtypes <- download_data(dest_file2, url2)
writeto_db(invtypes, "invtypes", sql_db)
