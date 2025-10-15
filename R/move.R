# Copy figure files to destination directory
# This script copies generated figures to an output location
# Usage: Set FIGURE_DEST environment variable or modify destination_dir below

library(dplyr)
library(here)

# Source configuration
source(here("config.R"))

# List all files in the figure directory
files <- list.files(figure_dir, full.names = TRUE)

if (length(files) == 0) {
  stop("No files found in ", figure_dir)
}

message("Found ", length(files), " files to copy:")
message(paste(basename(files), collapse = "\n"))

# Set destination directory (use environment variable or default)
destination_dir <- Sys.getenv(
  "FIGURE_DEST",
  default = file.path(project_root, "output", "figures")
)

# Create destination directory if it doesn't exist
if (!dir.exists(destination_dir)) {
  dir.create(destination_dir, recursive = TRUE)
  message("Created destination directory: ", destination_dir)
}

# Build full destination paths
destination <- file.path(destination_dir, basename(files))

# Copy files
success <- file.copy(from = files, to = destination, overwrite = TRUE)

# Report results
message(sprintf("Successfully copied %d/%d files to %s", 
                sum(success), length(files), destination_dir))
