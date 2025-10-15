# Generate Nextflow Input Samplesheet
# This script creates the samplesheet required by nf-core/rnaseq pipeline
# The samplesheet format includes: sample, fastq_1, fastq_2, strandedness

# Load required libraries
library(dplyr)
library(stringr)
library(tibble)
library(here)

# Source configuration
source(here("config.R"))

# List all FASTQ files in the data directory
fastq <- list.files(fastq_dir, pattern = "*.fastq.gz$")

if (length(fastq) == 0) {
  stop("No FASTQ files found in ", fastq_dir, 
       ". Please ensure FASTQ files are in the correct directory.")
}

# Generate samplesheet
# Nextflow requires: sample, fastq_1, fastq_2, strandedness
samplesheet <- 
  tibble(
    sample = fastq %>% 
      str_extract("\\w{6}-\\d{4}-\\d{2}-\\d{2}") %>% 
      unique(),
    fastq_1 = file.path(fastq_dir, paste0(sample, "_R1_001.fastq.gz")),
    fastq_2 = file.path(fastq_dir, paste0(sample, "_R2_001.fastq.gz")),
    strandedness = "auto"
  )

# Validate that files exist
files_exist <- c(samplesheet$fastq_1, samplesheet$fastq_2) %>% 
  file.exists() %>% 
  mean()

message(sprintf("%.1f%% of expected FASTQ files exist", files_exist * 100))

if (files_exist < 1) {
  warning("Some FASTQ files are missing. Check the fastq_dir path in config.R")
}

# Write samplesheet
output_file <- file.path(data_dir, "nextflow_input.csv")
readr::write_csv(samplesheet, output_file)
message("Samplesheet written to: ", output_file)
