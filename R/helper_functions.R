# Helper Functions for TB-PAXGENE Analysis
# This file contains common utility functions used across analysis scripts

#' Load Gene Expression Data
#'
#' Safely load SummarizedExperiment object with error handling
#'
#' @param filepath Path to the RDS file
#' @return SummarizedExperiment object
#' @export
load_expression_data <- function(filepath) {
  if (!file.exists(filepath)) {
    stop("Expression data file not found: ", filepath)
  }
  
  message("Loading expression data from: ", filepath)
  se <- readRDS(filepath)
  
  message(sprintf("Loaded data: %d genes x %d samples", 
                  nrow(se), ncol(se)))
  
  return(se)
}

#' Load Differential Expression Results
#'
#' Load DESeq2 results with error handling
#'
#' @param filepath Path to the RDS file
#' @return List of DESeq2 results
#' @export
load_deg_results <- function(filepath) {
  if (!file.exists(filepath)) {
    stop("DEG results file not found: ", filepath)
  }
  
  message("Loading DEG results from: ", filepath)
  deg_results <- readRDS(filepath)
  
  return(deg_results)
}

#' Filter Differential Expression Results
#'
#' Filter DESeq2 results by log2 fold change and adjusted p-value
#'
#' @param res DESeq2 results data frame
#' @param log2fc_cutoff Log2 fold change cutoff (default: 1)
#' @param padj_cutoff Adjusted p-value cutoff (default: 0.05)
#' @param direction Direction filter: "up", "down", or "both" (default: "both")
#' @return Filtered results data frame
#' @export
filter_deg_results <- function(res, 
                               log2fc_cutoff = 1, 
                               padj_cutoff = 0.05,
                               direction = "both") {
  
  # Filter by adjusted p-value
  res_filt <- res %>% 
    dplyr::filter(!is.na(padj), padj < padj_cutoff)
  
  # Filter by direction
  if (direction == "up") {
    res_filt <- res_filt %>% dplyr::filter(log2FoldChange > log2fc_cutoff)
  } else if (direction == "down") {
    res_filt <- res_filt %>% dplyr::filter(log2FoldChange < -log2fc_cutoff)
  } else if (direction == "both") {
    res_filt <- res_filt %>% dplyr::filter(abs(log2FoldChange) > log2fc_cutoff)
  } else {
    stop("Invalid direction. Must be 'up', 'down', or 'both'")
  }
  
  message(sprintf("Filtered: %d significant genes (log2FC > %g, padj < %g)", 
                  nrow(res_filt), log2fc_cutoff, padj_cutoff))
  
  return(res_filt)
}

#' Load Gene Sets from MSigDB
#'
#' Load gene sets from Molecular Signatures Database
#'
#' @param subcategory MSigDB subcategory (e.g., "GO:BP", "CP:REACTOME")
#' @param species Species name (default: "Homo sapiens")
#' @return Named list of gene sets
#' @export
load_gene_sets <- function(subcategory, species = "Homo sapiens") {
  
  if (!requireNamespace("msigdbr", quietly = TRUE)) {
    stop("Package 'msigdbr' is required but not installed")
  }
  
  message(sprintf("Loading gene sets: %s for %s", subcategory, species))
  
  gs_df <- msigdbr::msigdbr(
    species = species, 
    subcategory = subcategory
  ) %>% 
    dplyr::group_by(gs_name) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(
      gene_id = purrr::map(data, ~ unique(.x$gene_symbol))
    ) %>% 
    dplyr::select(-data)
  
  gs_list <- gs_df$gene_id
  names(gs_list) <- gs_df$gs_name
  
  message(sprintf("Loaded %d gene sets", length(gs_list)))
  
  return(gs_list)
}

#' Check File Existence
#'
#' Check if required files exist and provide helpful error messages
#'
#' @param files Character vector of file paths
#' @param stop_on_missing Logical, whether to stop if files are missing
#' @return Logical vector indicating which files exist
#' @export
check_files_exist <- function(files, stop_on_missing = TRUE) {
  
  exists <- file.exists(files)
  
  if (!all(exists)) {
    missing_files <- files[!exists]
    msg <- paste("Missing files:\n", paste(missing_files, collapse = "\n"))
    
    if (stop_on_missing) {
      stop(msg)
    } else {
      warning(msg)
    }
  }
  
  return(exists)
}

#' Create Output Directory
#'
#' Create output directory if it doesn't exist
#'
#' @param dir_path Path to directory
#' @param recursive Logical, whether to create parent directories
#' @export
ensure_dir_exists <- function(dir_path, recursive = TRUE) {
  if (!dir.exists(dir_path)) {
    dir.create(dir_path, recursive = recursive)
    message("Created directory: ", dir_path)
  }
  return(invisible(dir_path))
}

#' Save Plot with Standard Settings
#'
#' Save a ggplot object with standard settings
#'
#' @param plot ggplot object
#' @param filename Output filename
#' @param width Width in inches
#' @param height Height in inches
#' @param dpi Resolution in DPI
#' @export
save_plot_standard <- function(plot, filename, 
                               width = 8, height = 6, dpi = 300) {
  
  # Ensure output directory exists
  dir_path <- dirname(filename)
  ensure_dir_exists(dir_path)
  
  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    width = width,
    height = height,
    dpi = dpi
  )
  
  message("Saved plot to: ", filename)
  return(invisible(filename))
}

#' Print Session Info Summary
#'
#' Print a formatted summary of session information
#'
#' @export
print_session_summary <- function() {
  cat("\n=== Session Information ===\n")
  cat(sprintf("R version: %s\n", R.version.string))
  cat(sprintf("Platform: %s\n", R.version$platform))
  cat(sprintf("Date: %s\n", Sys.Date()))
  
  key_packages <- c(
    "dplyr", "ggplot2", "DESeq2", "tidybulk",
    "biomaRt", "fgsea", "GSVA"
  )
  
  cat("\nKey package versions:\n")
  for (pkg in key_packages) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      cat(sprintf("  %s: %s\n", pkg, packageVersion(pkg)))
    }
  }
  
  cat("\n")
}
