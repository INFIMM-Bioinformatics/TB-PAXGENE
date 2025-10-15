# Setup Guide for TB-PAXGENE Analysis

This guide will help you set up the TB-PAXGENE analysis environment on your system.

## System Requirements

- **Operating System**: Linux, macOS, or Windows (with WSL2 recommended)
- **RAM**: Minimum 16 GB (32+ GB recommended for full analysis)
- **Storage**: At least 100 GB free space for data and results
- **CPU**: Multi-core processor (8+ cores recommended)

## Software Prerequisites

### 1. Install R and RStudio

**R Version**: 4.3.2 or higher

- **Linux**:
  ```bash
  # Ubuntu/Debian
  sudo apt-get update
  sudo apt-get install r-base r-base-dev
  
  # CentOS/RHEL
  sudo yum install R
  ```

- **macOS**:
  Download from [CRAN](https://cran.r-project.org/bin/macosx/)

- **Windows**:
  Download from [CRAN](https://cran.r-project.org/bin/windows/base/)

**RStudio** (recommended):
Download from [RStudio website](https://posit.co/download/rstudio-desktop/)

### 2. Install System Dependencies

**Linux** (Ubuntu/Debian):
```bash
sudo apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libfontconfig1-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  libfreetype6-dev \
  libpng-dev \
  libtiff5-dev \
  libjpeg-dev
```

**macOS**:
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install openssl libxml2 harfbuzz fribidi freetype libpng jpeg libtiff
```

### 3. Install Nextflow (for RNA-seq mapping)

```bash
# Install Java (required for Nextflow)
# Ubuntu/Debian
sudo apt-get install default-jdk

# macOS
brew install openjdk

# Install Nextflow
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/
```

### 4. Install Singularity/Apptainer (for containerized workflows)

**Linux**:
Follow instructions at [Apptainer documentation](https://apptainer.org/docs/admin/main/installation.html)

**macOS/Windows**:
Consider using Docker as an alternative or setting up a Linux VM

## Project Setup

### 1. Clone the Repository

```bash
git clone https://github.com/INFIMM-Bioinformatics/TB-PAXGENE.git
cd TB-PAXGENE
```

### 2. Initialize R Environment

Open R or RStudio in the project directory:

```R
# The .Rprofile will automatically activate renv
# Restore all R packages
renv::restore()

# This may take 15-30 minutes depending on your system
```

If you encounter issues:
```R
# Try installing renv manually first
install.packages("renv")
renv::restore()
```

### 3. Configure Paths

Edit `config.R` to set paths for your system:

```R
# Option 1: Edit config.R directly
# Update these variables:
# - reference_fasta
# - reference_gtf
# - fastq_dir

# Option 2: Use environment variables (recommended for shared systems)
# Add to your ~/.bashrc or ~/.zshrc:
export REFERENCE_DIR="/path/to/reference/genomes"
export REFERENCE_FASTA="$REFERENCE_DIR/Macaca_fascicularis.fa.gz"
export REFERENCE_GTF="$REFERENCE_DIR/Macaca_fascicularis.gtf.gz"
export MAX_CPUS=40
export MAX_MEMORY="170GB"
```

### 4. Download Reference Genome (if needed)

```bash
# Create reference directory
mkdir -p data/reference

# Download Macaca fascicularis genome
wget -P data/reference \
  https://ftp.ensembl.org/pub/release-109/fasta/macaca_fascicularis/dna/Macaca_fascicularis.Macaca_fascicularis_6.0.dna_rm.toplevel.fa.gz

# Download GTF annotation
wget -P data/reference \
  https://ftp.ensembl.org/pub/release-109/gtf/macaca_fascicularis/Macaca_fascicularis.Macaca_fascicularis_6.0.109.gtf.gz
```

### 5. Verify Installation

```R
# Check if key packages are installed
library(dplyr)
library(ggplot2)
library(DESeq2)
library(tidybulk)

# Print session info
sessionInfo()
```

## Running the Analysis

### Full Pipeline

Follow the analysis pipeline in order:

1. **Generate Nextflow input**:
   ```R
   source("analysis/0_generate_nextflow_input.R")
   ```

2. **RNA-seq mapping** (requires HPC or powerful workstation):
   ```bash
   # See analysis/1_data_processing.qmd for details
   bash analysis/1_RNA_SEQ_MAPPING.sh
   ```

3. **Data cleaning and QC**:
   Open `analysis/3_cleaning_qc_pca_analysis.qmd` in RStudio and render

4. **Differential expression analysis**:
   Open `analysis/4_DGE_analysis.qmd` in RStudio and render

5. **Pathway enrichment**:
   Open `analysis/5_vacc_pre_pathway_enrichment.qmd` in RStudio and render

6. **Correlation analysis**:
   Open `analysis/6_correlation_late_response.qmd` in RStudio and render

### Render All Analysis Documents

```R
# Using quarto
quarto::quarto_render("analysis/")
```

## Troubleshooting

### Common Issues

1. **renv::restore() fails**:
   ```R
   # Try updating renv
   renv::upgrade()
   
   # Or install packages individually
   install.packages("package_name")
   ```

2. **Missing system libraries**:
   - Check error messages for library names
   - Install using your system package manager
   - See system dependencies section above

3. **Memory issues**:
   - Increase R memory limit:
     ```R
     # Windows
     memory.limit(size=32000)
     
     # Unix-like systems: edit ~/.Renviron
     R_MAX_VSIZE=32Gb
     ```
   - Run analysis on HPC or cloud instance

4. **Path issues**:
   - Verify all paths in `config.R`
   - Use absolute paths if relative paths fail
   - Check file permissions

### Getting Help

- Check [CONTRIBUTING.md](CONTRIBUTING.md) for code standards
- Open an issue on GitHub: https://github.com/INFIMM-Bioinformatics/TB-PAXGENE/issues
- Include your session info: `sessionInfo()`

## Development Setup

For contributors:

1. Install code quality tools:
   ```R
   install.packages(c("lintr", "styler"))
   ```

2. Check code quality:
   ```R
   lintr::lint_dir(".")
   styler::style_dir(".")
   ```

3. Run tests (if available):
   ```R
   # Add testing framework if needed
   ```

## Data Access

RNA-seq data is available on GEO:
- Accession: [GSE241235](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=gse241235)

Download and place FASTQ files in `data/fastq/` directory.

## Citation

If you use this code, please cite:
- The associated publication (add DOI when available)
- nf-core/rnaseq pipeline: doi: 10.1038/s41587-020-0439-x
- DESeq2: doi: 10.1186/s13059-014-0550-8

## License

See [LICENSE](LICENSE) file for details.
