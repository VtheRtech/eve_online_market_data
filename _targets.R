library(targets)
library(tarchetypes)
library(here)


source(here("functions", "functions.R"))
options(clustermq.schedular = "multicore")
tar_option_set(
  packages = c("tibble", "here"),
  format = "qs"
)
# Set other options as needed.


# Run the R scripts in the R/ folder with your custom functions:
tar_source()
tar_source("other_functions.R")

# Replace the target list below with your own:
list(
  tar_target(
    model,
    command = coefficients(lm(y ~ x, data = data))
  )
)
