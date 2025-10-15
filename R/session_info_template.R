# Session Information Template
# Add this code chunk at the end of your analysis scripts
# to document the computational environment

# Print session information
cat("\n=== Session Information ===\n")
sessionInfo()

# Print R version
cat("\n=== R Version ===\n")
R.version.string

# Print package versions for key packages
cat("\n=== Key Package Versions ===\n")
key_packages <- c(
  "dplyr", "ggplot2", "DESeq2", "tidybulk",
  "biomaRt", "fgsea", "GSVA", "here"
)

for (pkg in key_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("%s: %s\n", pkg, packageVersion(pkg)))
  }
}

# Print system information
cat("\n=== System Information ===\n")
cat(sprintf("System: %s\n", Sys.info()["sysname"]))
cat(sprintf("Release: %s\n", Sys.info()["release"]))
cat(sprintf("Machine: %s\n", Sys.info()["machine"]))

# Save to file (optional)
# writeLines(capture.output(sessionInfo()), "session_info.txt")
