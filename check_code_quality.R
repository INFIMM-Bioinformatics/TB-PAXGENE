#!/usr/bin/env Rscript
# Code Quality Check Script
# This script runs various quality checks on the R code

cat("==============================================\n")
cat("  TB-PAXGENE Code Quality Check\n")
cat("==============================================\n\n")

# Check if required packages are installed
required_packages <- c("lintr", "here")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages, repos = "https://cran.rstudio.com")
}

# Load packages
library(lintr)
library(here)

# Define directories to check
dirs_to_check <- c("R", "analysis")
files_to_check <- c("config.R")

# Directories to exclude
exclusions <- list("renv", "renv.lock", ".git", "_site", "_cache", "_files")

cat("1. Running lintr on R scripts...\n")
cat("------------------------------------------\n")

# Lint files
all_issues <- list()

for (dir in dirs_to_check) {
  if (dir.exists(here(dir))) {
    cat(sprintf("Checking %s/\n", dir))
    issues <- lint_dir(
      here(dir),
      exclusions = exclusions,
      linters = linters_with_defaults(
        line_length_linter(120),
        object_name_linter = NULL,
        cyclocomp_linter(complexity_limit = 15),
        commented_code_linter = NULL
      )
    )
    all_issues <- c(all_issues, list(issues))
  }
}

for (file in files_to_check) {
  if (file.exists(here(file))) {
    cat(sprintf("Checking %s\n", file))
    issues <- lint(here(file))
    all_issues <- c(all_issues, list(issues))
  }
}

# Count total issues
total_issues <- sum(sapply(all_issues, length))

cat("\n------------------------------------------\n")
cat(sprintf("Total linting issues: %d\n", total_issues))

if (total_issues > 0) {
  cat("\nSome issues found. Run lintr::lint_dir() for details.\n")
} else {
  cat("\nNo linting issues found! ✓\n")
}

cat("\n==============================================\n")
cat("2. Checking file structure...\n")
cat("------------------------------------------\n")

# Check for required files
required_files <- c(
  "README.md",
  "CONTRIBUTING.md",
  "SETUP.md",
  "config.R",
  "renv.lock",
  ".lintr",
  ".gitignore"
)

for (file in required_files) {
  exists <- file.exists(here(file))
  status <- ifelse(exists, "✓", "✗")
  cat(sprintf("%s %s\n", status, file))
}

cat("\n==============================================\n")
cat("3. Checking R version and key packages...\n")
cat("------------------------------------------\n")

cat(sprintf("R version: %s\n", R.version.string))

key_packages <- c(
  "dplyr", "ggplot2", "DESeq2", "tidybulk",
  "here", "renv", "quarto"
)

for (pkg in key_packages) {
  installed <- requireNamespace(pkg, quietly = TRUE)
  if (installed) {
    version <- packageVersion(pkg)
    cat(sprintf("✓ %s: %s\n", pkg, version))
  } else {
    cat(sprintf("✗ %s: not installed\n", pkg))
  }
}

cat("\n==============================================\n")
cat("4. Code Quality Summary\n")
cat("------------------------------------------\n")

# Calculate quality score
score <- 100
deductions <- 0

# Deduct points for linting issues
if (total_issues > 0) {
  issue_deduction <- min(30, total_issues * 2)
  score <- score - issue_deduction
  deductions <- deductions + issue_deduction
  cat(sprintf("- Linting issues: -%d points (%d issues)\n", issue_deduction, total_issues))
}

# Check for documentation
if (!file.exists(here("CONTRIBUTING.md"))) {
  score <- score - 10
  deductions <- deductions + 10
  cat("- Missing CONTRIBUTING.md: -10 points\n")
}

if (!file.exists(here("SETUP.md"))) {
  score <- score - 5
  deductions <- deductions + 5
  cat("- Missing SETUP.md: -5 points\n")
}

# Check for config management
if (!file.exists(here("config.R"))) {
  score <- score - 10
  deductions <- deductions + 10
  cat("- Missing config.R: -10 points\n")
}

# Check for lintr config
if (!file.exists(here(".lintr"))) {
  score <- score - 5
  deductions <- deductions + 5
  cat("- Missing .lintr: -5 points\n")
}

cat("\n------------------------------------------\n")
cat(sprintf("FINAL QUALITY SCORE: %d/100\n", max(0, score)))
cat("------------------------------------------\n")

if (score >= 90) {
  cat("Grade: A (Excellent) ⭐⭐⭐\n")
} else if (score >= 75) {
  cat("Grade: B (Good) ⭐⭐\n")
} else if (score >= 60) {
  cat("Grade: C (Fair) ⭐\n")
} else {
  cat("Grade: D (Needs Improvement)\n")
}

cat("\n==============================================\n")
cat("Code quality check complete!\n")
cat("==============================================\n\n")

# Return exit code based on score
if (score < 60) {
  quit(status = 1)
} else {
  quit(status = 0)
}
