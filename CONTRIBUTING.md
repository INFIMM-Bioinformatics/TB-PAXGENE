# Contributing to TB-PAXGENE

Thank you for your interest in contributing to the TB-PAXGENE project! This document provides guidelines for contributing to the project.

## Code of Conduct

We expect all contributors to be respectful and considerate in their interactions.

## Getting Started

### Prerequisites

- R version 4.3.2 or higher
- RStudio (recommended)
- Git

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/INFIMM-Bioinformatics/TB-PAXGENE.git
   cd TB-PAXGENE
   ```

2. Install R dependencies using renv:
   ```R
   # R will automatically activate renv when you open the project
   # If needed, restore packages manually:
   renv::restore()
   ```

3. Configure paths in `config.R` to match your system.

## Code Standards

### R Code Style

We follow the [tidyverse style guide](https://style.tidyverse.org/) with some modifications:

- **Line length**: Maximum 120 characters
- **Naming**: Use `snake_case` for variables and functions
- **Indentation**: Use 2 spaces (no tabs)
- **Comments**: Add comments to explain complex logic
- **File headers**: Include purpose and author information

### Code Quality Tools

- **lintr**: For static code analysis
  ```R
  lintr::lint_dir(".")
  ```

- **styler**: For automatic code formatting
  ```R
  styler::style_dir(".")
  ```

### Reproducibility Standards

1. **No hardcoded paths**: Use `config.R` for all paths
2. **Use relative paths**: Leverage the `here` package
3. **Document dependencies**: Update `renv.lock` when adding packages
4. **Environment variables**: Use for system-specific configurations

### Documentation

- Add roxygen2-style comments for functions
- Update README.md with significant changes
- Document analysis steps in Quarto/RMarkdown files
- Include session information in analysis outputs

## Workflow

### Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following the code standards

3. Test your changes:
   ```R
   # Run relevant analysis scripts
   # Check for errors
   ```

4. Lint your code:
   ```R
   lintr::lint_dir(".")
   ```

5. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of changes"
   ```

6. Push and create a pull request:
   ```bash
   git push origin feature/your-feature-name
   ```

### Pull Request Process

1. Ensure your code passes all checks
2. Update documentation as needed
3. Link to relevant issues
4. Request review from maintainers

## Analysis Pipeline

The analysis follows this sequence:

1. `0_generate_nextflow_input.R` - Generate input for nextflow
2. `1_data_processing.qmd` - RNA-seq mapping documentation
3. `3_cleaning_qc_pca_analysis.qmd` - Data cleaning and QC
4. `4_DGE_analysis.qmd` - Differential gene expression
5. `5_vacc_pre_pathway_enrichment.qmd` - Pathway enrichment
6. `6_correlation_late_response.qmd` - Correlation analysis

## Reporting Issues

When reporting issues, please include:

- R version and package versions
- Operating system
- Complete error messages
- Minimal reproducible example

## Questions?

For questions or discussions, please open an issue on GitHub.

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).
