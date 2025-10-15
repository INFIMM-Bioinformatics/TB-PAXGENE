# Configuration file for TB-PAXGENE project
# This file contains all configurable paths and parameters

# Project root directory (auto-detected)
project_root <- here::here()

# Data directories
data_dir <- file.path(project_root, "data")
fastq_dir <- file.path(data_dir, "fastq")
output_dir <- file.path(data_dir, "nextflow_outputdir")
figure_dir <- file.path(data_dir, "figure")

# Reference genome paths (update these for your system)
# Default to relative paths within project
reference_dir <- Sys.getenv(
  "REFERENCE_DIR",
  default = file.path(data_dir, "reference")
)

reference_fasta <- Sys.getenv(
  "REFERENCE_FASTA",
  default = file.path(
    reference_dir,
    "Macaca_fascicularis.Macaca_fascicularis_6.0.dna_rm.toplevel.fa.gz"
  )
)

reference_gtf <- Sys.getenv(
  "REFERENCE_GTF",
  default = file.path(
    reference_dir,
    "Macaca_fascicularis.Macaca_fascicularis_6.0.109.gtf.gz"
  )
)

# Nextflow parameters
nextflow_version <- "3.12.0"
max_cpus <- as.integer(Sys.getenv("MAX_CPUS", default = "40"))
max_memory <- Sys.getenv("MAX_MEMORY", default = "170GB")

# Analysis parameters
n_variable_genes_pca <- 1500
log2fc_cutoff <- 1
padj_cutoff <- 0.05
