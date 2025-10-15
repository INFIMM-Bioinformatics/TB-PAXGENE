#!/usr/bin/env Rscript
# Data Validation Script
# This script validates the presence and integrity of required data files

library(here)

cat("==============================================\n")
cat("  TB-PAXGENE Data Validation\n")
cat("==============================================\n\n")

# Source configuration
if (file.exists(here("config.R"))) {
  source(here("config.R"))
  cat("✓ Configuration loaded\n\n")
} else {
  cat("✗ config.R not found\n")
  stop("Please create config.R first")
}

# Check directory structure
cat("1. Checking directory structure...\n")
cat("------------------------------------------\n")

required_dirs <- c(
  "data",
  "analysis",
  "R"
)

for (dir in required_dirs) {
  dir_path <- here(dir)
  exists <- dir.exists(dir_path)
  status <- ifelse(exists, "✓", "✗")
  cat(sprintf("%s %s/\n", status, dir))
}

# Check data directories
cat("\n2. Checking data directories...\n")
cat("------------------------------------------\n")

data_dirs <- c(
  "data/fastq" = fastq_dir,
  "data/figure" = figure_dir,
  "data/reference" = reference_dir
)

for (name in names(data_dirs)) {
  path <- data_dirs[[name]]
  exists <- dir.exists(path)
  status <- ifelse(exists, "✓", "✗")
  cat(sprintf("%s %s\n", status, name))
  
  if (exists && name == "data/fastq") {
    # Count FASTQ files
    fastq_files <- list.files(path, pattern = "\\.fastq\\.gz$")
    cat(sprintf("   Found %d FASTQ files\n", length(fastq_files)))
  }
}

# Check reference files
cat("\n3. Checking reference genome files...\n")
cat("------------------------------------------\n")

ref_files <- c(
  "Reference FASTA" = reference_fasta,
  "Reference GTF" = reference_gtf
)

for (name in names(ref_files)) {
  path <- ref_files[[name]]
  exists <- file.exists(path)
  status <- ifelse(exists, "✓", "✗")
  cat(sprintf("%s %s\n", status, name))
  
  if (exists) {
    size <- file.size(path)
    size_mb <- round(size / 1024^2, 1)
    cat(sprintf("   Size: %s MB\n", size_mb))
  } else {
    cat(sprintf("   Path: %s\n", path))
  }
}

# Check intermediate data files
cat("\n4. Checking intermediate data files...\n")
cat("------------------------------------------\n")

data_files <- c(
  "Gene data" = here("data", "gene_data.rds"),
  "Expression data" = here("data", "se_pcoding_scale_abundant_filtS.rds"),
  "Salmon counts" = here("data", "salmon.merged.gene_counts.tsv"),
  "Nextflow input" = here("data", "nextflow_input.csv")
)

existing_files <- 0
total_files <- length(data_files)

for (name in names(data_files)) {
  path <- data_files[[name]]
  exists <- file.exists(path)
  status <- ifelse(exists, "✓", "✗")
  cat(sprintf("%s %s\n", status, name))
  
  if (exists) {
    existing_files <- existing_files + 1
  }
}

# Check DEG results
cat("\n5. Checking analysis results...\n")
cat("------------------------------------------\n")

deg_dir <- here("data", "DElist")
if (dir.exists(deg_dir)) {
  deg_files <- list.files(deg_dir, pattern = "\\.rds$")
  cat(sprintf("✓ DEG results directory exists\n"))
  cat(sprintf("   Found %d DEG result files\n", length(deg_files)))
} else {
  cat("✗ DEG results directory not found\n")
  cat("   (Will be created during analysis)\n")
}

figure_check_dir <- here("data", "figure")
if (dir.exists(figure_check_dir)) {
  figure_files <- list.files(figure_check_dir)
  cat(sprintf("✓ Figure directory exists\n"))
  cat(sprintf("   Found %d figure files\n", length(figure_files)))
} else {
  cat("✗ Figure directory not found\n")
  cat("   (Will be created during analysis)\n")
}

# Summary
cat("\n==============================================\n")
cat("Summary\n")
cat("------------------------------------------\n")
cat(sprintf("Intermediate data files: %d/%d present\n", existing_files, total_files))

if (existing_files == 0) {
  cat("\nStatus: Ready for initial analysis\n")
  cat("Next steps:\n")
  cat("1. Place FASTQ files in data/fastq/\n")
  cat("2. Download reference genome files\n")
  cat("3. Run analysis/0_generate_nextflow_input.R\n")
  cat("4. Run RNA-seq mapping pipeline\n")
} else if (existing_files < total_files) {
  cat("\nStatus: Partial analysis complete\n")
  cat("Next steps: Continue with remaining analysis scripts\n")
} else {
  cat("\nStatus: All data files present\n")
  cat("Ready for downstream analysis and visualization\n")
}

cat("==============================================\n\n")
