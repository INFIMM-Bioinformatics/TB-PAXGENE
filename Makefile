# Makefile for TB-PAXGENE Analysis
# Provides convenient shortcuts for common tasks

.PHONY: help setup validate quality clean render

# Default target
help:
	@echo "TB-PAXGENE Analysis - Available Commands:"
	@echo ""
	@echo "  make setup      - Set up R environment"
	@echo "  make validate   - Validate data and directory structure"
	@echo "  make quality    - Run code quality checks"
	@echo "  make render     - Render all analysis documents"
	@echo "  make clean      - Clean temporary files"
	@echo "  make help       - Show this help message"
	@echo ""

# Set up the R environment
setup:
	@echo "Setting up R environment..."
	Rscript -e 'if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv"); renv::restore()'
	@echo "Setup complete!"

# Validate data files
validate:
	@echo "Validating data files..."
	Rscript validate_data.R

# Run code quality checks
quality:
	@echo "Running code quality checks..."
	Rscript check_code_quality.R

# Render all analysis documents
render:
	@echo "Rendering analysis documents..."
	@echo "Note: This requires all data files to be present"
	Rscript -e 'quarto::quarto_render("analysis/")'

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	rm -rf analysis/*_cache
	rm -rf analysis/*_files
	rm -rf analysis/_site
	rm -f *.tmp
	rm -f .Rhistory
	@echo "Clean complete!"

# Generate quality metrics badge
badge:
	@echo "Generating quality metrics..."
	Rscript generate_quality_badge.R
