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

link_excel_to_db <- function(input) {
  require(googledrive) 
  require(googlesheets4)
  require(here)
  data_base <- here::here("data", "eve_online_market.sqlite3")
  # Authenticate Google Drive
  # Connect to the SQLite database
  con <- DBI::dbConnect(RSQLite::SQLite(), data_base)
  # Read the data from a table in the SQLite database
  db_jita_check <- DBI::dbReadTable(con, "Jita Market Check")
  # Close the connection
  DBI::dbDisconnect(con)
  service_account_key  <- here::here(
                                     "_targets",
                                     "user",
                                     "eveonline",
                                     "eveonlinemarket-430604-84d668275436.json") 
  googlesheets4::gs4_auth(service_account_key)
  # Specify the Google Sheets URL or Sheet ID
  # Write the data frame to the Google Sheet
  #  ss <- gs4_create("market_watcher", sheets = db_aset)
  url <- input
  drv  <-  googlesheets4::gs4_get(url)
  #sheet_write(db_aset, ss = drv, sheet = "aset market")
  sheet_write(db_jita_check, ss = drv, sheet = "Jita Market Check")
}
