# TB-PAXGENE Project Documentation

## Overview

This repository contains the bioinformatics analysis pipeline for monkey blood PAXGENE tubes bulk RNA-seq data, investigating tuberculosis vaccine responses.

## Project Structure

```
TB-PAXGENE/
├── README.md                    # Main project documentation
├── SETUP.md                     # Detailed setup instructions
├── CONTRIBUTING.md              # Contribution guidelines
├── LICENSE                      # Project license
├── config.R                     # Configuration and path management
├── Makefile                     # Task automation
├── .lintr                       # R code linting configuration
├── .Rprofile                    # R environment initialization
├── .gitignore                   # Git ignore rules
├── renv.lock                    # R package versions
│
├── R/                           # R utility scripts
│   ├── helper_functions.R       # Common analysis functions
│   ├── move.R                   # File management script
│   └── session_info_template.R  # Session documentation template
│
├── analysis/                    # Analysis scripts and documents
│   ├── 0_generate_nextflow_input.R    # Generate pipeline input
│   ├── 1_data_processing.qmd          # RNA-seq mapping documentation
│   ├── 3_cleaning_qc_pca_analysis.qmd # Data cleaning and QC
│   ├── 4_DGE_analysis.qmd             # Differential expression
│   ├── 5_vacc_pre_pathway_enrichment.qmd  # Pathway enrichment
│   ├── 6_correlation_late_response.qmd    # Correlation analysis
│   └── _quarto.yml                    # Quarto configuration
│
├── data/                        # Data files (not in git)
│   ├── fastq/                   # Raw FASTQ files
│   ├── reference/               # Reference genome files
│   ├── nextflow_outputdir/      # Pipeline output
│   ├── figure/                  # Generated figures
│   └── DElist/                  # Differential expression results
│
├── .github/                     # GitHub configuration
│   └── workflows/
│       └── r-code-quality.yml   # CI/CD for code quality
│
├── check_code_quality.R         # Code quality check script
├── validate_data.R              # Data validation script
└── generate_quality_badge.R     # Quality metrics generator
```

## Key Components

### Configuration Management

**config.R**: Centralized configuration for all paths and parameters
- Reference genome paths
- Data directories
- Analysis parameters
- Environment variable support

### Quality Assurance

1. **Code Quality Tools**
   - `.lintr`: Linting configuration
   - `check_code_quality.R`: Quality check script
   - GitHub Actions workflow for CI/CD

2. **Package Management**
   - `renv`: Reproducible R environment
   - `renv.lock`: Locked package versions

3. **Data Validation**
   - `validate_data.R`: Validates data files and structure

### Analysis Pipeline

The analysis follows a sequential workflow:

1. **Data Preparation** (`0_generate_nextflow_input.R`)
   - Generates input samplesheet for nf-core/rnaseq
   - Validates FASTQ file presence

2. **RNA-seq Mapping** (`1_data_processing.qmd`)
   - Documents RNA-seq mapping using nf-core/rnaseq
   - HISAT2/Salmon or Salmon-only pipelines

3. **Data Cleaning and QC** (`3_cleaning_qc_pca_analysis.qmd`)
   - Quality control checks
   - Sample filtering
   - PCA analysis (Figure 4a)

4. **Differential Expression** (`4_DGE_analysis.qmd`)
   - DESeq2 analysis
   - Comparison of post-immunization vs baseline
   - Volcano plots and gene lists

5. **Pathway Enrichment** (`5_vacc_pre_pathway_enrichment.qmd`)
   - fGSEA pathway analysis
   - Bubble plots (Figure 4b)

6. **Correlation Analysis** (`6_correlation_late_response.qmd`)
   - GSVA pathway scores
   - Correlation with late vaccine response (Figure 4c)

## Key Technologies

### RNA-seq Processing
- **nf-core/rnaseq** v3.12.0: Community-curated RNA-seq pipeline
- **HISAT2**: Read alignment
- **Salmon**: Transcript quantification
- **FastQC**: Quality control
- **Trim Galore**: Adapter trimming

### Statistical Analysis
- **DESeq2**: Differential expression
- **fGSEA**: Pathway enrichment
- **GSVA**: Gene set variation analysis

### Visualization
- **ggplot2**: Primary plotting
- **EnhancedVolcano**: Volcano plots
- **corrplot**: Correlation matrices
- **ggpubr**: Publication-ready plots

### Data Management
- **tidyverse**: Data manipulation (dplyr, tidyr, etc.)
- **tidybulk**: Bulk RNA-seq analysis
- **SummarizedExperiment**: Genomic data containers

## Reproducibility Features

### 1. Version Control
- Git for code versioning
- GitHub for collaboration
- Tagged releases for publications

### 2. Package Management
- renv for R package versions
- Locked Bioconductor version (3.17)
- R version specified (4.3.2)

### 3. Configuration
- Centralized path management
- Environment variable support
- Portable across systems

### 4. Documentation
- Comprehensive README
- Detailed setup guide
- Inline code comments
- Session information tracking

### 5. Quality Assurance
- Automated code quality checks
- Data validation scripts
- Continuous integration

## Data Availability

- **GEO Accession**: [GSE241235](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=gse241235)
- **Reference Genome**: Macaca fascicularis 6.0 (Ensembl 109)
- **Sample Count**: 30 RNA-seq samples

## Computational Requirements

### Minimum Requirements
- **RAM**: 16 GB
- **Storage**: 100 GB
- **CPU**: 4 cores
- **OS**: Linux/macOS/Windows (with WSL2)

### Recommended for Full Pipeline
- **RAM**: 32+ GB
- **Storage**: 500 GB
- **CPU**: 40+ cores
- **HPC**: Access to cluster for RNA-seq mapping

## Usage

### Quick Start
```bash
# Clone repository
git clone https://github.com/INFIMM-Bioinformatics/TB-PAXGENE.git
cd TB-PAXGENE

# Setup R environment
make setup

# Validate data
make validate

# Check code quality
make quality
```

### Full Analysis
See [SETUP.md](SETUP.md) for detailed instructions.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code style guidelines
- Development workflow
- Pull request process
- Quality standards

## Citation

If you use this code or data, please cite:
- Associated publication (add DOI when available)
- nf-core/rnaseq: doi: 10.1038/s41587-020-0439-x
- DESeq2: doi: 10.1186/s13059-014-0550-8

## License

See [LICENSE](LICENSE) file for details.

## Contact

- **Repository**: https://github.com/INFIMM-Bioinformatics/TB-PAXGENE
- **Issues**: https://github.com/INFIMM-Bioinformatics/TB-PAXGENE/issues

## Acknowledgments

- nf-core community for RNA-seq pipeline
- Bioconductor project for analysis tools
- Computerome 2.0 for computational resources
