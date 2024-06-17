build_a_db <- function(file_path) {
  # Define the file path
  file_path <- "data/eve_online_market.sqlite3"
  # Check if the file exists
  if (file.exists(file_path)) {
    cat("The file exists.\n")
    conn <- RSQLite::dbConnect(RSQLite::SQLite(), dbname = file_path)
    db_path <- DBI::dbGetInfo(conn)$dbname
    RSQLite::dbDisconnect(conn)
    return(db_path)
  } else {
    if (!dir.exists(here::here("data"))) {
      dir.create("data", showWarnings = FALSE)
    } else {
      # Create an empty SQLite database
      conn <- RSQLite::dbConnect(RSQLite::SQLite(), dbname = file_path)
      db_path <- DBI::dbGetInfo(conn)$dbname
      RSQLite::dbDisconnect(conn)
      return(db_path)
      # Check if the database file was created successfully
      if (file.exists(file_path)) {
        cat("Empty SQLite3 database created successfully in data directory.\n")
      } else {
        cat("Failed to create SQLite3 database.\n")
      }
      cat("The file does not exist.\n")
    }
  }
}

# Function to download the file with error handling
download_data <- function(dest_file, url) {
  download.file(url, dest_file, mode = "wb")
  market_data <- read.csv(dest_file)
  market_data <- dplyr::as_tibble(market_data)
  return(market_data)
}

# function to write to db
writeto_db <- function(tibble, path) {
  table_name <- deparse(substitute(tibble))
  con <- DBI::dbConnect(
    RSQLite::SQLite(),
    path
  )
  DBI::dbWriteTable(con, table_name, tibble, overwrite = TRUE)
  db_name <- DBI::dbGetInfo(con)$dbname
  db_name <- basename(db_name)
  DBI::dbDisconnect(con)
  return(db_name)
}
