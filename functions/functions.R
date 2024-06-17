# Function to download the file with error handling
download_data <- function(dest_file, url) {
  download.file(url, dest_file, mode = "wb")
  market_data <- read.csv(dest_file)
  market_data <- dplyr::as_tibble(market_data)
  return(market_data)
}

# function to write to db
writeto_db <- function(tibble) {
  table_name <- deparse(substitute(tibble))
  con <- DBI::dbConnect(
    RSQLite::SQLite(),
    here::here("data", "eve_online_market.sqlite3")
  )
  DBI::dbWriteTable(con, table_name, tibble, overwrite = TRUE)
  db_name <- DBI::dbGetInfo(con)$dbname
  db_name <- basename(db_name)
  DBI::dbDisconnect(con)
  return(db_name)
}
