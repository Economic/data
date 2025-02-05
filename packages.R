library(targets)
library(tarchetypes)

# conflicts and other options
library(conflicted)
conflict_prefer("filter", "dplyr", quiet = TRUE)
conflict_prefer("zip", "zip", quiet = TRUE)

options(usethis.quiet = TRUE)

# packages for this analysis
suppressPackageStartupMessages({
  library(tidyverse)
  library(arrow)
  library(zip)
  library(janitor)
  library(fs)
})